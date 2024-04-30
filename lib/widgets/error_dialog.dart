import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(2.2),
            alignment: Alignment.center,
            backgroundColor: Colors.red,
            animationDuration: const Duration(milliseconds: 3000),
            elevation: 3.3,
            textStyle: const TextStyle(
              fontSize: 20,
              fontFamily: "Bebas",
            ),
          ),
          child: const Center(
            child: Center(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
