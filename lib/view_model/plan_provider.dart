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

  Future<void> _persistPlans() async {
    await _storage.saveWorkoutPlans(_plans);
  }
}
