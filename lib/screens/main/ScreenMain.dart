import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kambas/constants/app_routes.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/mixins/FormMixins.dart';
import 'package:kambas/utils/string_extension.dart';
import 'package:kambas/widgets/buttons/button_raised.dart';
import 'package:kambas/widgets/textfield/TextFieldStyle2.dart';
import '../../../bloc/account/BlocAccount.dart';
import '../../../bloc/account/EventAccount.dart';
import '../../../bloc/account/StateAccount.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_icons.dart';
import '../../../providers/ProviderAccount.dart';

class ScreenMain extends StatelessWidget {
  const ScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => BlocAccount(
          providerAccount: RepositoryProvider.of<ProviderAccount>(context),
        ),
        child: MainLayout(),
      );
  }
}

class MainLayout extends StatelessWidget
    with FormMixins<BlocAccount, StateAccount> {
  MainLayout({super.key});

  @override
  Widget build(BuildContext context) {

    ScreenMainSettings args = const ScreenMainSettings();
    var settings = ModalRoute.of(context)?.settings.arguments;
    if (settings != null) args = settings as ScreenMainSettings;

    Widget logo = Container(
      width: 140,
      height: 80,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.PrimaryColor,
      ),
      child: SvgPicture.asset(
        AppIcons.LOGO_SVG,
        fit: BoxFit.fill,
        height: 70,
        width: 70,
      ),
    );

    Widget placeBetButton = Container(
      margin: const EdgeInsets.only(top: 20.0, bottom: 4.0),
      child: ButtonRaised(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.of(context).betPageScreen,
          ).then((value) {
            if (value == 'RequestBetNumbersDone') {
              context.read<BlocAccount>().add(RequestDisplayBetNumber());
            }
          });
        },
        text: AppStrings.place_bet,
        textStyle: const TextStyle(
            fontSize: 14.0,
            color: AppColors.TextColorBlack56,
            fontWeight: FontWeight.bold,
            fontFamily: AppStrings.FONT_POPPINS_BOLD),
        borderRadius: 9,
        height: 45.0,
        margin: EdgeInsets.zero,
      ),
    );

    Widget checkoutButton = ButtonRaised(
      onPressed: () {
        Navigator.pushNamed(
          context,
          AppRoutes.of(context).checkoutScreen,
        ).then((value) {
          if (value == "betComplete") {
            context.read<BlocAccount>().add(RequestDisplayBetNumber());
            context.read<BlocAccount>().add(RequestDisplayBetAmount());
            context.read<BlocAccount>().add(GetTerminalSettings());
          }
        });
      },
      text: AppStrings.check_out,
      textStyle: const TextStyle(
          fontSize: 14.0,
          color: AppColors.TextColorBlack56,
          fontWeight: FontWeight.bold,
          fontFamily: AppStrings.FONT_POPPINS_BOLD),
      borderRadius: 9,
      height: 45.0,
      margin: const EdgeInsets.only(bottom: 8.0, top: 13.0),
    );

    Widget reprintButton = ButtonRaised(
      onPressed: () {
        Navigator.pushNamed(
          context,
          AppRoutes.of(context).reprintScreen,
        );
      },
      text: AppStrings.reprint_ticket,
      textStyle: const TextStyle(
          fontSize: 14.0,
          color: AppColors.TextColorBlack56,
          fontWeight: FontWeight.bold,
          fontFamily: AppStrings.FONT_POPPINS_BOLD),
      borderRadius: 9,
      height: 45.0,
      margin: EdgeInsets.zero,
    );

    Widget mainBody = SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 41.0, right: 41.0, top: 0.0, bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  logo,
                  const SizedBox(
                    height: 20.0,
                  ),
                  _buildTitle(context),
                  _buildTerminalSettingView(context),
                  _buildDrawSchedule(context),
                  placeBetButton,
                  buildLabel(AppStrings.bet_placed.allInCaps()),
                  _buildBetField(context),
                  buildLabel(AppStrings.enter_amount.allInCaps()),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.of(context).amountPageScreen,
                      ).then((value) {
                        if (value == 'RequestBetAmountDone') {
                          context
                              .read<BlocAccount>()
                              .add(RequestDisplayBetAmount());
                        }
                      });
                    },
                    child: _buildBetAmountField(context),
                  ),
                  checkoutButton,
                  reprintButton,
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                AppIcons.APP_FOOTER,
                fit: BoxFit.scaleDown,
              ),
            ),
          )
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.White,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.of(context).loginScreen, (r) => false);
          },
          icon: const Icon(
            Icons.account_circle,
            size: 40.0,
            color: Colors.grey,
          ),
        ),
        actions: (args.isAdminUser ?? false) ? [
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.of(context).mainAdminScreen,
              ).then((value) => context.read<BlocAccount>().add(GetTerminalSettings()));
            },
            child: const Icon(
              Icons.settings,
              size: 40.0,
              color: AppColors.PrimaryColor,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
        ] : null,
        elevation: 0,
      ),
      body: OfflineBuilder(
          connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
              ){

            final bool connected = connectivity != ConnectivityResult.none;
            context.read<BlocAccount>().add(RequestConnectivitySync(isConnected: connected));

            return mainBody;
            // return Stack(
            //   fit: StackFit.expand,
            //   children: [
            //     mainBody,
            //     // Positioned(
            //     //   height: 24.0,
            //     //   left: 0.0,
            //     //   right: 0.0,
            //     //   child: Container(
            //     //     color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
            //     //     child: Center(
            //     //       child: Text(connected ? 'ONLINE' : 'OFFLINE'),
            //     //     ),
            //     //   ),
            //     // ),
            //   ],
            // );
          },
          child: mainBody),
    );
  }

  Widget buildLabel(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 6.0),
      child: Text(text,
          textAlign: TextAlign.start,
          style: const TextStyle(
              fontSize: 12.0,
              color: AppColors.TextColorGray56,
              fontWeight: FontWeight.w500,
              fontFamily: AppStrings.FONT_POPPINS_REGULAR)),
    );
  }

  _buildTitle(BuildContext context) => buildWidget(
        context,
        id: "mainTitle",
        buildWhen: (id, previous, current) => (current is DisplayCurrentDate),
        builder: (context, state) {
          if (state is InitStateAccount) {
            context.read<BlocAccount>().add(RequestCurrentDate());
          }

          return Text(
            "Welcome ${(state is DisplayCurrentDate) ? state.text : ""}",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14.0,
                color: AppColors.TextColorBlack56,
                fontWeight: FontWeight.normal,
                letterSpacing: 1.4,
                fontFamily: AppStrings.FONT_POPPINS_REGULAR),
          );
        },
      );

  _buildTerminalSettingView(BuildContext context) => buildWidget(
    context,
    id: "terminalSettingView",
    buildWhen: (id, previous, current) => (current is DisplayTerminalSettings),
    builder: (context, state) {
      if (state is InitStateAccount) {
        context.read<BlocAccount>().add(GetTerminalSettings());
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Ticket No. ${(state is DisplayTerminalSettings) ? state.data.ticketNumber : ""}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14.0,
                  color: AppColors.TextColorBlack56,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.3,
                  height: 1.5,
                  fontFamily: AppStrings.FONT_POPPINS_REGULAR)),
          Text("Stall Name - ${(state is DisplayTerminalSettings) ? state.data.stallName : "N/A"}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14.0,
                  color: AppColors.TextColorBlack56,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 1.6,
                  height: 1.5,
                  fontFamily: AppStrings.FONT_POPPINS_REGULAR))
        ],
      );
    },
  );

  _buildDrawSchedule(BuildContext context) => buildWidget(
        context,
        id: "drawTimeTitle",
        buildWhen: (id, previous, current) => (current is DisplayDrawTime),
        builder: (context, state) {
          if (state is InitStateAccount) {
            context.read<BlocAccount>().add(RequestCurrentDate());
          }

          return Text(
            "Draw Schedule - ${(state is DisplayDrawTime) ? state.text : "N/A"}",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14.0,
                color: AppColors.TextColorBlack56,
                fontWeight: FontWeight.normal,
                letterSpacing: 1.4,
                fontFamily: AppStrings.FONT_POPPINS_REGULAR),
          );
        },
      );

  _buildBetField(BuildContext context) => buildWidget(
        context,
        id: "BetFieldLabel",
        buildWhen: (id, previous, current) =>
            (current is UpdateBetSelectedNumbers),
        builder: (context, state) => TextFieldStyle2(
          isEnabled: false,
          height: 45.0,
          controller: TextEditingController(
              text: (state is UpdateBetSelectedNumbers) ? state.text : ""),
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.done,
          textInputStyle: const TextStyle(
              fontSize: 16,
              fontFamily: AppStrings.FONT_POPPINS_BOLD,
              color: Colors.black),
        ),
      );

  _buildBetAmountField(BuildContext context) => buildWidget(
        context,
        id: "BetAmountField",
        buildWhen: (id, previous, current) => (current is DisplayBetAmount),
        builder: (context, state) => TextFieldStyle2(
          isEnabled: false,
          height: 45.0,
          controller: TextEditingController(
              text: (state is DisplayBetAmount) ? state.text : ""),
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.done,
          textInputStyle: const TextStyle(
              fontSize: 16,
              fontFamily: AppStrings.FONT_POPPINS_BOLD,
              color: Colors.black),
        ),
      );
}

class ScreenMainSettings {
  final bool? isAdminUser;

  const ScreenMainSettings({this.isAdminUser});
}
