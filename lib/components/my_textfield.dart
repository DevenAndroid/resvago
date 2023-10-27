import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final String? lableText;
  final Color color;
  final String? Function(String?)? validator;
  final TextInputType? keyboardtype;
  final int? maxLines;
  final int? minLines;
  final Callback? ontap;
  final bool? realonly;
  final length;


  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.lableText,
    this.ontap,
    this.realonly = false,
    this.length,
    required this.obscureText, required this.color, this.validator, this.keyboardtype, this.maxLines, this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(

        style: const TextStyle(color: Colors.white),
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        minLines: minLines,
        onTap: ontap,
        readOnly: realonly!,
        keyboardType: keyboardtype,
        obscureText: obscureText,
        cursorColor: Colors.white,
        inputFormatters: [
          LengthLimitingTextInputFormatter(length),
        ],
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
            labelText: lableText,
            labelStyle: const TextStyle(color: Colors.white),
            hintStyle: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

