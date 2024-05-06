import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kambas/bloc/dashboard/BlocDashboard.dart';
import 'package:kambas/bloc/dashboard/EventDashboard.dart';
import 'package:kambas/bloc/dashboard/StateDashboard.dart';
import 'package:kambas/constants/app_colors.dart';
import 'package:kambas/constants/app_icons.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/mixins/FormMixins.dart';
import 'package:kambas/models/object/TransactionRowItem.dart';
import 'package:kambas/providers/ProviderAccount.dart';
import 'package:kambas/utils/config/SizeConfig.dart';
import 'package:kambas/widgets/appbar/custom_main_appbar.dart';
import 'package:kambas/widgets/layout/LayoutLoading.dart';
import 'package:kambas/widgets/layout/LayoutRequestFailed.dart';
import 'package:kambas/widgets/textfield/CustomDropdown.dart';

import 'transactions/db_transactions_row.dart';

class ScreenDashboard extends StatelessWidget {
  const ScreenDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlocDashboard(
        providerAccount: RepositoryProvider.of<ProviderAccount>(context),
      ),
      child: DashboardWebBody(),
    );
  }
}

class DashboardWebBody extends StatelessWidget
    with FormMixins<BlocDashboard, StateDashboard> {
  DashboardWebBody({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    Widget initLayout() {
      context.read<BlocDashboard>().add(const RequestGetBetList());
      return const LayoutLoading();
    }

    Widget transactionCard(List<TransactionRowItemData> data) {
      return Card(
        color: AppColors.White,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader("Bet Summary"),
              const SizedBox(height: 40),
              TransactionRowItem(
                isOnHoverEnabled: false,
                item: TransactionRowItemData(
                    0,
                  ticketNumber: AppStrings.ticket_number,
                  cutOff: AppStrings.cut_off,
                  stallName: AppStrings.stall_name,
                  location: AppStrings.location,
                  betNumber1: AppStrings.bet1,
                  betNumber2: AppStrings.bet2,
                  dateTimePlaced: AppStrings.datetime_placed,
                  betAmount: AppStrings.betAmount,
                  betPrize: "Bet Prize",
                  encodedByUserName: AppStrings.encodedBy,
                ),
                onPressed: () {},
              ),

              Column(
                children: data
                    .map((e) => TransactionRowItem(
                          isOnHoverEnabled: true,
                          item: e,
                          onPressed: () {
                            debugPrint(
                                "transaction pressed :: ${e.betId}");
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 30),
              // _buildTransactionPagination(context)
            ],
          ),
        ),
      );
    }

    Widget dashboardLayout(List<TransactionRowItemData> transactionsData) {
      //SetDashboardData state
      return Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(kToolbarHeight + 10),
        //   child: Container(
        //       margin: const EdgeInsets.symmetric(horizontal: 30.0),
        //       child: const CustomMainAppBar(
        //         isMobile: false,
        //       )),
        // ),
        backgroundColor: AppColors.scaffoldBGColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 120.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Padding(
              //   padding: EdgeInsets.only(left: 10.0, bottom: 20.0),
              //   child: Text(
              //     "AppStrings.dashboard",
              //     style: TextStyle(
              //         fontSize: 36,
              //         fontFamily: AppStrings.FONT_POPPINS_REGULAR,
              //         fontWeight: FontWeight.w600,
              //         color: AppColors.TextColorBlack56),
              //   ),
              // ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: transactionCard(transactionsData),
                  ),
                  // Expanded(
                  //   flex: 3,
                  //   child: filterCard(
                  //       state.dropdownDateRangeText, state.filterData),
                  // ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return BlocBuilder<BlocDashboard, StateDashboard>(
      buildWhen: (previous, current) =>
          (current is InitStateDashboard || current is SetDashboardData || current is RequestFailed),
      builder: (context, state) {
        if (state is InitStateDashboard) return initLayout();

        if (state is SetDashboardData) {
          return dashboardLayout(state.transactionsData);
        }

        if (state is RequestFailed) {
          return LayoutRequestFailed(message: state.error);
        }

        return Container();
      },
    );
  }

Widget _buildCardHeader(String title, {String desc = ""}) => Row(
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                fontFamily: AppStrings.FONT_POPPINS_REGULAR,
                fontWeight: FontWeight.w600,
                color: AppColors.TextColorBlack56),
          ),
          (desc.isNotEmpty)
              ? Text(
            desc,
            style: const TextStyle(
                fontSize: 16,
                fontFamily: AppStrings.FONT_POPPINS_REGULAR,
                fontWeight: FontWeight.w400,
                color: AppColors.SideMenuTextColor),
          )
              : Container()
        ],
      ),
    ),
    // SvgPicture.asset(
    //   AppIcons.REPORT_DOWNLOAD,
    //   height: 16.0,
    //   width: 16.0,
    // )
  ],
);

}
