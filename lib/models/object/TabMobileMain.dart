import 'package:flutter/material.dart';

import '../../constants/app_icons.dart';

class TabMobile {
  const TabMobile(this.position, this.icon, this.title);
  final int position;
  final Icon icon; //update to svg
  final String? title;
}

const List<TabMobile> ALL_TABMOBILE = <TabMobile>[
  // TabMobile(TAB_ITEM_HOME, Icon(Icons.home), AppStrings.home),
  // TabMobile(TAB_ITEM_MOBILE_DASHBOARD, Icon(Icons.bar_chart), AppStrings.dashboard),
  // TabMobile(TAB_ITEM_ADD, Icon(Icons.add, color: AppColors.White,), ''),
  // TabMobile(TAB_ITEM_NOTIFICATION, Icon(Icons.notifications), AppStrings.notifications),
  // TabMobile(TAB_ITEM_SETTINGS, Icon(Icons.settings), AppStrings.settings)
];

const int TAB_ITEM_HOME = 0;
const int TAB_ITEM_MOBILE_DASHBOARD = 1;
const int TAB_ITEM_ADD = 2;
const int TAB_ITEM_NOTIFICATION = 3;
const int TAB_ITEM_SETTINGS = 4;