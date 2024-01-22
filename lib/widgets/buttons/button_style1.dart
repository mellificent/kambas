import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kambas/constants/app_colors.dart';
import 'package:kambas/constants/app_strings.dart';

class ButtonStyle1 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool enabled;
  final Color? backgroundColor;
  final Color? enabledTextArrowColor;
  final IconData? icon;
  final double? iconSize;
  final EdgeInsets? margin;

  const ButtonStyle1(
      {required this.text,
      required this.onPressed,
      this.enabled = true,
      this.backgroundColor,
      this.enabledTextArrowColor,
      this.icon,
      this.iconSize,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      height: 45,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(9),
            ),
          ),
          backgroundColor:
              enabled ? backgroundColor ?? AppColors.PrimaryColor : Colors.grey,
        ),
        onPressed: enabled ? onPressed : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            (icon != null)
                ? Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: Icon(
                      icon,
                      color: enabled
                          ? enabledTextArrowColor ?? Colors.black
                          : Colors.black,
                      size: 20.0,
                    ),
                  )
                : Container(),
            Text(
              text,
              style: const TextStyle(
                  fontSize: 14.0,
                  color: AppColors.TextColorBlack56,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppStrings.FONT_POPPINS_BOLD),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
