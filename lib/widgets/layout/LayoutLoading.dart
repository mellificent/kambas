import 'package:flutter/material.dart';
import 'package:kambas/constants/app_colors.dart';

class LayoutLoading extends StatelessWidget {
  final Color? progressColor;

  const LayoutLoading({
    Key? key,
    this.progressColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, top: 40),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(progressColor ?? AppColors.PrimaryColor),
        ),
      ),
    );
  }
}
