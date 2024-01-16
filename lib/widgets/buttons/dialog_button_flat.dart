import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class DialogButtonFlat extends StatelessWidget {
  final VoidCallback onPressed;

  final String text;
  final TextStyle? textStyle;

  final bool? enabled;

  final double? height;
  final double? width;
  final double? borderRadius;

  final EdgeInsets? padding;

  final Color? borderColor;
  final Color? bgColor;

  const DialogButtonFlat({super.key,
    required this.onPressed,
    required this.text,
    this.height,
    this.width,
    this.padding,
    this.enabled,
    this.borderColor,
    this.borderRadius,
    this.bgColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    double widgetHeight = height ?? 54;

    bool buttonEnabled = enabled ?? true;

    Color getBackgroundColor(Set<MaterialState> states) {
      return (buttonEnabled)
          ? bgColor ?? (borderColor ?? Colors.red)
          : AppColors.White;
    }

    EdgeInsetsGeometry getPadding(Set<MaterialState> states) {
      return padding ??
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0);
    }

    return SizedBox(
      height: widgetHeight,
      child: LayoutBuilder(builder: (context, constraints) {
        double radius = constraints.maxWidth / 2;
        return TextButton(
          onPressed: (buttonEnabled) ? onPressed : () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
                (states) => getBackgroundColor(states)),
            padding: MaterialStateProperty.resolveWith(
                (states) => getPadding(states)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? radius),
                side: BorderSide(
                  color: (buttonEnabled)
                      ? (borderColor ?? (bgColor ?? Colors.red))
                      : AppColors.White,
                  width: 1,
                ),
              ),
            ),
          ),
          child: Text(
            text,
            style: textStyle ??
                const TextStyle(fontSize: 20, color: AppColors.Black),
          ),
        );
      }),
    );
  }
}
