import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/register_screen.dart';
import 'screens/delete_account_screen.dart';  // Import Delete Account screen

void main() {
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => LoginScreen(),
      '/calculator': (context) => CalculatorScreen(),
      '/register': (context) => RegisterScreen(),
      '/deleteAccount': (context) => DeleteAccountScreen(),  // Add Delete Account route
    },
  ));
}
