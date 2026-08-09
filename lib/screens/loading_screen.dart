import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/lotties/loading.json',
          width: 300,
          height: 300,
          errorBuilder: (context, error, stackTrace) {
            return Text(
              'Lottie Error:\n$error',
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
    );
  }
}