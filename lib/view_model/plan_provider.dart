import 'package:flutter/widgets.dart';

import '../core/services/notification_service.dart';
import '../data/offline/hive.dart';
import '../model/checklist_item.dart';
import '../model/reminder_settings.dart';
import '../model/workout_plan.dart';

class PlanProvider extends ChangeNotifier with WidgetsBindingObserver {
  PlanProvider({
    required HiveStorage storage,
  }) : _storage = storage {
    _reminderDraft = _storage.getReminderDraft();
    _plans = _storage.getWorkoutPlans();
    WidgetsBinding.instance.addObserver(this);
    _initializePlanState();
  }

  final HiveStorage _storage;
  late ReminderSettings _reminderDraft;
  late final List<WorkoutPlan> _plans;

  ReminderSettings get reminderDraft => _reminderDraft;
  List<WorkoutPlan> get plans => List.unmodifiable(_plans);
  WorkoutPlan? get latestPlan {
    if (_plans.isEmpty) {
      return null;
    }

    WorkoutPlan latest = _plans.first;
    for (final WorkoutPlan plan in _plans.skip(1)) {
      if (plan.createdAt.isAfter(latest.createdAt)) {
        latest = plan;
      }
    }

    return latest;
  }

  Future<void> _initializePlanState() async {
    await _applyDailyChecklistResets();
    await _syncNotifications();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initializePlanState();
    }
  }

  Future<void> _syncNotifications() async {
    await NotificationService.instance.syncPlans(_plans);
  }

  Future<void> _applyDailyChecklistResets() async {
    bool changed = false;
    final List<WorkoutPlan> updatedPlans = <WorkoutPlan>[];

    for (final WorkoutPlan plan in _plans) {
      final WorkoutPlan refreshedPlan = _planWithResetIfNeeded(plan);
      if (!_plansEqual(plan, refreshedPlan)) {
        changed = true;
      }
      updatedPlans.add(refreshedPlan);
    }

    if (!changed) {
      return;
    }

    _plans
      ..clear()
      ..addAll(updatedPlans);
    await _persistPlans();
    await NotificationService.instance.syncPlans(_plans);
    notifyListeners();
  }

  WorkoutPlan _planWithResetIfNeeded(WorkoutPlan plan) {
    final DateTime now = DateTime.now();
    final DateTime nextWorkoutDateTime = _nextWorkoutDateTime(
      plan.reminderSettings,
      now,
    );
    final DateTime resetBoundary = nextWorkoutDateTime.subtract(
      const Duration(hours: 6),
    );
    final String workoutDateKey = _dateKey(nextWorkoutDateTime);

    if (now.isBefore(resetBoundary) ||
        plan.lastChecklistResetKey == workoutDateKey) {
      return plan;
    }

    final List<ChecklistItem> resetItems = plan.items
        .map(
          (item) => item.copyWith(isChecked: false),
        )
        .toList();

    return plan.copyWith(
      items: resetItems,
      lastChecklistResetKey: workoutDateKey,
    );
  }

  bool _plansEqual(WorkoutPlan first, WorkoutPlan second) {
    if (first.id != second.id ||
        first.title != second.title ||
        first.lastChecklistResetKey != second.lastChecklistResetKey ||
        first.items.length != second.items.length) {
      return false;
    }

    for (int index = 0; index < first.items.length; index++) {
      final ChecklistItem firstItem = first.items[index];
      final ChecklistItem secondItem = second.items[index];
      if (firstItem.id != secondItem.id ||
          firstItem.title != secondItem.title ||
          firstItem.isChecked != secondItem.isChecked) {
        return false;
      }
    }

    return true;
  }

  DateTime _nextWorkoutDateTime(
    ReminderSettings settings,
    DateTime now,
  ) {
    DateTime workoutDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      settings.hour,
      settings.minute,
    );

    if (!workoutDateTime.isAfter(now)) {
      workoutDateTime = workoutDateTime.add(const Duration(days: 1));
    }

    return workoutDateTime;
  }
  String _dateKey(DateTime dateTime) {
    final String month = dateTime.month.toString().padLeft(2, '0');
    final String day = dateTime.day.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day';
  }

  WorkoutPlan? getPlanById(String id) {
    final int index = _plans.indexWhere((plan) => plan.id == id);
    if (index == -1) {
      return null;
    }

    return _plans[index];
  }

  Future<void> updateReminderDraft(ReminderSettings settings) async {
    _reminderDraft = settings;
    await _storage.saveReminderDraft(_reminderDraft);
    notifyListeners();
  }

  Future<void> resetReminderDraft() async {
    _reminderDraft = const ReminderSettings();
    await _storage.saveReminderDraft(_reminderDraft);
    notifyListeners();
  }

  Future<WorkoutPlan?> createPlanFromChecklist(List<ChecklistItem> items) async {
    if (items.isEmpty) {
      return null;
    }

    final DateTime now = DateTime.now();
    final WorkoutPlan plan = WorkoutPlan(
      id: now.microsecondsSinceEpoch.toString(),
      title: '${_reminderDraft.periodLabel} Workout Plan',
      items: items
          .map(
            (item) => ChecklistItem(
              id: item.id,
              title: item.title,
              isChecked: item.isChecked,
            ),
          )
          .toList(),
      reminderSettings: _reminderDraft,
      createdAt: now,
      lastChecklistResetKey: null,
    );

    _plans.insert(0, plan);
    _reminderDraft = const ReminderSettings();
    await _persistPlans();
    await _storage.saveReminderDraft(_reminderDraft);
    await NotificationService.instance.showPlanCreatedNotification(plan);
    await NotificationService.instance.schedulePlanNotifications(plan);
    notifyListeners();
    return plan;
  }

  Future<void> togglePlanItem(String planId, String itemId) async {
    final WorkoutPlan? plan = getPlanById(planId);
    if (plan == null) {
      return;
    }

    final int itemIndex = plan.items.indexWhere((item) => item.id == itemId);
    if (itemIndex == -1) {
      return;
    }

    final List<ChecklistItem> updatedItems = List<ChecklistItem>.from(plan.items);
    final ChecklistItem item = updatedItems[itemIndex];
    updatedItems[itemIndex] = item.copyWith(isChecked: !item.isChecked);

    await _replacePlan(
      planId,
      plan.copyWith(items: updatedItems),
    );
  }

  Future<void> updatePlanItem(
    String planId,
    String itemId,
    String title,
  ) async {
    final String trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return;
    }

    final WorkoutPlan? plan = getPlanById(planId);
    if (plan == null) {
      return;
    }

    final int itemIndex = plan.items.indexWhere((item) => item.id == itemId);
    if (itemIndex == -1) {
      return;
    }

    final List<ChecklistItem> updatedItems = List<ChecklistItem>.from(plan.items);
    updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
      title: trimmedTitle,
    );

    await _replacePlan(
      planId,
      plan.copyWith(items: updatedItems),
    );
  }

  Future<void> deletePlanItem(String planId, String itemId) async {
    final WorkoutPlan? plan = getPlanById(planId);
    if (plan == null) {
      return;
    }

    final List<ChecklistItem> updatedItems = plan.items
        .where((item) => item.id != itemId)
        .toList();

    await _replacePlan(
      planId,
      plan.copyWith(items: updatedItems),
    );
  }

  Future<void> updatePlanReminder(
    String planId,
    ReminderSettings reminderSettings,
  ) async {
    final WorkoutPlan? plan = getPlanById(planId);
    if (plan == null) {
      return;
    }

    await _replacePlan(
      planId,
      plan.copyWith(
        title: '${reminderSettings.periodLabel} Workout Plan',
        reminderSettings: reminderSettings,
        lastChecklistResetKey: null,
      ),
    );
  }

  Future<void> deletePlan(String planId) async {
    final int index = _plans.indexWhere((plan) => plan.id == planId);
    if (index == -1) {
      return;
    }

    _plans.removeAt(index);
    await _persistPlans();
    await NotificationService.instance.cancelPlanNotifications(planId);
    notifyListeners();
  }

  Future<void> _replacePlan(
    String planId,
    WorkoutPlan updatedPlan,
  ) async {
    final int index = _plans.indexWhere((plan) => plan.id == planId);
    if (index == -1) {
      return;
    }

    _plans[index] = updatedPlan;
    await _persistPlans();
    await NotificationService.instance.schedulePlanNotifications(updatedPlan);
    notifyListeners();
  }

  Future<void> _persistPlans() async {
    await _storage.saveWorkoutPlans(_plans);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
