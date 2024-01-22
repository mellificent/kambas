import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kambas/constants/app_routes.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/mixins/FormMixins.dart';
import 'package:kambas/widgets/buttons/button_raised.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import '../../../../bloc/account/BlocAccount.dart';
import '../../../../bloc/account/EventAccount.dart';
import '../../../../bloc/account/StateAccount.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_icons.dart';
import '../../../../providers/ProviderAccount.dart';

class ScreenExport extends StatelessWidget {
  const ScreenExport({super.key});

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

    Widget exportButton = ButtonRaised(
      onPressed: () {
        context.read<BlocAccount>().add(RequestExportCSV());
      },
      text: AppStrings.export_data,
      textStyle: const TextStyle(
          fontSize: 14.0,
          color: AppColors.TextColorBlack56,
          fontWeight: FontWeight.bold,
          fontFamily: AppStrings.FONT_POPPINS_BOLD),
      borderRadius: 9,
      height: 45.0,
      margin: const EdgeInsets.only(top: 13),
    );


    Widget backToHomeBtn = ButtonRaised(
      onPressed: () {
        Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.of(context).mainScreen));
      },
      text: AppStrings.back_to_home,
      textStyle: const TextStyle(
          fontSize: 14.0,
          color: AppColors.TextColorBlack56,
          fontWeight: FontWeight.bold,
          fontFamily: AppStrings.FONT_POPPINS_BOLD),
      borderRadius: 9,
      height: 45.0,
      margin: const EdgeInsets.only(top: 13),
    );

    Widget mainBody = Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 41.0, right: 41.0, top: 20.0, bottom: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                logo,
                const SizedBox(
                  height: 20.0,
                ),
                _buildTitle(context),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 26.0),
                  child: Text(
                    "Export Data Page",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: AppColors.TextColorBlack56,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.4,
                        fontFamily: AppStrings.FONT_POPPINS_REGULAR),
                  ),
                ),
                _buildDateTimePicker(context),
                exportButton,
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: backToHomeBtn,
                  ),
                ),
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

  _buildDateTimePicker(BuildContext context) => buildWidget(
    context,
    id: "dateTimePickerView",
    buildWhen: (id, previous, current) => (current is DisplayFilterDate),
    builder: (context, state) {
      if (state is InitStateAccount) {
        context.read<BlocAccount>().add(RequestSelectedFilterDate(DateTime.now()));
      }

      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Choose Date/Cut-Off",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13.0,
                  color: AppColors.TextColorBlack56,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  fontFamily: AppStrings.FONT_POPPINS_REGULAR)),
          ButtonRaised(
            onPressed: () async {
              DateTime? dateTime = await showOmniDateTimePicker(
                context: context,
                initialDate: DateTime.now(),
                // firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
                // lastDate: DateTime.now().add(
                //   const Duration(days: 3652),
                // ),
                is24HourMode: false,
                isShowSeconds: false,
                minutesInterval: 60,
                secondsInterval: 1,
                isForce2Digits: true,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                constraints: const BoxConstraints(
                  maxWidth: 350,
                  maxHeight: 650,
                ),
                transitionBuilder: (context, anim1, anim2, child) {
                  return FadeTransition(
                    opacity: anim1.drive(
                      Tween(
                        begin: 0,
                        end: 1,
                      ),
                    ),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 200),
                barrierDismissible: true,
                selectableDayPredicate: (dateTime) {
                  // Disable 25th Feb 2023
                  if (dateTime == DateTime(2023, 2, 25)) {
                    return false;
                  } else {
                    return true;
                  }
                },
              );
              if (kDebugMode) {
                //2024-01-25 21:00:00.000
                print("dateTime: $dateTime");
              }
              if (dateTime != null && context.mounted){
                context.read<BlocAccount>().add(RequestSelectedFilterDate(dateTime));
              }
            },
            bgColor: AppColors.DisabledPrimaryColor,
            text: (state is DisplayFilterDate) ? state.text : DateFormat('EEE MMM dd ha').format(DateTime.now()),
            textStyle: const TextStyle(
                fontSize: 14.0,
                color: AppColors.TextColorBlack56,
                fontWeight: FontWeight.bold,
                fontFamily: AppStrings.FONT_POPPINS_BOLD),
            borderRadius: 9,
            height: 45.0,
            margin: const EdgeInsets.only(top: 4.0),
          ),
        ],
      );
    },
  );

}
