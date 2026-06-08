import 'package:hive_flutter/hive_flutter.dart';

import '../../model/checklist_item.dart';
import '../../model/reminder_settings.dart';
import '../../model/workout_plan.dart';

class HiveStorage {
  HiveStorage._();

  static final HiveStorage instance = HiveStorage._();

  static const String _settingsBoxName = 'settings_box';
  static const String _checklistBoxName = 'checklist_box';
  static const String _firstTimeKey = 'is_first_time';
  static const String _checklistItemsKey = 'checklist_items';
  static const String _reminderDraftKey = 'reminder_draft';
  static const String _workoutPlansKey = 'workout_plans';
  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _emailKey = 'email';

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
    final List<Map<String, dynamic>> serializedItems =
        items.map((item) => item.toMap()).toList();

    await _checklistBox.put(_checklistItemsKey, serializedItems);
  }

  ReminderSettings getReminderDraft() {
    final Map<dynamic, dynamic> rawDraft = Map<dynamic, dynamic>.from(
      _checklistBox.get(
        _reminderDraftKey,
        defaultValue: <dynamic, dynamic>{},
      ) as Map,
    );

    return ReminderSettings.fromMap(rawDraft);
  }

  Future<void> saveReminderDraft(ReminderSettings settings) async {
    await _checklistBox.put(_reminderDraftKey, settings.toMap());
  }

  List<WorkoutPlan> getWorkoutPlans() {
    final List<dynamic> rawPlans = (_checklistBox.get(
      _workoutPlansKey,
      defaultValue: <dynamic>[],
    ) as List)
        .cast<dynamic>();

    return rawPlans
        .map(
          (plan) => WorkoutPlan.fromMap(
            Map<dynamic, dynamic>.from(plan as Map),
          ),
        )
        .toList();
  }

  Future<void> saveWorkoutPlans(List<WorkoutPlan> plans) async {
    final List<Map<String, dynamic>> serializedPlans =
        plans.map((plan) => plan.toMap()).toList();

    await _checklistBox.put(_workoutPlansKey, serializedPlans);
  }

  Future<void> setToken(String token) async {
    await _settingsBox.put(_tokenKey, token);
  }

  String? getToken() {
    return _settingsBox.get(_tokenKey) as String?;
  }

  Future<void> setUsername(String username) async {
    await _settingsBox.put(_usernameKey, username);
  }

  String? getUsername() {
    return _settingsBox.get(_usernameKey) as String?;
  }

  Future<void> setPassword(String password) async {
    await _settingsBox.put(_passwordKey, password);
  }

  String? getPassword() {
    return _settingsBox.get(_passwordKey) as String?;
  }

  Future<void> setIsLoggedIn(bool value) async {
    await _settingsBox.put(_isLoggedInKey, value);
  }

  bool getIsLoggedIn() {
    return _settingsBox.get(_isLoggedInKey, defaultValue: false) as bool;
  }

  Future<void> setEmail(String email) async {
    await _settingsBox.put(_emailKey, email);
  }

  String? getEmail() {
    return _settingsBox.get(_emailKey) as String?;
  }
}
