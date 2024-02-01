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

class ScreenBet extends StatelessWidget {
  const ScreenBet({super.key});

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

class MainLayout extends StatelessWidget with FormMixins<BlocAccount, StateAccount> {
  MainLayout({super.key});

  final controller = GroupButtonController();

  final PageController _pageController = PageController(initialPage: 0, viewportFraction: 1);

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

    Widget betButtons(List<String> data) => Container(
      padding: const EdgeInsets.symmetric(vertical: 20,),
      child: GroupButton(
        isRadio: true,
        onSelected: (value, index, isSelected){
          context.read<BlocAccount>().add(PostBetNumber(value));
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
          spacing: 20,
          runSpacing: 15,
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
      ),);

    Widget mainBody = Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 41.0, right: 41.0, top: 20.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                logo,
                const SizedBox(height: 17.0,),
                _buildTitle(context),
                _buildChooseNumberLabel(context),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index){
                      context.read<BlocAccount>().add(PostBetPage((index == 0) ? true : false));
                    },
                    children: [
                      KeepAlivePage(child: betButtons(const ["1", "2", "3", "4", "5", "6", "7", "8", "9",]),),
                      KeepAlivePage(child: betButtons(const ["10", "11", "12", "13", "14", "15", "16", "17", "18",]),),
                      KeepAlivePage(child: betButtons(const ["19", "20", "21", "22", "23", "24", "25", "26", "27",]),),
                      KeepAlivePage(child: betButtons(const ["28", "29", "30", "31", "32", "33", "34", "35", "36",]),),
                      KeepAlivePage(child: betButtons(const ["37", "38", "39", "40",]),),
                    ],),
                ),
                _buildSwipeLabel(context),
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
          Navigator.pop(context, "RequestBetNumbersDone");
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

  _buildChooseNumberLabel(BuildContext context) => buildWidget(
    context,
    id: "ChooseNumberLabel",
    buildWhen: (id, previous, current) => (current is UpdateBetChooseLabel),
    builder: (context, state) => Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: AppColors.PrimaryColor.withOpacity(0.8),
      ),
      height: 40.0,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2.0, top: 22.0,),
      child: Text((state is UpdateBetChooseLabel) ? state.labelText : AppStrings.chooseNumberLabel1,
        style: const TextStyle(color: AppColors.TextColorBlack56, fontSize: 14),
      ),
    ),
  );

  _buildSwipeLabel(BuildContext context) => buildWidget(
    context,
    id: "SwipeLabel",
    buildWhen: (id, previous, current) => (current is UpdateSwipeLabel),
    builder: (context, state) => Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: AppColors.PrimaryColor.withOpacity(0.8),
      ),
      height: 45.0,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8.0, top: 15.0,),
      child: Text(
          (state is UpdateSwipeLabel) ? state.labelText : AppStrings.swipeLabel1,
        style: TextStyle(color: AppColors.Black, fontSize: 14),
      ),
    ),
  );

}
