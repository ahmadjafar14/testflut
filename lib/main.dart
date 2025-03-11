import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'styles/app_styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppStyles.primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: AppStyles.primaryColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: AppStyles.buttonStyle(context),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
