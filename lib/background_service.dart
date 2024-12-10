// import 'dart:async';
// import 'package:barbermate/data/services/push_notification/push_notification.dart';
// import 'package:barbermate/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';

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

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Ensure Firebase and Notifications are initialized
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await NotificationServiceRepository.instance.setUpFlutterNotifications();
//   await NotificationServiceRepository.instance.showNotification(message);

//   print("Background notification received: ${message.messageId}");
// }

// @pragma('vm:entry-point')
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
