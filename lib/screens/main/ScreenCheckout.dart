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

class ScreenCheckout extends StatelessWidget {
  const ScreenCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.White,
      appBar: null,
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
            fontWeight: FontWeight.w500,
            letterSpacing: 1.3,
            height: 1.5,
            fontFamily: AppStrings.FONT_POPPINS_REGULAR));

    Widget stallNameText = const Text("Stall Name - N/A",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 14.0,
            color: AppColors.TextColorBlack56,
            fontWeight: FontWeight.normal,
            letterSpacing: 1.4,
            height: 1.5,
            fontFamily: AppStrings.FONT_POPPINS_REGULAR));


    Widget printButton = ButtonRaised(
      onPressed: () {
        context.read<BlocAccount>().add(RequestReprintTicket());
      },
      text: AppStrings.print_ticket,
      textStyle: const TextStyle(
          fontSize: 14.0,
          color: AppColors.TextColorBlack56,
          fontWeight: FontWeight.bold,
          fontFamily: AppStrings.FONT_POPPINS_BOLD),
      borderRadius: 9,
      height: 45.0,
      margin: EdgeInsets.zero,
    );

    Widget buildPaymentOptionBtn(String label, VoidCallback onPressed) => InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: AppColors.PrimaryColor.withOpacity(0.8),
        ),
        height: 40.0,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 5.0),
        child: Text(label,
          style: TextStyle(color: AppColors.TextColorBlack56, fontSize: 14),
        ),
      ),
    );

    Widget checkoutbtns = Container(
      padding: const EdgeInsets.only(left: 41, right:41, top: 26.0, bottom: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Mode of Payment",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13.0,
                  color: AppColors.TextColorBlack56,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  height: 1.2,
                  fontFamily: AppStrings.FONT_POPPINS_REGULAR)),
          buildPaymentOptionBtn("Cash", (){

          }),
          buildPaymentOptionBtn("Multibanco", (){

          }),
          buildPaymentOptionBtn("Transferencia", (){

          }),
          Expanded(child: Container(alignment: Alignment.bottomCenter,child: printButton)),
        ],
      ),
    );

    Widget mainBody = SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            logo,
            const SizedBox(
              height: 20.0,
            ),
            _buildTitle(context),
            const SizedBox(
              height: 12.0,
            ),
            _buildBetNumberTitle(context),
            ticketNoText,
            stallNameText,
            _buildDrawSchedule(context),
            _buildBetAmount(context),
            Expanded(child: checkoutbtns),
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                AppIcons.APP_FOOTER,
                fit: BoxFit.scaleDown,
              ),
            ),
          ],
        ),
      ),
    );

    return BlocListener<BlocAccount, StateAccount>(
      listener: (context, state) {
        if (state is RequestGoToHome) {
          Navigator.pop(context, "betComplete");
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

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "Draw Schedule - ${(state is DisplayDrawTime) ? state.text : "N/A"}",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 14.0,
              color: AppColors.TextColorBlack56,
              fontWeight: FontWeight.normal,
              letterSpacing: 1.4,
              fontFamily: AppStrings.FONT_POPPINS_REGULAR),
        ),
      );
    },
  );

  _buildBetNumberTitle(BuildContext context) => buildWidget(
    context,
    id: "betNumberTitle",
    buildWhen: (id, previous, current) => (current is UpdateBetSelectedNumbers),
    builder: (context, state) {
      if (state is InitStateAccount) {
        context.read<BlocAccount>().add(RequestDisplayBetNumber());
      }

      return Text("Bet - ${(state is UpdateBetSelectedNumbers) ? state.text : ""}",
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 17.0,
            color: AppColors.TextColorBlack56,
            fontWeight: FontWeight.normal,
            letterSpacing: 1.4,
            fontFamily: AppStrings.FONT_POPPINS_REGULAR),
      );
    },
  );

  _buildBetAmount(BuildContext context) => buildWidget(
    context,
    id: "betAmountTitle",
    buildWhen: (id, previous, current) => (current is DisplayBetAmount),
    builder: (context, state) {
      if (state is InitStateAccount) {
        context.read<BlocAccount>()
            .add(RequestDisplayBetAmount());
      }

      return Text("Amount Due - Kz${(state is DisplayBetAmount) ? state.text : ""}",
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 16.0,
            color: AppColors.TextColorBlack56,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.4,
            fontFamily: AppStrings.FONT_POPPINS_REGULAR),
      );
    },
  );



}
