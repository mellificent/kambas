import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:kambas/constants/app_routes.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/mixins/FormMixins.dart';
import 'package:kambas/widgets/buttons/button_raised.dart';
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
        Navigator.of(context)
            .popUntil(ModalRoute.withName(AppRoutes.of(context).mainScreen));
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
            context
                .read<BlocAccount>()
                .add(RequestSelectedFilterDate(DateTime.now().copyWith(hour: 13)));
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
                  DatePicker.showDatePicker(
                    context,
                    maxTime: DateTime.now(),
                    showTitleActions: true,
                    onConfirm: (date) {
                      showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          builder: (modalctxt) {
                            return _buildCutOffSheet(context,
                                selectedDatetime: date);
                          });
                    },
                    locale: LocaleType.en,
                  );
                },
                bgColor: AppColors.DisabledPrimaryColor,
                text: (state is DisplayFilterDate)
                    ? state.text
                    : DateFormat('EEE MMM dd ha').format(DateTime.now()),
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

  _buildCutOffSheet(BuildContext context,
          {required DateTime selectedDatetime}) {
    int selectedTime = 13;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 44.0,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 44,
                child: CupertinoButton(
                  pressedOpacity: 0.3,
                  padding: const EdgeInsetsDirectional.only(start: 16, top: 0),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: 44,
                child: CupertinoButton(
                  pressedOpacity: 0.3,
                  padding: const EdgeInsetsDirectional.only(end: 16, top: 0),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  onPressed: () {
                    if (context.mounted) {
                      context.read<BlocAccount>().add(
                          RequestSelectedFilterDate(selectedDatetime.copyWith(
                              hour: selectedTime)));
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 210,
          width: 210,
          child: CustomRadioButton(
            buttonTextStyle: const ButtonTextStyle(
              selectedColor: Colors.black,
              unSelectedColor: AppColors.TextFieldHint_TextColor,
              textStyle:
              TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
              selectedTextStyle: TextStyle(
                  color: Color(0xFF000046),
                  fontSize: 17,
                  fontWeight: FontWeight.normal),
            ),
            unSelectedColor: Colors.white,
            selectedColor: AppColors.TextFieldHint_TextColor.withOpacity(0.1),
            selectedBorderColor: Colors.transparent,
            unSelectedBorderColor: Colors.transparent,
            spacing: 0,
            defaultSelected: "13",
            horizontal: true,
            enableButtonWrap: true,
            enableShape: true,
            absoluteZeroSpacing: false,
            elevation: 0,
            buttonLables: const [
              '1 PM Cut-Off',
              '8 PM Cut-Off',
            ],
            buttonValues: const [
              '13',
              '20',
            ],
            radioButtonValue: (time) {
              selectedTime = int.parse(time);
            },
          ),
        ),
      ],
    );
  }
}
