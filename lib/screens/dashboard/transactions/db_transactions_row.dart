import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kambas/models/object/TransactionRowItem.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_strings.dart';

class TransactionRowItem extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isOnHoverEnabled;

  final TransactionRowItemData item;

  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const TransactionRowItem({
    super.key,
    required this.item,
    required this.onPressed,
    required this.isOnHoverEnabled,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {

    return TextButton(
      style: TextButton.styleFrom().copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(MaterialState.hovered)) {
                  return AppColors.scaffoldBGColor;
                }

                return AppColors.White;
                },
        ),
      ),
      onPressed: (isOnHoverEnabled) ? onPressed : null,
      child: Row(
        children: [
          _buildRowText(2, item.ticketNumber, isHeader: !isOnHoverEnabled,),
          _buildRowText(2, item.stallName, isHeader: !isOnHoverEnabled),
          _buildRowText(4, item.dateTimePlaced, isHeader: !isOnHoverEnabled),
          _buildRowText(2, item.cutOff, isHeader: !isOnHoverEnabled,),
          _buildRowText(2, item.betNumber1.toString(), isHeader: !isOnHoverEnabled),
          _buildRowText(2, item.betNumber2.toString(), isHeader: !isOnHoverEnabled,),
          _buildRowText(2, item.betAmount.toString(), isHeader: !isOnHoverEnabled,),
          _buildRowText(2, item.encodedByUserName, isHeader: !isOnHoverEnabled, maxTextLines: 2),
        ],
      ),
    );
  }

  Widget _buildRowText(int flex, String text, {bool isHeader = false, Color? statusColor, int? maxTextLines}) => Expanded(
    flex: flex,
    child: Padding(
      padding: (isHeader) ? const EdgeInsets.fromLTRB(0, 0.0, 12.0, 12.0) : const EdgeInsets.fromLTRB(0, 8.0, 8.0, 8.0),
      child: AutoSizeText(text,
          textAlign: TextAlign.start,
          maxFontSize: 17.0,
          minFontSize: 12.0,
          maxLines: maxTextLines ?? 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 14.0,
              color: statusColor ?? AppColors.TextColorBlack56,
              fontFamily: (isHeader) ? AppStrings.FONT_INTER_BOLD: AppStrings.FONT_INTER_REGULAR),
      ),
    ),
  );
}
