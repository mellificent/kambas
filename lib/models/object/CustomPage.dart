
import 'package:kambas/constants/app_strings.dart';

class CustomPage {
  const CustomPage(
    this.position,
    this.title,
  );
  final int position;
  final String title;
}

const List<CustomPage> ALL_ONBOARDING_PAGE = <CustomPage>[
  CustomPage(0, AppStrings.login),
  CustomPage(1, AppStrings.login),
  CustomPage(2, AppStrings.login),
  CustomPage(3, AppStrings.login),
  // CustomPage(4, AppStrings.onboarding_confirmation),
];
