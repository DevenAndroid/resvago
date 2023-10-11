import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final Color color;
  final String? Function(String?)? validator;
  final TextInputType? keyboardtype;


  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText, required this.color, this.validator, this.keyboardtype,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(

        style: const TextStyle(color: Colors.white),
        controller: controller,
        validator: validator,
        keyboardType: keyboardtype,
        obscureText: obscureText,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: InputBorder.none,
          errorStyle: const TextStyle(color: Colors.red),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            fillColor: color,
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

