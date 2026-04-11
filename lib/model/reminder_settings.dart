import '../core/utils/utils.dart';

class ReminderSettings {
  const ReminderSettings({
    this.selectedPeriodIndex = 0,
    this.selectedHourIndex = 6,
    this.selectedMinuteIndex = 0,
    this.selectedMeridiemIndex = 0,
    this.remindBefore = true,
  });

  final int selectedPeriodIndex;
  final int selectedHourIndex;
  final int selectedMinuteIndex;
  final int selectedMeridiemIndex;
  final bool remindBefore;

  ReminderSettings copyWith({
    int? selectedPeriodIndex,
    int? selectedHourIndex,
    int? selectedMinuteIndex,
    int? selectedMeridiemIndex,
    bool? remindBefore,
  }) {
    return ReminderSettings(
      selectedPeriodIndex: selectedPeriodIndex ?? this.selectedPeriodIndex,
      selectedHourIndex: selectedHourIndex ?? this.selectedHourIndex,
      selectedMinuteIndex: selectedMinuteIndex ?? this.selectedMinuteIndex,
      selectedMeridiemIndex:
          selectedMeridiemIndex ?? this.selectedMeridiemIndex,
      remindBefore: remindBefore ?? this.remindBefore,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'selectedPeriodIndex': selectedPeriodIndex,
      'selectedHourIndex': selectedHourIndex,
      'selectedMinuteIndex': selectedMinuteIndex,
      'selectedMeridiemIndex': selectedMeridiemIndex,
      'remindBefore': remindBefore,
    };
  }

  factory ReminderSettings.fromMap(Map<dynamic, dynamic> map) {
    return ReminderSettings(
      selectedPeriodIndex: map['selectedPeriodIndex'] as int? ?? 0,
      selectedHourIndex: map['selectedHourIndex'] as int? ?? 6,
      selectedMinuteIndex: map['selectedMinuteIndex'] as int? ?? 0,
      selectedMeridiemIndex: map['selectedMeridiemIndex'] as int? ?? 0,
      remindBefore: map['remindBefore'] as bool? ?? true,
    );
  }

  String get periodLabel => periods[selectedPeriodIndex];

  String get timeLabel {
    final String hour = '${selectedHourIndex + 1}';
    final String minute = minutes[selectedMinuteIndex];
    final String meridiem = selectedMeridiemIndex == 0 ? 'AM' : 'PM';
    return '$hour:$minute $meridiem';
  }

  String get reminderLabel =>
      remindBefore ? '1 hour before' : 'At workout time';
}
