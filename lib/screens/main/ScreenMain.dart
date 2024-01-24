import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kambas/constants/app_routes.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/mixins/FormMixins.dart';
import 'package:kambas/utils/config/SizeConfig.dart';
import 'package:kambas/utils/string_extension.dart';
import 'package:kambas/widgets/buttons/button_raised.dart';
import 'package:kambas/widgets/textfield/TextFieldStyle1.dart';
import 'package:kambas/widgets/textfield/TextFieldStyle2.dart';
import 'package:universal_platform/universal_platform.dart';
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

    ScreenMainSettings args = ScreenMainSettings();
    var settings = ModalRoute.of(context)?.settings.arguments;
    if (settings != null) args = settings as ScreenMainSettings;

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
              );
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
      body: BlocProvider(
        create: (_) => BlocAccount(
          providerAccount: RepositoryProvider.of<ProviderAccount>(context),
        ),
        child: MainLayout(),
      ),
    );
  }
}

class MainLayout extends StatelessWidget
    with FormMixins<BlocAccount, StateAccount> {
  MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    Widget logo = Image.asset(
      AppIcons.APP_LOGO,
      fit: BoxFit.fitHeight,
      height: 80,
    );

    Widget ticketNoText = const Text("Ticket No. N/A",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 14.0,
            color: AppColors.TextColorBlack56,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
            height: 1.5,
            fontFamily: AppStrings.FONT_POPPINS_REGULAR));

    Widget stallNameText = const Text("Stall Name - N/A",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 14.0,
            color: AppColors.TextColorBlack56,
            fontWeight: FontWeight.normal,
            letterSpacing: 1.6,
            height: 1.5,
            fontFamily: AppStrings.FONT_POPPINS_REGULAR));

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
        context.read<BlocAccount>().add(RequestPrintTicket());
        // //todo: data from bloc
        // const platformMethodChannel = MethodChannel('com.methodchannel/test');
        // platformMethodChannel.invokeMethod('getModel');
      },
      text: AppStrings.reprint_ticket,
      textStyle: TextStyle(
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
                  ticketNoText,
                  stallNameText,
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

    return BlocListener<BlocAccount, StateAccount>(
      listener: (context, state) {
        BuildContext dialogContext;

        //todo: setup dialogs (for mobile / desktop)
        if (state is InitStateAccount) {
          // showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (BuildContext context) {
          //       return const DialogProgressTitle(
          //         title: AppStrings.processing_text,
          //       );
          //     });
        }

        if (state is RequestFailed) {
          Navigator.of(context).pop();
          // showDialog(
          //     context: context,
          //     barrierDismissible: true,
          //     builder: (BuildContext context) {
          //       dialogContext = context;
          //       return DialogContentOptions(
          //         title: "Sign In Error",
          //         content: state.error,
          //         redButtonText: "Okay",
          //         onOption1Pressed: () {
          //           Navigator.of(dialogContext).pop();
          //         },
          //         onOption2Pressed: () {},
          //         onCancelled: () {
          //           Navigator.of(dialogContext).pop();
          //         },
          //       );
          //     });
        }
      },
      child: mainBody,
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
