import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'bible_verse_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    _initialized = true;
  }

  static Future<void> scheduleDailyBibleVerse() async {
    await initialize();
    
    // Cancel any existing notifications
    await _notifications.cancelAll();

    // Schedule daily notification at 10:00 AM
    await _notifications.zonedSchedule(
      0,
      'இன்றைய வேத வசனம்',
      'உங்கள் தினசரி வேத வசனத்தைப் படிக்க தட்டவும்',
      _nextInstanceOf10AM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_bible_verse',
          'Daily Bible Verse',
          channelDescription: 'Daily Bible verse notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOf10AM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      10,
      0,
    );
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }

  static Future<void> showBibleVerseNotification() async {
    await initialize();
    
    try {
      final verse = await BibleVerseService.getDailyVerse();
      
      await _notifications.show(
        1,
        'இன்றைய வேத வசனம்',
        '${verse.reference}\n${verse.verse.substring(0, verse.verse.length > 100 ? 100 : verse.verse.length)}...',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_bible_verse',
            'Daily Bible Verse',
            channelDescription: 'Daily Bible verse notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            styleInformation: BigTextStyleInformation(''),
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  static Future<void> requestPermissions() async {
    await initialize();
    
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    
    await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
