import 'package:flutter/foundation.dart';

import '../data/offline/hive.dart';
import '../model/checklist_item.dart';
import '../model/reminder_settings.dart';
import '../model/workout_plan.dart';

class PlanProvider extends ChangeNotifier {
  PlanProvider({
    required HiveStorage storage,
  }) : _storage = storage {
    _reminderDraft = _storage.getReminderDraft();
    _plans = _storage.getWorkoutPlans();
  }

  final HiveStorage _storage;
  late ReminderSettings _reminderDraft;
  late final List<WorkoutPlan> _plans;

  ReminderSettings get reminderDraft => _reminderDraft;
  List<WorkoutPlan> get plans => List.unmodifiable(_plans);

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
    );

    _plans.insert(0, plan);
    _reminderDraft = const ReminderSettings();
    await _persistPlans();
    await _storage.saveReminderDraft(_reminderDraft);
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
      ),
    );
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
    notifyListeners();
  }

  Future<void> _persistPlans() async {
    await _storage.saveWorkoutPlans(_plans);
  }
}
