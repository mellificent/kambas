import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import '../constants/app_routes.dart';
import '../constants/app_strings.dart';
import '../widgets/buttons/dialog_button_flat.dart';

class DialogContentOptions extends StatelessWidget {
  final VoidCallback onOption1Pressed;
  final VoidCallback onOption2Pressed;

  final VoidCallback? onCancelled;

  final String? icon;
  final String? title;
  final TextStyle? titleTextStyle;
  final String? content;
  final TextStyle? contentTextStyle;

  final String? redButtonText;
  final String? greenButtonText;

  final Color? greenButtonBGColor;
  final Color? redButtonBGColor;
  final TextStyle? buttonTextStyle;

  final double? borderRadius;
  final EdgeInsets? padding;
  final Color? bgColor;

  final bool relogin;
  final bool isWeb;

  const DialogContentOptions({
    super.key,
    required this.onOption1Pressed,
    required this.onOption2Pressed,
    this.relogin = false,
    this.onCancelled,
    this.icon,
    this.title,
    this.titleTextStyle,
    this.content,
    this.contentTextStyle,
    this.padding,
    this.borderRadius,
    this.bgColor,
    this.redButtonText,
    this.greenButtonText,
    this.greenButtonBGColor,
    this.redButtonBGColor,
    this.buttonTextStyle,
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    double _borderRadius = borderRadius ?? 12.0;
    int _dialogButton1Flex =
        ((redButtonText ?? "no").length <
                (greenButtonText ?? "yes").length)
            ? 2
            : 3;
    int _dialogButton2Flex = (_dialogButton1Flex == 2) ? 3 : 2;

    // TODO : ADD ENABLING OF BUTTON OPTIONS (if applicable)
    // bool buttonEnabled = enabled ?? true;

    final _dialogTitle = Container(
        child: Text(title ?? "",
            textAlign: TextAlign.center,
            style: titleTextStyle ??
                const TextStyle(
                  fontFamily: AppStrings.FONT_POPPINS_BOLD,
                  fontSize: 28,
                  color: AppColors.PrimaryColor,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                )));

    final _dialogContent = ((content ?? "").isNotEmpty) ? Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 35),
      child: Text(content ?? "",
          textAlign: TextAlign.center,
          style: contentTextStyle ??
              const TextStyle(
                fontFamily: AppStrings.FONT_POPPINS_REGULAR,
                fontSize: 14,
                color: AppColors.Black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
              )),
    ) : Container(height: 16,);

    final _dialogButton1 = DialogButtonFlat(
      padding: const EdgeInsets.all(0.0),
      onPressed: relogin
          ? () {
              Navigator.pushNamedAndRemoveUntil(context,
                  AppRoutes.of(context).splashScreen, (route) => false);
            }
          : onOption1Pressed,
      text: redButtonText ?? "no",
      borderRadius: 12,
      height: 48,
      textStyle: buttonTextStyle ?? const TextStyle(
        fontFamily: AppStrings.FONT_POPPINS_BOLD,
        fontSize: 17,
        color: AppColors.White,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal,
      ),
      bgColor: redButtonBGColor ?? Colors.red,
    );

    final _dialogButton2 = DialogButtonFlat(
      padding: const EdgeInsets.all(0.0),
      onPressed: onOption2Pressed,
      text: greenButtonText ?? "yes",
      borderRadius: 12,
      height: 48,
      textStyle: buttonTextStyle ?? const TextStyle(
        fontFamily: AppStrings.FONT_POPPINS_BOLD,
        fontSize: 17,
        color: AppColors.Black,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal,
      ),
      bgColor: greenButtonBGColor ?? AppColors.PrimaryColor,
    );

    final _dialogButtons = Container(
      margin: EdgeInsets.fromLTRB(17, 0, 17, 14),
      child: Row(
        children: [
          (greenButtonText != null)
              ? Expanded(
            flex: _dialogButton2Flex,
            child: _dialogButton2,
          )
              : Container(),
          SizedBox(
            width: 10,
          ),
          (redButtonText != null)
              ? Expanded(
                  flex: _dialogButton1Flex,
                  child: _dialogButton1,
                )
              : Container(),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: InkWell(
        onTap: onCancelled,
        child: Center(
          child: ClipRect(
            child: SizedBox(
              width: (isWeb) ? 520 : double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Dialog(
                    backgroundColor: bgColor ?? Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_borderRadius)),
                    child: Center(
                      child: Padding(
                        padding: padding ?? EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _dialogTitle,
                            _dialogContent,
                            _dialogButtons
                            /** if green button text is not set,
                             *  layout is automatically set to 1 option/button **/
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
