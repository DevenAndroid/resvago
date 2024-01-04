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
  final TextInputFormatter? textInputFormatter;
  final int? maxLines;
  final int? minLines;
  final Callback? ontap;
  final bool? realonly;
  final length;
  final List<TextInputFormatter>? inputFormatters;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.lableText,
    this.textInputFormatter,
    this.ontap,
    this.realonly = false,
    this.length,
    required this.obscureText,
    required this.color,
    this.validator,
    this.keyboardtype,
    this.maxLines,
    this.minLines,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: TextFormField(
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
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
          if (inputFormatters != null) ...inputFormatters!,
          LengthLimitingTextInputFormatter(length),
        ],
        decoration: InputDecoration(
            errorStyle: const TextStyle(color: Colors.red),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade800), borderRadius: const BorderRadius.all(Radius.circular(6.0))),
            fillColor: color,
            filled: true,
            hintText: hintText,
            labelText: lableText,
            labelStyle: const TextStyle(color: Colors.black),
            hintStyle: const TextStyle(color: Colors.black)),
      ),
    );
  }
}

class RegisterTextFieldWidget extends StatelessWidget {
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Widget? suffix;
  final Widget? prefix;
  final Color? bgColor;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hint;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool? readOnly;
  final dynamic value = 0;
  final dynamic minLines;
  final dynamic maxLines;
  final bool? obscureText;
  final VoidCallback? onTap;
  final length;

  const RegisterTextFieldWidget({
    Key? key,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.bgColor,
    this.validator,
    this.suffix,
    this.autofillHints,
    this.prefix,
    this.minLines = 1,
    this.maxLines = 1,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Color(0xFF384953)),
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly!,
      controller: controller,
      obscureText: hint == hint ? obscureText! : false,
      autofillHints: autofillHints,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: AppTheme.primaryColor,
      inputFormatters: [
        LengthLimitingTextInputFormatter(length),
      ],
      decoration: InputDecoration(
          hintText: hint,
          focusColor: const Color(0xFF384953),
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFF384953),
            textStyle: GoogleFonts.poppins(
              color: const Color(0xFF384953),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
            fontSize: 14,
            // fontFamily: 'poppins',
            fontWeight: FontWeight.w300,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(.10),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(6.0),
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.all(Radius.circular(6.0))),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 3.0), borderRadius: BorderRadius.circular(6.0)),
          suffixIcon: suffix,
          prefixIcon: prefix),
    );
  }
}

AppBar backAppBar(
    {required title,
    required BuildContext context,
    String dispose = "",
    Color? backgroundColor = AppTheme.backgroundcolor,
    Color? textColor = Colors.black,
    Widget? icon,
    Widget? icon2,
    disposeController}) {
  return AppBar(
    toolbarHeight: 60,
    elevation: 5,
    leadingWidth: AddSize.size22 * 1.6,
    backgroundColor: backgroundColor,
    surfaceTintColor: AppTheme.backgroundcolor,
    title: Text(
      title,
      style: GoogleFonts.poppins(color: Color(0xFF423E5E), fontWeight: FontWeight.w600, fontSize: 17),
    ),
    actions: [icon2 ?? SizedBox.shrink()],
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
