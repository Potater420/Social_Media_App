import 'package:flutter/material.dart';
import 'package:sprints_firstapp/pages/welcome_page.dart';
import 'package:sprints_firstapp/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}
