// import 'dart:async';
// import 'package:barbermate/data/services/push_notification/push_notification.dart';
// import 'package:barbermate/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       autoStartOnBoot: true,
//       isForegroundMode: false,
//       autoStart: true, // Automatically start the service
//     ),
//     iosConfiguration: IosConfiguration(
//       autoStart: true,
//       onForeground: null,
//       onBackground: null,
//     ),
//   );
// }

// Future<void> showNotification(RemoteMessage message) async {
//   final localNofitications = FlutterLocalNotificationsPlugin();
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//   if (notification != null && android != null) {
//     await localNofitications.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       const NotificationDetails(
//           android: AndroidNotificationDetails(
//         'hight_importance_channel',
//         'High Importance Notifications',
//         channelDescription: 'This channel is used for important notifications',
//         importance: Importance.high,
//         priority: Priority.high,
//         icon: '@mipmap/ic_launcher',
//       )),
//       payload: message.data.toString(),
//     );
//   }
// }

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Ensure Firebase and Notifications are initialized
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await NotificationServiceRepository.instance.setUpFlutterNotifications();
//   await showNotification(message);

//   print("Background notification received: ${message.messageId}");
// }

// void onStart(ServiceInstance service) async {
//   // Set up FCM background handling
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   // Handle termination
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

//   // Keep the service alive with a periodic task
//   Timer.periodic(const Duration(seconds: 5), (timer) {
//     print('Background service is running...');
//     service.invoke('update');
//   });
// }
