import 'package:flutter/material.dart';
import 'package:ventur_2/screens/home_screen.dart';
import 'package:ventur_2/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
