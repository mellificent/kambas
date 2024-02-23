import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/widgets/textfield/border_style1/CustomOutlineInputBorder1.dart';

import '../../constants/app_colors.dart';

class TextFieldStyle2 extends StatelessWidget {
  final String? labelText;
  final String? errorMessage;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? obscureText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormat;
  final TextStyle? labelStyle;
  final TextStyle? textInputStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Color? bgColor;
  final Color? borderColor;
  final double? height;
  final Function(String?)? onChanged;
  final bool? isEnabled;
  final Widget? suffixIcon;
  final TextAlign? textAlignment;

  const TextFieldStyle2({
    super.key,
    this.labelText,
    this.controller,
    this.focusNode,
    this.obscureText,
    this.errorMessage,
    this.textInputAction,
    this.textInputType,
    this.inputFormat,
    this.labelStyle,
    this.textInputStyle,
    this.contentPadding,
    this.bgColor,
    this.borderColor,
    this.height,
    this.onChanged,
    this.isEnabled,
    this.suffixIcon,
    this.textAlignment,
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
          child: TextFormField(
            enabled: isEnabled ?? true,
            focusNode: focusNode,
            controller: controller,
            onChanged: onChanged,
            textAlign: textAlignment ?? TextAlign.center,
            keyboardType: textInputType,
            textInputAction: textInputAction,
            inputFormatters: inputFormat,
            decoration: InputDecoration(
              fillColor: bgColor ?? AppColors.DisabledPrimaryColor,
              filled: true,
              hintText: labelText,
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
                  Radius.circular(20),
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
                  Radius.circular(20),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: (errorMessage != null)
                      ? Colors.red
                      :  borderColor ?? AppColors.DisabledPrimaryColor,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
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