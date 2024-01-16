import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:kambas/constants/app_colors.dart';
import 'package:kambas/constants/app_strings.dart';

class DropDownStyle1 extends StatelessWidget {
  final Function() onTap;
  final String? hintText;
  final String? errorMessage;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const DropDownStyle1(
      {required this.onTap,
      this.hintText,
      this.controller,
      this.errorMessage,
      this.suffixIcon,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: IgnorePointer(
        child: AutoSizeTextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            fillColor: Colors.white,
            hintText: hintText ?? '',
            filled: true,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.zero,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.PrimaryColor,),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
          style: const TextStyle(
              fontSize: 14,
              overflow: TextOverflow.fade,
              fontFamily: AppStrings.FONT_POPPINS_REGULAR,
              color: AppColors.TextColorBlack56),
          maxLines: 1 ,
          maxFontSize: 16,
          minFontSize: 10,
        ),
      ),
    );
  }
}
