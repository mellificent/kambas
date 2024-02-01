import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kambas/constants/app_routes.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/mixins/FormMixins.dart';
import 'package:kambas/widgets/buttons/button_raised.dart';
import 'package:kambas/widgets/layout/LayoutLoading.dart';
import '../../../../bloc/account/BlocAccount.dart';
import '../../../../bloc/account/EventAccount.dart';
import '../../../../bloc/account/StateAccount.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_icons.dart';
import '../../../../providers/ProviderAccount.dart';

class ScreenReprint extends StatelessWidget {
  const ScreenReprint({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

  final TextEditingController ticketController = TextEditingController();

  final borderStyle = OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.PrimaryColor,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
  );

  @override
  Widget build(BuildContext context) {

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

    Widget printTicketBtn = ButtonRaised(
      onPressed: () {
        context.read<BlocAccount>().add(RequestReprintTicket(ticketController.text));
      },
      text: "Print Ticket",
      textStyle: const TextStyle(
        fontSize: 14.0,
        color: AppColors.TextColorBlack56,
        fontWeight: FontWeight.w500,
      ),
      bgColor: AppColors.PrimaryColor,
      borderRadius: 9,
      height: 45.0,
      margin: const EdgeInsets.only(top: 12),
    );


    Widget backToHomeBtn = ButtonRaised(
      onPressed: () {
        Navigator.pop(context);
      },
      text: AppStrings.back_to_home,
      textStyle: const TextStyle(
          fontSize: 14.0,
          color: AppColors.TextColorBlack56,
          fontWeight: FontWeight.w500,
          fontFamily: AppStrings.FONT_POPPINS_BOLD),
      borderRadius: 9,
      height: 45.0,
      margin: const EdgeInsets.only(top: 10),
    );

    Widget mainBody = Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 41.0, right: 41.0, top: 20.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                logo,
                const SizedBox(
                  height: 30.0,
                ),
                _buildTextField(
                  context,
                  controller: _addSearchListener(context),
                  hint: 'Enter Ticket Number',
                  label: "Ticket Number",
                  keybType: TextInputType.text,
                ),
                Expanded(
                  child: _buildTransactionView(context),
                ),
                printTicketBtn,
                backToHomeBtn
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            AppIcons.APP_FOOTER,
            fit: BoxFit.scaleDown,
          ),
        ),
      ],
    );

    return BlocListener<BlocAccount, StateAccount>(
      listener: (mContext, state) {
        if (state is RequestSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Successfully Updated User"),
          ));
          Navigator.of(mContext).pop();
        }

        if (state is RequestFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
          ));
        }
      },
      child: mainBody,
    );
  }

  _buildTextField(BuildContext context,
      {required TextEditingController controller,
      required String hint,
      required String label,
      TextInputAction? textInput,
      TextInputType? keybType,
      bool? isPassword}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: TextField(
        onTapOutside: (event) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: []);
          FocusManager.instance.primaryFocus?.unfocus();
        },
        obscureText: isPassword ?? false,
        controller: controller,
        textInputAction: textInput ?? TextInputAction.next,
        keyboardType: keybType ?? TextInputType.text,
        decoration: InputDecoration(
          floatingLabelStyle: const TextStyle(
              fontSize: 14.0,
              color: AppColors.PrimaryColor,
              fontFamily: AppStrings.FONT_POPPINS_BOLD),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(),
          hintText: hint,
          labelText: label,
          labelStyle: TextStyle(
              fontSize: 14.0,
              color: AppColors.PrimaryColor,
              fontFamily: AppStrings.FONT_POPPINS_BOLD),
          contentPadding: const EdgeInsets.only(
            left: 14,
            top: 16.0,
          ),
          enabledBorder: borderStyle,
          focusedBorder: borderStyle,
        ),
      ),
    );
  }

  _buildTransactionView(BuildContext context) => buildWidget(
    context,
    id: "transactionView",
    buildWhen: (id, previous, current) => (current is DisplayTransactionDetails),
    builder: (context, state) {
      if(state is DisplayTransactionDetails){
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              Text("Bet - ${state.data.selectedBetNumber}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16.0,
                    color: AppColors.TextColorBlack56,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.4,
                    fontFamily: AppStrings.FONT_POPPINS_REGULAR),
              ),
              Text("Placed on - ${state.data.placedDate}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.TextColorBlack56,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.4,
                    fontFamily: AppStrings.FONT_POPPINS_REGULAR),
              ),
              Text("Stall Name - ${state.data.stallName}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14.0,
                      color: AppColors.TextColorBlack56,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1.6,
                      height: 1.5,
                      fontFamily: AppStrings.FONT_POPPINS_REGULAR)),
              Text(
                "Draw Schedule - ${state.data.drawTime}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.TextColorBlack56,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.4,
                    fontFamily: AppStrings.FONT_POPPINS_REGULAR),
              ),
              const SizedBox(height: 20.0,),
              Text("Placed bet - ${state.data.betAmount}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.TextColorBlack56,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.4,
                    fontFamily: AppStrings.FONT_POPPINS_REGULAR),
              ),
              Text("Amount of Prize - ${state.data.betPrize}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.TextColorBlack56,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.4,
                    fontFamily: AppStrings.FONT_POPPINS_REGULAR),
              ),
            ],
          ),
        );
      }

      return Container();
    },
  );

  TextEditingController _addSearchListener(BuildContext context) {
    ticketController.addListener(() {
      EasyDebounce.debounce(
          '_searchTicket', // <-- ID for this debounce operation
          const Duration(milliseconds: 500), () {
        context.read<BlocAccount>().add(GetTransactionDetails(ticketController.text));
      });
    });

    return ticketController;
  }
}
