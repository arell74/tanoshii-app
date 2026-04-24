import 'package:flutter/material.dart';
import '/screens/splash_screen.dart';
import '/theme/app_theme.dart';

void main(){
  runApp(NihonggoApp());
}

class NihonggoApp extends StatelessWidget {
  const NihonggoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nihonggo APP",
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}