import 'package:fit_prep/model/checklist_item.dart';
import 'package:fit_prep/model/reminder_settings.dart';
import 'package:fit_prep/model/workout_plan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const item = ChecklistItem(
    id: 'water-bottle',
    title: 'Water bottle',
    isChecked: true,
  );

  test('serializes the frontend reminder flow for the plans API', () {
    final plan = WorkoutPlan(
      id: 'local-id',
      title: 'Evening Workout Plan',
      items: const <ChecklistItem>[item],
      reminderSettings: const ReminderSettings(
        selectedPeriodIndex: 2,
        hour: 18,
        minute: 5,
        remindBefore: true,
      ),
      createdAt: DateTime.utc(2026),
    );

    expect(plan.toApiJson(), <String, dynamic>{
      'title': 'Evening Workout Plan',
      'items': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'water-bottle',
          'title': 'Water bottle',
          'is_checked': true,
        },
      ],
      'gym_session': 'evening',
      'packing_time': '18:05',
      'reminder': 'one_hour_before',
    });
  });

  test('server reminder policy overrides a conflicting local fallback', () {
    final fallback = WorkoutPlan(
      id: 'local-id',
      title: 'Morning Workout Plan',
      items: const <ChecklistItem>[item],
      reminderSettings: const ReminderSettings(remindBefore: false),
      createdAt: DateTime.utc(2026),
    );

    final plan = WorkoutPlan.fromApiJson(
      <String, dynamic>{
        'id': 'server-id',
        'title': 'Morning Workout Plan',
        'items': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'water-bottle',
            'title': 'Water bottle',
            'is_checked': true,
          },
        ],
        'gym_session': 'morning',
        'packing_time': '07:30',
        'reminder': 'one_hour_before',
        'created_at': '2026-08-04T09:00:00.000Z',
      },
      localFallback: fallback,
    );

    expect(plan.id, 'server-id');
    expect(plan.reminderSettings.hour, 7);
    expect(plan.reminderSettings.minute, 30);
    expect(plan.reminderSettings.remindBefore, isTrue);
  });
}
