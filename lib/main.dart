import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/routes/app_router.dart';
import 'core/utils/app_theme.dart';

void main() {
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
