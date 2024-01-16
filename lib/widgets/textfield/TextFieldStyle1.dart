import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kambas/constants/app_strings.dart';

import '../../constants/app_colors.dart';

class TextFieldStyle1 extends StatelessWidget {
  final String? hintText;
  final String? errorMessage;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormat;
  final TextStyle? hintStyle;
  final TextStyle? textInputStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Color? bgColor;
  final Color? borderColor;
  final double? height;
  final Function(String?)? onChanged;

  const TextFieldStyle1({
    super.key,
    this.hintText,
    this.controller,
    this.focusNode,
    this.obscureText,
    this.errorMessage,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.textInputType,
    this.inputFormat,
    this.hintStyle,
    this.textInputStyle,
    this.contentPadding,
    this.bgColor,
    this.borderColor,
    this.height,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: height ?? 55.0,
          // color: Colors.white,
          child: TextFormField(
            focusNode: focusNode,
            controller: controller,
            onChanged: onChanged,
            keyboardType: textInputType,
            textInputAction: textInputAction,
            inputFormatters: inputFormat,
            decoration: InputDecoration(
              fillColor: bgColor ?? AppColors.DisabledPrimaryColor,
              hintText: hintText ?? '',
              hintStyle: hintStyle ??
                  const TextStyle(
                      fontSize: 16,
                      // fontFamily: AppStrings.FONT_POPPINS_REGULAR,
                      color: AppColors.TextFieldHint_TextColor),
              filled: true,
              prefixIcon: (prefixIcon != null) ? Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: prefixIcon,
              ) : null,
              suffixIcon: suffixIcon,
              contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: (errorMessage != null)
                      ? Colors.red
                      : borderColor ?? AppColors.DisabledPrimaryColor,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: (errorMessage != null)
                      ? Colors.red
                      :  borderColor ?? AppColors.DisabledPrimaryColor,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
            cursorColor: AppColors.PrimaryColor,
            obscureText: obscureText ?? false,
            style: textInputStyle ??
                const TextStyle(
                  fontSize: 16,
                  fontFamily: AppStrings.FONT_POPPINS_REGULAR,
                ),
          ),
        ),
        if (errorMessage != null)
          Container(
            margin: const EdgeInsets.only(top: 8, left: 8),
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          )
      ],
    );
  }
}
