import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.text});

  final VoidCallback? onPressed;

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 9, 88, 152),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}


