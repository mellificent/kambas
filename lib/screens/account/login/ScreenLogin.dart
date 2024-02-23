import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kambas/constants/app_routes.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/mixins/FormMixins.dart';
import 'package:kambas/screens/account/login/LoginWebBody.dart';
import 'package:kambas/screens/main/ScreenMain.dart';
import 'package:kambas/utils/config/SizeConfig.dart';
import 'package:kambas/utils/string_extension.dart';
import 'package:kambas/widgets/buttons/button_raised.dart';
import 'package:kambas/widgets/textfield/TextFieldStyle1.dart';
import 'package:universal_platform/universal_platform.dart';
import '../../../bloc/account/BlocAccount.dart';
import '../../../bloc/account/EventAccount.dart';
import '../../../bloc/account/StateAccount.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_icons.dart';
import '../../../providers/ProviderAccount.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktopPlatform = (!UniversalPlatform.isAndroid);

    return Scaffold(
      backgroundColor: AppColors.White,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0.0,
      ),
      body: BlocProvider(
              create: (_) => BlocAccount(
                providerAccount:
                    RepositoryProvider.of<ProviderAccount>(context),
              ),
              child: isDesktopPlatform ? LoginWebBody() : MainLayout(),
            ),
    );
  }
}

class MainLayout extends StatelessWidget
    with FormMixins<BlocAccount, StateAccount> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _pwFocusNode = FocusNode();

  MainLayout({super.key});

  _initControllerListener(BuildContext context) {
    SizeConfig().init(context);

    ///add autofocus to email textfield
    // _emailFocusNode.requestFocus();

    _emailController.addListener(
      () {
        context.read<BlocAccount>().add(FormFieldValueOnChange(
            FormLogin.ID_USERNAME, _emailController.text));
      },
    );
    _pwController.addListener(
      () {
        context.read<BlocAccount>().add(
            FormFieldValueOnChange(FormLogin.ID_PASSWORD, _pwController.text));
      },
    );

    //hide status bar and navigation bar
    _emailFocusNode.addListener(() {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    });
    _pwFocusNode.addListener(() {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    });
  }

  @override
  Widget build(BuildContext context) {
    _initControllerListener(context);

    Widget loginLogo = Container(
      width: 150,
      height: 90,
      margin: const EdgeInsets.only(
        top: 20.0,
        bottom: 50.0,
      ),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.PrimaryColor,
      ),
      child: SvgPicture.asset(
        AppIcons.LOGO_SVG,
        fit: BoxFit.fill,
        height: 80,
        width: 80,
      ),
    );

    Widget loginTitle = const Text(AppStrings.login,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 36.0,
            color: AppColors.TextColorBlack56,
            fontWeight: FontWeight.bold,
            fontFamily: AppStrings.FONT_POPPINS_BOLD));

    Widget subHeader = const Align(
      alignment: Alignment.center,
      // todo: verify creatives / sir anthony if alignment in figma is still centered
      child: Text("Sign in to continue.",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 12.0,
              color: AppColors.TextColorGray56,
              fontFamily: AppStrings.FONT_POPPINS_REGULAR)),
    );

    Widget loginButton = Container(
      margin: const EdgeInsets.only(top: 25.0, bottom: 20.0),
      child: ButtonRaised(
        onPressed: () {
          context.read<BlocAccount>().add(
              PostLoginCredentials(_emailController.text, _pwController.text));
        },
        text: AppStrings.login,
        textStyle: const TextStyle(
            fontSize: 14.0,
            color: AppColors.TextColorBlack56,
            fontWeight: FontWeight.bold,
            fontFamily: AppStrings.FONT_POPPINS_BOLD),
        borderRadius: 9,
        height: 50.0,
        margin: EdgeInsets.zero,
      ),
    );

    Widget mainBody = SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: SizeConfig.screenHeight! -
                    (SizeConfig.blockSizeVertical! * 26),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 41.0, right: 41.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    loginLogo,
                    loginTitle,
                    subHeader,
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(
                          left: 10.0, top: 40.0, bottom: 8.0),
                      child: const Text("NAME",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: AppColors.TextColorGray56,
                              fontFamily: AppStrings.FONT_POPPINS_REGULAR)),
                    ),
                    _buildEmailField(context),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(
                          left: 10.0, top: 15.0, bottom: 8.0),
                      child: const Text("PASSWORD",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: AppColors.TextColorGray56,
                              fontFamily: AppStrings.FONT_POPPINS_REGULAR)),
                    ),
                    _buildPasswordField(context),
                    loginButton,
                  ],
                ),
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
        if (state is RequestLoadingAccount) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Loading..."),
          ));
        }

        if (state is RequestFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
          ));
        }

        if (state is RequestPostLoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.of(context).mainScreen, (r) => false,
              arguments: ScreenMainSettings(isAdminUser: state.isAdminUser));
        }
      },
      child: mainBody,
    );
  }

  _buildEmailField(BuildContext context) => buildFlexTextFieldStyle1(
        context,
        id: FormLogin.ID_USERNAME,
        buildWhen: (id, previous, current) =>
            (current is UpdateFormField && (current.fieldName == id)),
        onValueChange: null,
        builder: (context, state, textedit) => TextFieldStyle1(
          // hintText: "Name",
          controller: _emailController,
          focusNode: _emailFocusNode,
          height: 45.0,
          textInputType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          textInputStyle: const TextStyle(
              fontSize: 16,
              fontFamily: AppStrings.FONT_POPPINS_BOLD,
              color: Colors.black),
          errorMessage: (state is UpdateFormField &&
                  state.fieldName == FormLogin.ID_USERNAME)
              ? state.error
              : null,
        ),
      );

  _buildPasswordField(BuildContext context) => buildFlexTextFieldStyle1(
        context,
        id: FormLogin.ID_PASSWORD,
        buildWhen: (id, previous, current) =>
            (current is UpdateFormField && (current.fieldName == id)),
        onValueChange: null,
        builder: (context, state, textedit) => TextFieldStyle1(
          // hintText: "Password",
          controller: _pwController,
          focusNode: _pwFocusNode,
          height: 45.0,
          textInputType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          textInputStyle: const TextStyle(
              fontSize: 16,
              fontFamily: AppStrings.FONT_POPPINS_BOLD,
              color: AppColors.Black),
          obscureText: (state is UpdateFormField) ? state.obscure : true,
          errorMessage: (state is UpdateFormField &&
                  (state.fieldName == FormLogin.ID_PASSWORD))
              ? state.error
              : null,
        ),
      );
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path myPath = Path();
    myPath.lineTo(0.0, size.height);

    myPath.quadraticBezierTo(
        size.width / 4, size.height / 1.2, size.width / 2, size.height / 1.2);
    myPath.lineTo(
      size.width - (size.width / 4),
      size.height / 1.2,
    );

    myPath.lineTo(size.width, 0.0);
    return myPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
