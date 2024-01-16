
import 'package:flutter/material.dart';
import 'package:kambas/constants/app_strings.dart';

import '../../constants/app_colors.dart';

class LayoutRequestFailed extends StatelessWidget {
  final String message;
  const LayoutRequestFailed(
      {Key? key, required this.message,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            maxLines: 4,
            style: const TextStyle(
                fontSize: 34.0,
                color: AppColors.PrimaryColor,
                // fontFamily: AppStrings.FONT_POPPINS_REGULAR,
            ),
          ),
        ),
      ),
    );
  }
}
