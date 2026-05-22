import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data/hadiths.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int dailyHadithId = 1001;

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
  }

  static Future<void> scheduleDailyHadithReminder({
    required bool enabled,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hadithReminderEnabled', enabled);

    await _plugin.cancel(dailyHadithId);

    if (!enabled) return;

    final hadith = _randomHadithText();

    // Test uchun yoqilgan zahoti tepada chiqadi
    await _plugin.show(
      999,
      '40 hadis eslatma yoqildi',
      hadith,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'hadith_channel',
          'Hadis eslatmalari',
          channelDescription: 'Har kuni random hadis eslatmasi',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );

    // Har kuni 09:00 da chiqadi
    await _plugin.zonedSchedule(
      dailyHadithId,
      'Kunlik hadis',
      hadith,
      _nextTime(9, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'hadith_channel',
          'Hadis eslatmalari',
          channelDescription: 'Har kuni random hadis eslatmasi',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var time = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (time.isBefore(now)) {
      time = time.add(const Duration(days: 1));
    }

    return time;
  }

  static String _randomHadithText() {
    if (hadithsList.isEmpty) {
      return 'Yaxshi so‘z sadaqadir.';
    }

    final item = hadithsList[Random().nextInt(hadithsList.length)];
    return item['full'] ?? item['short'] ?? '';
  }
}