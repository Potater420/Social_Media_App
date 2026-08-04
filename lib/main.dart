import 'package:flutter/material.dart';
import 'package:sprints_firstapp/pages/welcome_page.dart';
import 'package:sprints_firstapp/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
