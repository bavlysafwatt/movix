// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// import '../helpers/shared_pref_helper.dart';
//
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notifications =
//   FlutterLocalNotificationsPlugin();
//
//   static Future<void> init() async {
//     tz.initializeTimeZones();
//
//     final timezoneName = (await FlutterTimezone.getLocalTimezone()).identifier;
//     try {
//       tz.setLocalLocation(tz.getLocation(timezoneName));
//     } catch (e) {
//       debugPrint('Timezone error: $e, falling back to UTC');
//       tz.setLocalLocation(tz.getLocation('UTC'));
//     }
//
//     const androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     await _notifications.initialize(
//       const InitializationSettings(android: androidSettings, iOS: iosSettings),
//     );
//
//     if (Platform.isAndroid) {
//       final androidImpl = _notifications
//           .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//
//       await androidImpl?.requestNotificationsPermission();
//       await androidImpl?.requestExactAlarmsPermission();
//     }
//
//     await cancelAllNotifications();
//     await scheduleOrCancelDailyReminder();
//   }
//
//   static Future<void> scheduleOrCancelDailyReminder() async {
//     final isEnabled = SharedPrefHelper.isDailyReminderEnabled();
//
//     if (isEnabled) {
//       await scheduleDailyNotification(
//         id: 1,
//         title: 'Daily Reminder',
//         body: "Don't forget to track your expenses today 💰",
//         hour: 18,
//         minute: 0,
//       );
//     } else {
//       await cancelNotification(1);
//     }
//   }
//
//   static Future<void> scheduleDailyNotification({
//     required int id,
//     required String title,
//     required String body,
//     required int hour,
//     required int minute,
//   }) async {
//     try {
//       await _notifications.zonedSchedule(
//         id,
//         title,
//         body,
//         _nextInstanceOfTime(hour, minute),
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'daily_notification_channel',
//             'Daily Notifications',
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//           iOS: DarwinNotificationDetails(),
//         ),
//         uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         matchDateTimeComponents: DateTimeComponents.time,
//       );
//     } catch (e) {
//       debugPrint('NotificationService schedule error: $e');
//     }
//   }
//
//   static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
//     final now = tz.TZDateTime.now(tz.local);
//     var scheduledDate = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       hour,
//       minute,
//     );
//
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//
//     debugPrint('NOW: $now');
//     debugPrint('SCHEDULED FOR: $scheduledDate');
//     debugPrint('TIMEZONE: ${tz.local.name}');
//
//     return scheduledDate;
//   }
//
//   static Future<void> cancelNotification(int id) async {
//     await _notifications.cancel(id);
//   }
//
//   static Future<void> cancelAllNotifications() async {
//     await _notifications.cancelAll();
//   }
// }