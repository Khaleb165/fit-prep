import 'package:hive_flutter/hive_flutter.dart';

import '../../model/checklist_item.dart';

class HiveStorage {
  HiveStorage._();

  static final HiveStorage instance = HiveStorage._();

  static const String _settingsBoxName = 'settings_box';
  static const String _checklistBoxName = 'checklist_box';
  static const String _firstTimeKey = 'is_first_time';
  static const String _checklistItemsKey = 'checklist_items';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_settingsBoxName);
    await Hive.openBox(_checklistBoxName);
  }

  Box get _settingsBox => Hive.box(_settingsBoxName);
  Box get _checklistBox => Hive.box(_checklistBoxName);

  bool getIsFirstTime() {
    return _settingsBox.get(_firstTimeKey, defaultValue: true) as bool;
  }

  Future<void> setIsFirstTime(bool value) async {
    await _settingsBox.put(_firstTimeKey, value);
  }

  List<ChecklistItem> getChecklistItems() {
    final List<dynamic> rawItems = (_checklistBox.get(
          _checklistItemsKey,
          defaultValue: <dynamic>[],
        ) as List)
        .cast<dynamic>();

    return rawItems
        .map(
          (item) => ChecklistItem.fromMap(
            Map<dynamic, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<void> saveChecklistItems(List<ChecklistItem> items) async {
    final List<Map<String, dynamic>> serializedItems = items
        .map((item) => item.toMap())
        .toList();

    await _checklistBox.put(_checklistItemsKey, serializedItems);
  }
}
