import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kambas/constants/app_colors.dart';
import 'package:kambas/constants/app_strings.dart';

class FilterCheckfield extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function onSelect;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final EdgeInsets? margin;

  const FilterCheckfield(
      {required this.isSelected,
      required this.onSelect,
      this.height,
      this.width,
      this.textStyle,
      this.margin,
      required this.text});

  @override
  Widget build(BuildContext context) {
    TextStyle style = textStyle ?? const TextStyle(color: AppColors.TextColorBlack56, fontSize: 16, fontFamily: AppStrings.FONT_POPPINS_REGULAR, fontWeight: FontWeight.w400);

    return InkWell(
      onTap: () {
        onSelect(text);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 6.0),
            alignment: Alignment.centerRight,
            child: isSelected
                ? const Icon(Icons.check_box, color: AppColors.PrimaryColor,)
                : const Icon(Icons.check_box_outline_blank),
          ),
          Expanded(
            child: AutoSizeText(text,
                maxFontSize: 16.0,
                minFontSize: 12.0,
                style: style,
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
