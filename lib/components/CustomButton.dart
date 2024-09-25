// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.underlinedText,
    required this.buttonText,
    required this.pageRoute,
    required this.text,
    this.onPressed,
  });

  final String buttonText;
  final String text;
  final String underlinedText;
  final GestureTapCallback pageRoute;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            foregroundColor: const Color(0xFF023020),
            backgroundColor: Colors.white,
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              hoverColor: Colors.transparent,
              onTap: pageRoute,
              child: Text(
                underlinedText,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white60,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white60,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
