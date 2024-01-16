import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';

class ButtonRaised extends StatelessWidget {
  final VoidCallback onPressed;

  final String text;
  final TextStyle? textStyle;

  final bool? enabled;

  final double? height;
  final double? width;
  final double? borderRadius;

  final EdgeInsets? margin;

  final Color? borderColor;
  final Color? bgColor;
  final Color? buttonDisabledColor;

  const ButtonRaised({
    super.key,
    required this.onPressed,
    required this.text,
    this.height,
    this.width,
    this.margin,
    this.enabled,
    this.borderColor,
    this.borderRadius,
    this.bgColor,
    this.textStyle,
    this.buttonDisabledColor,
  });

  @override
  Widget build(BuildContext context) {
    double widgetWidth = width ?? double.infinity;
    double widgetHeight = height ?? 50;

    bool buttonEnabled = enabled ?? true;

    Color getBackgroundColor(Set<MaterialState> states) {
      /** TODO : add setting of background depend on state <-
       * for now return muna default background only **/
      // const Set<MaterialState> interactiveStates = <MaterialState>{
      //   MaterialState.pressed,
      //   MaterialState.hovered,
      //   MaterialState.focused,
      // };
      // if (states.any(interactiveStates.contains)) {
      //   return Colors.blue;
      // }
      // return Colors.red;

      return (buttonEnabled)
          ? bgColor ?? (borderColor ?? AppColors.PrimaryColor)
          : buttonDisabledColor ?? AppColors.disabledWhite;
    }

    return Container(
      margin: margin ?? EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      width: widgetWidth,
      height: widgetHeight,
      child: LayoutBuilder(builder: (context, constraints) {
        double radius = constraints.maxWidth / 2;
        return ElevatedButton(
          onPressed: (buttonEnabled) ? onPressed : () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
                (states) => getBackgroundColor(states)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? radius),
                side: BorderSide(
                  color: (buttonEnabled)
                      ? (borderColor ?? (bgColor ?? AppColors.PrimaryColor))
                      : buttonDisabledColor ?? AppColors.disabledWhite,
                  width: 1,
                ),
              ),
            ),
          ),
          child: Text(
            text,
            style: textStyle ??
                const TextStyle(
                    fontSize: 16,
                    color: AppColors.White,
                    fontFamily: AppStrings.FONT_POPPINS_REGULAR,
                    fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        );
      }),
    );
  }
}
