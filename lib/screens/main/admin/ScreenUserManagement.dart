import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kambas/constants/app_routes.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/mixins/FormMixins.dart';
import 'package:kambas/screens/main/admin/ScreenUpdateUser.dart';
import 'package:kambas/widgets/buttons/button_raised.dart';
import 'package:kambas/widgets/buttons/button_style1.dart';
import '../../../../bloc/account/BlocAccount.dart';
import '../../../../bloc/account/EventAccount.dart';
import '../../../../bloc/account/StateAccount.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_icons.dart';
import '../../../../providers/ProviderAccount.dart';

class ScreenUserManagement extends StatelessWidget {
  const ScreenUserManagement({super.key});

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

    Widget addUserBtn = ButtonRaised(
      onPressed: () {
        Navigator.pushNamed(
          context,
          AppRoutes.of(context).createUserScreen,
        ).then((value) => context.read<BlocAccount>().add(GetDbUserList()));
      },
      text: AppStrings.add_user,
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

    return Column(
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
                    "User Management",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: AppColors.TextColorBlack56,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.4,
                        fontFamily: AppStrings.FONT_POPPINS_REGULAR),
                  ),
                ),
                addUserBtn,
                Expanded(
                  child: _buildUserList(context),
                ),
                backToHomeBtn,
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

  _buildUserList(BuildContext context) => buildWidget(
        context,
        id: "userList",
        buildWhen: (id, previous, current) => (current is DisplayUserList),
        builder: (context, state) {
          if (state is InitStateAccount) {
            context.read<BlocAccount>().add(GetDbUserList());
          }

          return (state is DisplayUserList && state.list.isNotEmpty)
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  itemCount: state.list.length,
                  itemBuilder: (mCtxt, index) {
                    return ButtonStyle1(
                      backgroundColor: AppColors.PrimaryColor.withOpacity(0.5),
                      onPressed: () {
                        Navigator.pushNamed(
                                context, AppRoutes.of(context).updateUserScreen,
                                arguments: ScreenUpdateUserSettings(userID: state.list[index].userId))
                            .then((value) => context
                                .read<BlocAccount>()
                                .add(GetDbUserList()));
                      },
                      text: state.list[index].fullName,
                      margin: const EdgeInsets.only(top: 8),
                      icon: Icons.mode_edit_outline_outlined,
                    );
                  },
                )
              : Container();
        },
      );
}
