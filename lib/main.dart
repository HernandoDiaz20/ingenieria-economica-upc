import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/calculators/simple_interest_screen.dart';
import 'screens/calculators/compound_interest_screen.dart';
import 'screens/calculators/interest_rate_screen.dart';
import 'screens/calculators/annuities_screen.dart';
import 'screens/calculators/amortization_screen.dart';
import 'screens/calculators/gradients_screen.dart';
import 'screens/calculators/capitalization_screen.dart';
import 'screens/calculators/tir_screen.dart';
import 'screens/forgot_password_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ingeniería Económica',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomeScreen(), // ← Pantalla inicial
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/simple-interest': (context) => SimpleInterestScreen(),
        '/compound-interest': (context) => CompoundInterestScreen(),
        '/interest-rate': (context) => InterestRateScreen(),
        '/annuities': (context) => AnnuitiesScreen(),
        '/gradients': (context) => GradientsScreen(),
        '/amortization': (context) => AmortizationScreen(),
        '/capitalization': (context) => CapitalizationScreen(),
        '/tir': (context) => TirScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
