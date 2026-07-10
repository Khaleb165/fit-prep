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
      lastChecklistResetKey:
          lastChecklistResetKey ?? this.lastChecklistResetKey,
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

  Map<String, dynamic> toApiJson() {
    return {
      'title': title,
      'items': items
          .map(
            (item) => {
              'id': item.id,
              'title': item.title,
              'is_checked': item.isChecked,
            },
          )
          .toList(),
      'gym_session': _gymSessionFor(reminderSettings.selectedPeriodIndex),
      'packing_time': _packingTimeFor(reminderSettings),
      'reminder': reminderSettings.remindBefore ? 'one_hour_before' : 'on_time',
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

  factory WorkoutPlan.fromApiJson(
    Map<String, dynamic> json, {
    WorkoutPlan? localFallback,
  }) {
    final List<dynamic> rawItems =
        (json['items'] as List<dynamic>? ?? <dynamic>[]).cast<dynamic>();

    return WorkoutPlan(
      id: json['id']?.toString() ?? localFallback?.id ?? '',
      title:
          json['title']?.toString() ?? localFallback?.title ?? 'Workout Plan',
      items: rawItems.isEmpty
          ? localFallback?.items ?? const <ChecklistItem>[]
          : rawItems
              .map(
                (item) => _checklistItemFromApiJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(),
      reminderSettings: _reminderSettingsFromApiJson(
        json,
        localFallback?.reminderSettings,
      ),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          localFallback?.createdAt ??
          DateTime.now(),
      lastChecklistResetKey: localFallback?.lastChecklistResetKey,
    );
  }

  static ChecklistItem _checklistItemFromApiJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      isChecked:
          json['is_checked'] as bool? ?? json['isChecked'] as bool? ?? false,
    );
  }

  static ReminderSettings _reminderSettingsFromApiJson(
    Map<String, dynamic> json,
    ReminderSettings? fallback,
  ) {
    final packingTime = json['packing_time']?.toString();
    final timeParts = packingTime?.split(':') ?? const <String>[];

    return ReminderSettings(
      selectedPeriodIndex: _periodIndexFor(json['gym_session']?.toString()) ??
          fallback?.selectedPeriodIndex ??
          0,
      hour: timeParts.length == 2
          ? int.tryParse(timeParts[0]) ?? fallback?.hour ?? 7
          : fallback?.hour ?? 7,
      minute: timeParts.length == 2
          ? int.tryParse(timeParts[1]) ?? fallback?.minute ?? 0
          : fallback?.minute ?? 0,
      remindBefore: json['reminder']?.toString() == 'on_time'
          ? false
          : fallback?.remindBefore ?? true,
    );
  }

  static int? _periodIndexFor(String? gymSession) {
    return switch (gymSession?.toLowerCase()) {
      'morning' => 0,
      'afternoon' => 1,
      'evening' => 2,
      _ => null,
    };
  }

  static String _gymSessionFor(int selectedPeriodIndex) {
    return switch (selectedPeriodIndex) {
      1 => 'afternoon',
      2 => 'evening',
      _ => 'morning',
    };
  }

  static String _packingTimeFor(ReminderSettings settings) {
    final hour = settings.hour.toString().padLeft(2, '0');
    final minute = settings.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
