import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_media_app/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
      goToWelcome,
    );
  }

  void goToWelcome() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const WelcomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people,
                size: 90,
              ),

              SizedBox(height: 20),

              Text(
                'ConnectHub',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10),

              Text(
                'Share, Connect, and Discover.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),

              SizedBox(height: 30),

              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}