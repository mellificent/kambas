import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../constants/app_colors.dart';
import 'package:universal_html/js.dart' as js;

class WebTextFieldStyle1 extends StatelessWidget {
  final double heightPercent;
  final double widthPercent;
  final String? hintText;
  final String? errorMessage;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextStyle? hintStyle;
  final TextStyle? textInputStyle;

  const WebTextFieldStyle1({
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
    this.hintStyle,
    this.textInputStyle,
    required this.heightPercent,
    required this.widthPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: heightPercent,
          width: widthPercent,
          child: TextFormField(
            onTap: () async {
              if (UniversalPlatform.isMacOS || UniversalPlatform.isIOS) return;
              if(textInputType == TextInputType.visiblePassword && (focusNode?.hasFocus ?? false)){
                focusNode?.unfocus();
                Future.microtask(() {
                  focusNode?.requestFocus();
                  js.context.callMethod("fixPasswordCss", []);
                });
              }
            },
            focusNode: focusNode,
            controller: controller,
            keyboardType: textInputType,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              fillColor: AppColors.grayEAEAE4,
              hintText: hintText ?? '',
              hintStyle: hintStyle ??
                  const TextStyle(
                      fontSize: 16,
                      color: AppColors.TextFieldHint_TextColor),
              filled: true,
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: prefixIcon,
              ),
              suffixIcon: Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: suffixIcon),
              contentPadding: const EdgeInsets.all(0.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: (errorMessage != null)
                      ? AppColors.red
                      : AppColors.grayEAEAE4,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: (errorMessage != null)
                      ? AppColors.red
                      : AppColors.grayEAEAE4,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
            cursorColor: AppColors.PrimaryColor,
            obscureText: obscureText ?? false,
            style: textInputStyle ??
                const TextStyle(
                  fontSize: 16,
                ),
          ),
        ),
        if (errorMessage != null)
          Container(
            margin: const EdgeInsets.only(top: 8, left: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          )
      ],
    );
  }
}
