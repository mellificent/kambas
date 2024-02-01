import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_button/group_button.dart';
import 'package:kambas/constants/app_routes.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/mixins/FormMixins.dart';
import 'package:kambas/utils/KeepAlivePage.dart';
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

class ScreenAmount extends StatelessWidget {
  const ScreenAmount({super.key});

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

  final TextEditingController otherAmountController = TextEditingController();

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

    Widget chooseAmountLabel = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: AppColors.PrimaryColor.withOpacity(0.8),
      ),
      height: 40.0,
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 2.0,
        top: 15.0,
      ),
      child: const Text(
        AppStrings.choose_amount,
        style: TextStyle(
          color: AppColors.TextColorBlack56,
          fontSize: 14,
        ),
      ),
    );

    Widget betButtons(List<String> data) => Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          child: GroupButton(
            isRadio: true,
            onSelected: (value, index, isSelected) {
              context.read<BlocAccount>().add(RequestUpdateBetAmount(value));
            },
            buttons: data,
            options: GroupButtonOptions(
              selectedShadow: const [],
              selectedTextStyle: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              unselectedTextStyle: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              selectedColor: AppColors.PrimaryColor.withOpacity(0.5),
              unselectedShadow: const [],
              unselectedColor: AppColors.PrimaryColor,
              borderRadius: BorderRadius.circular(10),
              spacing: 15,
              runSpacing: 10,
              groupingType: GroupingType.wrap,
              direction: Axis.horizontal,
              buttonHeight: 70,
              buttonWidth: 70,
              mainGroupAlignment: MainGroupAlignment.center,
              crossGroupAlignment: CrossGroupAlignment.start,
              groupRunAlignment: GroupRunAlignment.start,
              textAlign: TextAlign.center,
              textPadding: EdgeInsets.zero,
              alignment: Alignment.center,
              elevation: 0,
            ),
          ),
        );

    Widget backBtn = ButtonRaised(
      onPressed: () {
        context.read<BlocAccount>().add(const RequestPostBetAmount());
      },
      text: AppStrings.back_to_home,
      textStyle: const TextStyle(
          fontSize: 14.0,
          color: AppColors.TextColorBlack56,
          fontFamily: AppStrings.FONT_POPPINS_BOLD),
      borderRadius: 9,
      height: 40.0,
      margin: EdgeInsets.zero,
      bgColor: AppColors.PrimaryColor.withOpacity(0.8),
    );

    Widget mainBody = Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 41.0, right: 41.0, top: 20.0, bottom: 17.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                logo,
                const SizedBox(
                  height: 10.0,
                ),
                // _buildTitle(context),
                chooseAmountLabel,
                Expanded(
                  child: betButtons(const [
                    "100",
                    "200",
                    "300",
                    "400",
                    "500",
                    "1000",
                    "2000",
                    "5000",
                  ]),
                ),
                buildOtherAmount(context),
                const SizedBox(
                  height: 10.0,
                ),
                backBtn,
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
        if (state is RequestBetNumbersDone) {
          Navigator.pop(context, "RequestBetAmountDone");
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

  Widget buildOtherAmount(BuildContext context) => Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      color: AppColors.PrimaryColor.withOpacity(0.2),
    ),
    height: 47.0,
    width: double.infinity,
    margin: const EdgeInsets.only(
      bottom: 2.0,
      top: 16.0,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: buildWidget(
              context,
              id: "BetFieldLabel",
              buildWhen: (id, previous, current) => (current is DisplayBetAmount),
              builder: (context, state){
                otherAmountController.text = (state is DisplayBetAmount) ? state.text : "";
                return TextFieldStyle2(
                  isEnabled: false,
                  height: 42.0,
                  bgColor: Colors.transparent,
                  borderColor: Colors.transparent,
                  labelText: AppStrings.other_amount,
                  controller: otherAmountController,
                  textInputType: TextInputType.text,
                  textAlignment: TextAlign.start,
                  textInputAction: TextInputAction.done,
                  textInputStyle: const TextStyle(
                      fontSize: 17,
                      fontFamily: AppStrings.FONT_POPPINS_BOLD,
                      color: Colors.black),
                );
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 6.0, bottom: 6.0, right: 3.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: AppColors.PrimaryColor,
          ),
          child: IconButton(
            padding: const EdgeInsets.all(0.0),
            onPressed: () {
              if(otherAmountController.text != "" || otherAmountController.text != "100") {
                int value = int.parse(otherAmountController.text);
                value -= 100;
                context.read<BlocAccount>().add(RequestUpdateBetAmount(value.toString()));
              }
            },
            icon: Icon(
              Icons.remove,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 6.0, bottom: 6.0,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: AppColors.PrimaryColor,
          ),
          child: IconButton(
            padding: const EdgeInsets.all(0.0),
            onPressed: () {
              if(otherAmountController.text == "") {
                otherAmountController.text = "100";
              }else {
                int value = int.parse(otherAmountController.text);
                value += 100;
                context.read<BlocAccount>().add(RequestUpdateBetAmount(value.toString()));
              }
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
