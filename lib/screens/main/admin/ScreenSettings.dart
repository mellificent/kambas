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
import 'package:kambas/widgets/layout/LayoutLoading.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import '../../../../bloc/account/BlocAccount.dart';
import '../../../../bloc/account/EventAccount.dart';
import '../../../../bloc/account/StateAccount.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_icons.dart';
import '../../../../providers/ProviderAccount.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

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

  final TextEditingController stallNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController ticketNoController = TextEditingController();

  final borderStyle = const OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.PrimaryColor,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
  );

  @override
  Widget build(BuildContext context) {

    Widget initLayout() {
      context.read<BlocAccount>().add(RequestCurrentDate());
      context.read<BlocAccount>().add(GetTerminalSettings());
      return const LayoutLoading(progressColor: AppColors.PrimaryColor,);
    }

    Widget logo = Image.asset(
      AppIcons.APP_LOGO,
      fit: BoxFit.fitHeight,
      height: 80,
    );

    Widget saveBtn = ButtonRaised(
      onPressed: () {
        context.read<BlocAccount>().add(RequestSaveSettings(stallName: stallNameController.text, location: locationController.text));
      },
      text: "Save",
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
        Navigator.pop(context);
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

    Widget formBody = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildTextField(
            context,
            controller: stallNameController,
            hint: 'Enter Stall Name',
            label: "STALL NAME",
          ),
          _buildTextField(
            context,
            controller: locationController,
            textInput: TextInputAction.done,
            hint: 'Enter Location',
            label: "LOCATION",
          ),
          _buildTextField(
            context,
            controller: ticketNoController,
            hint: 'Enter Ticket Number',
            label: "NEXT TICKET NO. SERIES",
            isEditable: false,
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
                logo,
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 26.0),
                  child: Text(
                    "General Settings",
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
                saveBtn,
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

    return BlocConsumer<BlocAccount, StateAccount>(
      listener: (mContext, state) {
        if (state is RequestSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Successfully Updated Settings"),
          ));
          Navigator.of(mContext).pop();
        }

        if (state is RequestFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
          ));
        }
      },
      buildWhen: (previous, current) => (current is InitStateAccount || current is DisplayTerminalSettings),
      builder: (context, state) {
        if (state is InitStateAccount) return initLayout();

        if (state is DisplayTerminalSettings) {
          stallNameController.text = state.data.stallName;
          locationController.text = state.data.location;
          ticketNoController.text = state.data.ticketNumber;
          return mainBody;
        }

        return Container();
      },
    );
  }

  _buildTextField(BuildContext context,
      {required TextEditingController controller,
      required String hint,
      required String label,
      TextInputAction? textInput,
      TextInputType? keybType,
      bool? isEditable}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: TextField(
        onTapOutside: (event) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: []);
          FocusManager.instance.primaryFocus?.unfocus();
        },
        enabled: isEditable ?? true,
        controller: controller,
        textInputAction: textInput ?? TextInputAction.next,
        keyboardType: keybType ?? TextInputType.text,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle: const TextStyle(
              fontSize: 14.0,
              color: AppColors.PrimaryColor,
              fontWeight: FontWeight.w500),
          border: const OutlineInputBorder(),
          hintText: hint,
          labelText: label,
          labelStyle: const TextStyle(
              fontSize: 14.0,
              color: AppColors.PrimaryColor,
            fontWeight: FontWeight.w500
          ),
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
