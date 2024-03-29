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

  @override
  bool updateShouldNotify(AppRoutes oldWidget) => false;
}
