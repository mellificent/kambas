import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class DialogProgressTitle extends StatelessWidget {
  final String title;
  final TextStyle? titleTextStyle;

  final double? borderRadius;
  final EdgeInsets? padding;
  final Color? bgColor;
  final bool isWeb;

  const DialogProgressTitle({
    super.key,
    required this.title,
    this.titleTextStyle,
    this.padding,
    this.borderRadius,
    this.bgColor,
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    double _borderRadius = borderRadius ?? 12.0;

    final dialogTitle = Text(title,
        textAlign: TextAlign.center,
        style: titleTextStyle ??
            const TextStyle(
              fontFamily: AppStrings.FONT_POPPINS_REGULAR,
              fontSize: 17,
              color: AppColors.PrimaryColor,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal,
            ));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ClipRect(
          child: SizedBox(
            width: (isWeb) ? 520 : double.infinity, //todo: custom view
            child: Container(
              alignment: Alignment.center,
              child: Wrap(
                children: [
                  Dialog(
                    backgroundColor: bgColor ?? Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_borderRadius)),
                    child: Container(
                      padding: padding ?? const EdgeInsets.all(26.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // _dialogIcon,
                          dialogTitle,
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
