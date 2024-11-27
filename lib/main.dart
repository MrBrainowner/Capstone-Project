import 'package:barbermate/routes/app_pages.dart';
import 'package:barbermate/utils/popups/animation_loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toastification/toastification.dart';
import 'bindings/general_bindings.dart';
import 'data/repository/auth_repo/auth_repo.dart';
import 'firebase_options.dart';
import 'utils/themes/barbermate_theme.dart';

void main() async {
  //======================================= Widgets Binding
  final WidgetsBinding widgetBinding =
      WidgetsFlutterBinding.ensureInitialized();
  //======================================= Getx Local Storage
  await GetStorage.init();

  //======================================= Splash Screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);

  //======================================= Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  //======================================= Initialize Authentication

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: BarbermateTheme.lightTheme,
        darkTheme: BarbermateTheme.darktTheme,
        initialBinding: GeneralBindings(),
        smartManagement: SmartManagement.full,
        home: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: const Center(
            child: AnimationLoaderr(),
          ),
        ),
      ),
    );
  }
}
