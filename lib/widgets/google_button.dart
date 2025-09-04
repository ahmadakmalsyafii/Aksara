import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GoogleButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/google.png", height: 40), //
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
