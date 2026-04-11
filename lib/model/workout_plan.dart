import 'checklist_item.dart';
import 'reminder_settings.dart';

class WorkoutPlan {
  const WorkoutPlan({
    required this.id,
    required this.title,
    required this.items,
    required this.reminderSettings,
    required this.createdAt,
    this.lastChecklistResetKey,
  });

  final String id;
  final String title;
  final List<ChecklistItem> items;
  final ReminderSettings reminderSettings;
  final DateTime createdAt;
  final String? lastChecklistResetKey;

  WorkoutPlan copyWith({
    String? id,
    String? title,
    List<ChecklistItem>? items,
    ReminderSettings? reminderSettings,
    DateTime? createdAt,
    String? lastChecklistResetKey,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      items: items ?? this.items,
      reminderSettings: reminderSettings ?? this.reminderSettings,
      createdAt: createdAt ?? this.createdAt,
      lastChecklistResetKey: lastChecklistResetKey ?? this.lastChecklistResetKey,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'items': items.map((item) => item.toMap()).toList(),
      'reminderSettings': reminderSettings.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'lastChecklistResetKey': lastChecklistResetKey,
    };
  }

  factory WorkoutPlan.fromMap(Map<dynamic, dynamic> map) {
    final List<dynamic> rawItems =
        (map['items'] as List<dynamic>? ?? <dynamic>[]).cast<dynamic>();

    return WorkoutPlan(
      id: map['id'] as String,
      title: map['title'] as String,
      items: rawItems
          .map(
            (item) => ChecklistItem.fromMap(
              Map<dynamic, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      reminderSettings: ReminderSettings.fromMap(
        Map<dynamic, dynamic>.from(
          map['reminderSettings'] as Map? ?? <dynamic, dynamic>{},
        ),
      ),
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      lastChecklistResetKey: map['lastChecklistResetKey'] as String?,
    );
  }
}
