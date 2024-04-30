import 'package:flutter/material.dart';

class UsersCustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final IconData iconData;
  final String hintText;
  final String validationText;
  final bool isObscured;
  final bool isEnabled;

  const UsersCustomTextFormField({super.key,
    required this.controller,
    required this.iconData,
    required this.hintText,
    required this.validationText,
    this.isObscured = true,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderOnForeground: true,
      elevation: 3.0,
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
          enabled: isEnabled,
          controller: controller,
          obscureText: isObscured,
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              iconData,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$value is required';
            }
            return null;
          },
        ),
      ),
    );
  }
}
