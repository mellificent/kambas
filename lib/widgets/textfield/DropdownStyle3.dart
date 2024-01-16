import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kambas/constants/app_colors.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/widgets/textfield/border_style1/CustomOutlineInputBorder1.dart';

class DropDownStyle3 extends StatelessWidget {
  final Function(String?) onChanged;
  final String formId;
  final String label;
  final List<String> options;
  final String? initialValue;

  const DropDownStyle3(
      {super.key,
      required this.onChanged,
      required this.formId,
      required this.label,
      required this.options,
      this.initialValue,
      });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      items: options
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      value: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            fontSize: 16,
            fontFamily: AppStrings.FONT_POPPINS_REGULAR,
            color: AppColors.TextFieldHint_TextColor),
        floatingLabelStyle: const TextStyle(
            fontSize: 14,
            fontFamily: AppStrings.FONT_POPPINS_REGULAR,
            color: AppColors.TextFieldHint_TextColor),
        filled: true,
        fillColor: AppColors.PrimaryColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        border: CustomOutlineInputBorder1(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.PrimaryColor,
          ),
        ),
        enabledBorder: CustomOutlineInputBorder1(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.PrimaryColor,
          ),
        ),
        focusedBorder: CustomOutlineInputBorder1(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.PrimaryColor,
          ),
        ),
      ),
      buttonStyleData: const ButtonStyleData(width: double.infinity),
      style: const TextStyle(
          fontSize: 15,
          overflow: TextOverflow.ellipsis,
          fontFamily: AppStrings.FONT_POPPINS_REGULAR,
          color: AppColors.TextColorBlack56),
      iconStyleData: IconStyleData(
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.TextColorBlack56.withOpacity(0.7),
        ),
        iconSize: 24,
      ),
      dropdownStyleData: const DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0)),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
