import 'package:flutter/widgets.dart';

class AppRoutes extends InheritedWidget {
  static AppRoutes of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppRoutes>()!;

  const AppRoutes({required Widget child, Key? key})
      : super(key: key, child: child);

  final String splashScreen = '/splashScreen';
  final String loginScreen = '/loginScreen';
  final String mainScreen = '/mainScreen';
  final String betPageScreen = '/betPageScreen';
  final String amountPageScreen = '/amountPageScreen';
  final String checkoutScreen = '/checkoutScreen';
  final String mainAdminScreen = '/mainAdminScreen';
  final String exportScreen = '/exportScreen';
  final String userManagementScreen = '/userManagementScreen';
  final String createUserScreen = '/createUserScreen';
  final String updateUserScreen = '/updateUserScreen';
  final String generalSettingsScreen = '/generalSettingsScreen';
  final String reprintScreen = '/reprintScreen';

  @override
  bool updateShouldNotify(AppRoutes oldWidget) => false;
}
