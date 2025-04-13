import 'package:flutter/material.dart';
import 'package:testflutter/screens/home_screen.dart';
import 'package:testflutter/screens/register_screen.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(), // Halaman home
      },
    );
  }
}
