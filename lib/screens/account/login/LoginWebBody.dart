import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kambas/bloc/account/StateAccount.dart';
import 'package:kambas/utils/config/SizeConfig.dart';
import '../../../bloc/account/BlocAccount.dart';
import '../../../bloc/account/EventAccount.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_strings.dart';
import '../../../dialogs/DialogContentOptions.dart';
import '../../../dialogs/DialogProgressTitle.dart';
import '../../../mixins/FormMixins.dart';
import '../../../providers/ProviderAccount.dart';
import '../../../widgets/buttons/button_raised.dart';
import '../../../widgets/textfield/TextFieldStyle1.dart';
import '../../../utils/string_extension.dart';
import '../../../widgets/textfield/WebTextFieldStyle1.dart';

// todo: setup constant values for both desktop / tablet
class LoginWebBody extends StatelessWidget
    with FormMixins<BlocAccount, StateAccount> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _pwFocusNode = FocusNode();

  LoginWebBody({super.key});

  _initControllerListener(BuildContext context) {
    ///add autofocus to email textfield
    _emailFocusNode.requestFocus();

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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _initControllerListener(context);

    Widget loginTitle = Container(
      margin: EdgeInsets.only(bottom: (SizeConfig.blockSizeVertical! * 8)),
      width: (SizeConfig.blockSizeHorizontal! * 25),
      child: const AutoSizeText(AppStrings.web_login_title,
          maxFontSize: 60.0,
          minFontSize: 26.0,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 60.0,
              color: AppColors.PrimaryColor,
              fontFamily: AppStrings.FONT_POPPINS_BOLD)),
    );

    Widget forgotPassword = Container(
      width: 182,
      margin: EdgeInsets.only(bottom: (SizeConfig.blockSizeVertical! * 7)),
      child: InkWell(
          onTap: () {
            // Navigator.of(context)
            //     .pushNamed(AppRoutes
            //     .of(context)
            //     .forgotPasswordScreen);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: const Align(
            alignment: Alignment.center,
            // todo: verify creatives / sir anthony if alignment in figma is still centered
            child: AutoSizeText(AppStrings.forgot_password,
                maxFontSize: 16.0,
                minFontSize: 12.0,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16.0,
                    color: AppColors.TextColorGray56,
                    fontFamily: AppStrings.FONT_POPPINS_REGULAR)),
          )),
    );

    Widget loginButton = Container(
      width: (SizeConfig.blockSizeHorizontal! * 15),
      child: ButtonRaised(
        onPressed: () {
          context.read<BlocAccount>().add(PostLoginCredentials(_emailController.text, _pwController.text));
        },
        text: AppStrings.sign_in.allInCaps(),
        borderRadius: 8,
        height: 50.0,
        margin: EdgeInsets.zero,
      ),
    );

    return BlocListener<BlocAccount, StateAccount>(
      listener: (context, state) {
        BuildContext dialogContext;

        //todo: setup dialogs (for mobile / desktop)
        if (state is RequestLoadingAccount) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const DialogProgressTitle(
                  isWeb: true,
                  title: AppStrings.processing_text,
                );
              });
        }

        if (state is RequestAccountFailed) {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                dialogContext = context;
                return DialogContentOptions(
                  isWeb: true,
                  title: "Sorry",
                  content: state.error,
                  //state error msg
                  redButtonText: "Okay",
                  onOption1Pressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  onOption2Pressed: () {},
                  onCancelled: () {
                    Navigator.of(dialogContext).pop();
                  },
                );
              });
        }

        if (state is RequestPostLoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.of(context).mainScreen, (r) => false);
        }
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: SizeConfig.screenHeight! - (SizeConfig.blockSizeVertical! * 10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        loginTitle,
                        _buildEmailField(context),
                        SizedBox(height: SizeConfig.blockSizeVertical! * 3,),
                        _buildPasswordField(context),
                        SizedBox(height: SizeConfig.blockSizeVertical! * 3,),
                        forgotPassword,
                        loginButton
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildEmailField(BuildContext context) => buildWebTextField(
    context,
    id: FormLogin.ID_USERNAME,
    buildWhen: (id, previous, current) =>
    (current is UpdateFormField && (current.fieldName == id)),
    onValueChange: null,
    builder: (context, state, textedit) => WebTextFieldStyle1(
      heightPercent: (SizeConfig.blockSizeVertical! * 6),
      widthPercent: (SizeConfig.blockSizeHorizontal! * 25),
      hintText: AppStrings.register_field_email,
      controller: _emailController,
      focusNode: _emailFocusNode,
      textInputType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      textInputStyle: const TextStyle(
          fontSize: 14,
          fontFamily: AppStrings.FONT_POPPINS_BOLD,
          color: Colors.black),
      errorMessage: null,
      prefixIcon: SvgPicture.asset(
        AppIcons.EMAIL_SVG,
        height: (SizeConfig.screenHeight! * 0.016),
        width: (SizeConfig.screenWidth! * 0.016),
      ),
    ),
  );

  _buildPasswordField(BuildContext context) => buildWebTextField(
    context,
    id: FormLogin.ID_PASSWORD,
    buildWhen: (id, previous, current) =>
    (current is UpdateFormField && (current.fieldName == id)),
    onValueChange: null,
    builder: (context, state, textedit) => WebTextFieldStyle1(
      heightPercent: (SizeConfig.blockSizeVertical! * 6),
      widthPercent: (SizeConfig.blockSizeHorizontal! * 25),
      hintText: AppStrings.register_field_password,
      controller: _pwController,
      focusNode: _pwFocusNode,
      textInputType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      textInputStyle: const TextStyle(
          fontSize: 14,
          fontFamily: AppStrings.FONT_POPPINS_BOLD,
          color: AppColors.Black),
      obscureText: (state is UpdateFormField) ? state.obscure : false,
      errorMessage: null,
      prefixIcon: SvgPicture.asset(
        AppIcons.password_SVG,
        height: (SizeConfig.screenHeight! * 0.016),
        width: (SizeConfig.screenWidth! * 0.016),
      ),
      // suffixIcon: IconButton(
      //   onPressed: () {
      //     if (state is UpdateFormField) {
      //       context.read<BlocAccount>().add(const FormFieldChangeObscurity(FormLogin.ID_PASSWORD));
      //     }
      //   },
      //   icon: Icon(
      //     (state is UpdateFormField)
      //         ? (state.obscure)
      //         ? Icons.visibility
      //         : Icons.visibility_off
      //         : Icons.visibility,
      //     //todo: update focus node in state
      //     color: (_pwFocusNode.hasFocus)
      //         ? AppColors.PrimaryColor
      //         : AppColors.TextColorGray56,
      //   ),
      // ),
    ),
  );

}