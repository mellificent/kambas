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

class ScreenAdmin extends StatelessWidget {
  const ScreenAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.White,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.account_circle, size: 40.0, color: Colors.grey,),
          ),
          actions: [
            IconButton(
              onPressed: () {
              },
              icon: const Icon(Icons.settings, size: 40.0, color: Colors.grey,),
            ),
            const SizedBox(width: 8.0,),
          ],
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


    Widget exportButton = ButtonRaised(
      onPressed: () {
        //todo: export data
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 26.0),
                    child: Text(
                      "Admin Page",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0,
                          color: AppColors.TextColorBlack56,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.4,
                          fontFamily: AppStrings.FONT_POPPINS_REGULAR),
                    ),
                  ),

                  exportButton,
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

        if (state is RequestPostAccountFailed) {
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

}
