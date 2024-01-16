import '../../constants/app_icons.dart';

class TabMain {
  const TabMain(this.position, this.icon, this.title);
  final int position;
  final String icon;
  final String title;
}

const List<TabMain> ALL_MAIN_TABS = <TabMain>[
  // TabMain(TAB_ITEM_DASHBOARD, AppIcons.TAB_DASHBOARD_SVG, AppStrings.dashboard),
  // TabMain(TAB_ITEM_ORDERS, AppIcons.TAB_ORDERS_SVG, AppStrings.orders),
  // TabMain(TAB_ITEM_SOA, AppIcons.TAB_SOA_SVG, AppStrings.statement_of_account),
  // TabMain(TAB_ITEM_TRACKING, AppIcons.TAB_TRACKING_SVG, AppStrings.tracking),
  // TabMain(TAB_ITEM_WIDGETS, AppIcons.TAB_WIDGETS_SVG, AppStrings.widgets),
  // TabMain(TAB_ITEM_HELP, AppIcons.TAB_HELP_SVG, AppStrings.help),
  // TabMain(TAB_ITEM_TUTORIALS, AppIcons.TAB_TUTORIALS_SVG, AppStrings.tutorials)
];

const int TAB_ITEM_DASHBOARD = 0;
const int TAB_ITEM_ORDERS = 1;
const int TAB_ITEM_SOA = 2;
const int TAB_ITEM_TRACKING = 3;
const int TAB_ITEM_WIDGETS = 4;
const int TAB_ITEM_HELP = 5;
const int TAB_ITEM_TUTORIALS = 6;