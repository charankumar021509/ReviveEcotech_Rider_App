import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {

    FirebaseMessaging messaging =
        FirebaseMessaging.instance;

    await messaging.requestPermission(

      alert: true,

      badge: true,

      sound: true,
    );

    const AndroidInitializationSettings
        androidSettings =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher');

    const InitializationSettings
        settings =
        InitializationSettings(

      android:
          androidSettings,
    );

    await flutterLocalNotificationsPlugin
        .initialize(settings);

    FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {

      RemoteNotification?
          notification =
          message.notification;

      if (notification != null) {

        flutterLocalNotificationsPlugin
            .show(

          0,

          notification.title,

          notification.body,

          const NotificationDetails(

            android:
                AndroidNotificationDetails(

              'high_importance_channel',

              'High Importance Notifications',

              importance:
                  Importance.max,

              priority:
                  Priority.high,
            ),
          ),
        );
      }
    });
  }

  static Future<String?>
      getToken() async {

    return await FirebaseMessaging
        .instance
        .getToken();
  }

  static Future<void>
      showLocalNotification({

    required String title,

    required String body,
  }) async {

    await flutterLocalNotificationsPlugin
        .show(

      0,

      title,

      body,

      const NotificationDetails(

        android:
            AndroidNotificationDetails(

          'pickup_channel',

          'Pickup Notifications',

          importance:
              Importance.max,

          priority:
              Priority.high,
        ),
      ),
    );
  }
}