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

  const ButtonStyle1(
      {required this.text, required this.onPressed, this.enabled = true, this.backgroundColor, this.enabledTextArrowColor, this.icon, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        backgroundColor: enabled
            ? this.backgroundColor ?? AppColors.PrimaryColor
            : Colors.grey,
      ),
      onPressed: enabled ? onPressed : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Text(
              text,
              style: TextStyle(
                color: enabled ? enabledTextArrowColor ?? Colors.white : Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w500,
                // fontFamily: AppStrings.FONT_INTER_REGULAR,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 4.0,),
          Icon(
            icon ?? Icons.double_arrow_rounded,
            color: enabled ? enabledTextArrowColor ?? Colors.white : Colors.white,
            size: 20.0,
          ),
        ],
      ),
    );
  }
}
