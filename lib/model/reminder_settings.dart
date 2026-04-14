import 'package:flutter/material.dart';

import '../core/utils/utils.dart';

class ReminderSettings {
  const ReminderSettings({
    this.selectedPeriodIndex = 0,
    this.hour = 7,
    this.minute = 0,
    this.remindBefore = true,
  });

  final int selectedPeriodIndex;
  final int hour;
  final int minute;
  final bool remindBefore;

  ReminderSettings copyWith({
    int? selectedPeriodIndex,
    int? hour,
    int? minute,
    bool? remindBefore,
  }) {
    return ReminderSettings(
      selectedPeriodIndex: selectedPeriodIndex ?? this.selectedPeriodIndex,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      remindBefore: remindBefore ?? this.remindBefore,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'selectedPeriodIndex': selectedPeriodIndex,
      'hour': hour,
      'minute': minute,
      'remindBefore': remindBefore,
    };
  }

  factory ReminderSettings.fromMap(Map<dynamic, dynamic> map) {
    final int legacyHourIndex = map['selectedHourIndex'] as int? ?? 6;
    final int legacyMinuteIndex = map['selectedMinuteIndex'] as int? ?? 0;
    final int legacyMeridiemIndex = map['selectedMeridiemIndex'] as int? ?? 0;

    return ReminderSettings(
      selectedPeriodIndex: map['selectedPeriodIndex'] as int? ?? 0,
      hour: map['hour'] as int? ??
          _to24Hour(
            legacyHourIndex + 1,
            legacyMeridiemIndex == 0,
          ),
      minute: map['minute'] as int? ?? int.parse(minutes[legacyMinuteIndex]),
      remindBefore: map['remindBefore'] as bool? ?? true,
    );
  }

  String get periodLabel => periods[selectedPeriodIndex];

  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  String formatTime(BuildContext context) {
    return MaterialLocalizations.of(context).formatTimeOfDay(
      timeOfDay,
      alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
    );
  }

  String get reminderLabel =>
      remindBefore ? '1 hour before' : 'At packing time';

  static int _to24Hour(int hour, bool isAm) {
    if (isAm) {
      return hour == 12 ? 0 : hour;
    }

    return hour == 12 ? 12 : hour + 12;
  }
}
