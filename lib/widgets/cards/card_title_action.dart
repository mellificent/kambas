import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_strings.dart';

class CardTitleAction extends StatelessWidget {
  final VoidCallback onPressed;

  final String title;
  final TextStyle? titleTextStyle;

  final String valueText;
  final TextStyle? valueTextStyle;

  final String icon;

  final double? height;
  final double? width;
  final double? borderRadius;

  final EdgeInsets? margin;
  final EdgeInsets? padding;

  final Color? borderColor;
  final Color? bgColor;

  final String? bgImage;
  final int? maxLines;

  const CardTitleAction({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.title,
    required this.valueText,
    this.titleTextStyle,
    this.valueTextStyle,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.borderColor,
    this.borderRadius,
    this.bgColor,
    this.bgImage,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    double widgetWidth = width ?? double.infinity;
    double? widgetHeight = height;

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: margin ?? const EdgeInsets.all(0.0), //EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          color: AppColors.White,
          height: widgetHeight,
          width: widgetWidth,
          padding: padding ?? EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: 32.0,
                width: 40.0,
              ),
              SizedBox(height: 9.0,),
              Text(valueText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: valueTextStyle ?? const TextStyle(
                fontSize: 40,
                fontFamily: AppStrings.FONT_POPPINS_REGULAR,
                color: AppColors.TextColorBlack56,
              ),),
              SizedBox(height: 7.0,),
              Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: titleTextStyle ?? const TextStyle(
                fontSize: 20,
                fontFamily: AppStrings.FONT_POPPINS_REGULAR,
                color: AppColors.TextColorBlack56,
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
