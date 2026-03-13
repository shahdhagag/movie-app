import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/routes/app_router.dart';
import 'core/di/injection_conatiner.dart';
import 'core/utils/app_theme.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(

      designSize: const Size(500, 1100),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Movie App',
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
            theme: AppTheme.DarkTheme,
            themeMode: ThemeMode.dark,


        );
      },
    );
  }
}
