import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../model/checklist_item.dart';
import '../../model/reminder_settings.dart';
import '../../model/workout_plan.dart';
import '../theme/app_colors.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String _channelId = 'fit_prep_notifications';
  static const String _channelName = 'Fit Prep Notifications';
  static const String _channelDescription =
      'Notifications for workout plans, reminders, and packing alerts.';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    tz.initializeTimeZones();
    await _configureLocalTimezone();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
    _isInitialized = true;
  }

  Future<void> ensurePermissions() async {
    if (!_isInitialized) {
      await init();
    }

    try {
      await _requestPermissions();
    } catch (_) {
      // Permission requests should never block app usage.
    }
  }

  Future<void> showPlanCreatedNotification(WorkoutPlan plan) async {
    try {
      await _plugin.show(
        _successNotificationId(plan.id),
        'Plan created',
        '${plan.title} has been saved successfully.',
        _notificationDetails(),
      );
    } catch (_) {
      // Notification failures should not block the save flow.
    }
  }

  Future<void> schedulePlanNotifications(WorkoutPlan plan) async {
    try {
      await cancelPlanNotifications(plan.id);
      await _scheduleWorkoutReminder(plan);
      await _schedulePackingReminder(plan);
    } catch (_) {
      // Scheduling should fail softly so the rest of the app keeps working.
    }
  }

  Future<void> cancelPlanNotifications(String planId) async {
    try {
      await _plugin.cancel(_reminderNotificationId(planId));
      await _plugin.cancel(_packingNotificationId(planId));
    } catch (_) {
      // Ignore cancellation failures from stale or missing notifications.
    }
  }

  Future<void> syncPlans(List<WorkoutPlan> plans) async {
    for (final WorkoutPlan plan in plans) {
      await schedulePlanNotifications(plan);
    }
  }

  Future<bool> _canScheduleExactAlarms() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    return await androidPlugin?.canScheduleExactNotifications() ?? false;
  }

  Future<void> _configureLocalTimezone() async {
    try {
      final String timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
  }

  Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _scheduleWorkoutReminder(WorkoutPlan plan) async {
    final ReminderSettings settings = plan.reminderSettings;
    final tz.TZDateTime scheduledDate = _nextReminderDate(settings);

    final bool canScheduleExact = await _canScheduleExactAlarms();

    await _plugin.zonedSchedule(
      _reminderNotificationId(plan.id),
      'Gym reminder',
      settings.remindBefore
          ? 'Your ${settings.periodLabel.toLowerCase()} workout is in 1 hour.'
          : 'It is time for your ${settings.periodLabel.toLowerCase()} workout.',
      scheduledDate,
      _notificationDetails(),
      androidScheduleMode: canScheduleExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _schedulePackingReminder(WorkoutPlan plan) async {
    final List<ChecklistItem> uncheckedItems =
        plan.items.where((item) => !item.isChecked).toList();

    if (uncheckedItems.isEmpty) {
      await _plugin.cancel(_packingNotificationId(plan.id));
      return;
    }

    final bool canScheduleExact = await _canScheduleExactAlarms();

    await _plugin.zonedSchedule(
      _packingNotificationId(plan.id),
      'Pack your gym bag',
      _packingReminderBody(
        uncheckedItems: uncheckedItems,
        totalItemCount: plan.items.length,
      ),
      _nextReminderDate(plan.reminderSettings),
      _notificationDetails(),
      androidScheduleMode: canScheduleExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  NotificationDetails _notificationDetails() {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      color: AppColors.deepBlue,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  tz.TZDateTime _nextReminderDate(ReminderSettings settings) {
    DateTime reminderTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      settings.hour,
      settings.minute,
    );

    if (settings.remindBefore) {
      reminderTime = reminderTime.subtract(const Duration(hours: 1));
    }

    if (!reminderTime.isAfter(DateTime.now())) {
      reminderTime = reminderTime.add(const Duration(days: 1));
    }

    return tz.TZDateTime.from(reminderTime, tz.local);
  }
  String _packingReminderBody({
    required List<ChecklistItem> uncheckedItems,
    required int totalItemCount,
  }) {
    final List<String> itemTitles =
        uncheckedItems.map((item) => item.title).toList();

    if (itemTitles.isEmpty || uncheckedItems.length == totalItemCount) {
      return 'Pack for the gym today.';
    }

    final String packedItems = _formatItems(itemTitles);

    return itemTitles.length == 1
        ? 'You forgot to pack $packedItems for the gym.'
        : 'You forgot to pack these items for the gym: $packedItems.';
  }

  String _formatItems(List<String> items) {
    if (items.length == 1) {
      return items.first;
    }

    if (items.length == 2) {
      return '${items.first} and ${items.last}';
    }

    final String firstItems = items.sublist(0, items.length - 1).join(', ');
    return '$firstItems, and ${items.last}';
  }

  int _successNotificationId(String planId) =>
      (_baseNotificationId(planId) + 2) & 0x7fffffff;

  int _reminderNotificationId(String planId) =>
      _baseNotificationId(planId) & 0x7fffffff;

  int _packingNotificationId(String planId) =>
      (_baseNotificationId(planId) + 1) & 0x7fffffff;

  int _baseNotificationId(String planId) => planId.hashCode.abs() * 10;
}
