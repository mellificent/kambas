import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kambas/constants/app_routes.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/mixins/FormMixins.dart';
import 'package:kambas/widgets/buttons/button_raised.dart';
import 'package:kambas/widgets/buttons/button_style1.dart';
import '../../../../bloc/account/BlocAccount.dart';
import '../../../../bloc/account/EventAccount.dart';
import '../../../../bloc/account/StateAccount.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_icons.dart';
import '../../../../providers/ProviderAccount.dart';

class ScreenCreateUser extends StatelessWidget {
  const ScreenCreateUser({super.key});

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

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactnumberController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

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

    Widget cancelBtn = ButtonRaised(
      onPressed: () {
        Navigator.of(context).pop();
      },
      text: "Cancel",
      textStyle: const TextStyle(
        fontSize: 14.0,
        color: AppColors.TextColorBlack56,
        fontWeight: FontWeight.w400,
      ),
      bgColor: AppColors.DisabledPrimaryColor,
      borderRadius: 9,
      height: 45.0,
      margin: const EdgeInsets.only(top: 13),
    );

    Widget submitBtn = ButtonRaised(
      onPressed: () {
        context.read<BlocAccount>().add(RequestAddUser(
            userName: usernameController.text,
            password: pwController.text,
            fullName: fullnameController.text,
            email: emailController.text,
            contactNo: contactnumberController.text));
      },
      text: "Submit",
      textStyle: const TextStyle(
        fontSize: 14.0,
        color: AppColors.TextColorBlack56,
        fontWeight: FontWeight.w500,
      ),
      borderRadius: 9,
      height: 45.0,
      margin: const EdgeInsets.only(top: 13),
    );

    Widget formBody = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildTextField(
            context,
            controller: usernameController,
            hint: 'Enter Username',
            label: "Username",
          ),
          _buildTextField(
            context,
            controller: fullnameController,
            hint: 'Enter Full Name',
            label: "Full Name",
          ),
          _buildTextField(
            context,
            controller: emailController,
            hint: 'Enter Email',
            label: "Email",
            keybType: TextInputType.emailAddress,
          ),
          _buildTextField(
            context,
            controller: contactnumberController,
            hint: 'Enter Contact Number',
            label: "Contact Number",
            keybType: TextInputType.phone,
          ),
          _buildTextField(
            context,
            controller: pwController,
            hint: 'Enter Password',
            label: "Password",
            keybType: TextInputType.visiblePassword,
            isPassword: true,
            textInput: TextInputAction.done,
          ),
        ],
      ),
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 26.0),
                  child: Text(
                    "Add New User",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: AppColors.TextColorBlack56,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.4,
                        fontFamily: AppStrings.FONT_POPPINS_REGULAR),
                  ),
                ),
                Expanded(
                  child: formBody,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 2,
                      child: cancelBtn,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      flex: 3,
                      child: submitBtn,
                    ),
                  ],
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
      listener: (mContext, state) {
        if (state is RequestSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Successfully Added User"),
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
      height: 55,
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
          border: const OutlineInputBorder(),
          hintText: hint,
          labelText: label,
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
}
