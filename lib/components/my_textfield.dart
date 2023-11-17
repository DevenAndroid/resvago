import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

import 'addsize.dart';
import 'appassets.dart';
import 'apptheme.dart';

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
AppBar backAppBar({required title,
  required BuildContext context,
  String dispose = "",
  Color? backgroundColor = AppTheme.backgroundcolor,
  Color? textColor = Colors.black,
  Widget? icon,
  Widget? icon2,
  disposeController}) {
  return AppBar(
    toolbarHeight: 60,
    elevation: 0,
    leadingWidth: AddSize.size22 * 1.6,
    backgroundColor: backgroundColor,
    surfaceTintColor: AppTheme.backgroundcolor,
    title: Text(
      title,
      style: GoogleFonts.poppins(color: Color(0xFF423E5E),
          fontWeight: FontWeight.w600,
          fontSize: 17),
    ),
    actions: [
      icon2 ?? SizedBox.shrink()
    ],
    leading: Padding(
      padding: EdgeInsets.only(left: AddSize.padding10),
      child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: icon ??
              Image.asset(
                AppAssets.back,
                height: AddSize.size15,
              )),
    ),
  );
}