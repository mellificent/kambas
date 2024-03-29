import 'dart:io';
import 'dart:math';

import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/models/responses/ResponseUserDetails.dart';
import '../../../providers/ProviderAccount.dart';
import '../../models/request/RequestOAuth.dart';
import '../../utils/validator/BaseInput.dart';
import '../../utils/validator/Validator.dart';
import '../../utils/validator/field/FormConfirmPassword.dart';
import '../../utils/validator/field/FormEmail.dart';
import '../../utils/validator/field/FormPassword.dart';
import '../../utils/validator/field/FormRequiredField.dart';
import 'EventAccount.dart';
import 'StateAccount.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class BlocAccount extends Bloc<EventAccount, StateAccount> {
  final ProviderAccount providerAccount;
  FormLogin _formLogin = FormLogin();

  String betNumber1 = "0";
  String betAmount = "0";

  BlocAccount({
    required this.providerAccount,
  }) : super(InitStateAccount()) {
    _formLogin = FormLogin();

    on<GetUserDetails>(_mapUserDetails);
    on<FormFieldValueOnChange>(_mapFormFieldValueOnChangeState);
    on<FormFieldChangeObscurity>(_mapFormFieldChangeObscurityState);
    on<PostLoginCredentials>(_mapPostLogin);
    on<PostLogoutUser>(_mapPostLogoutUser);
    on<PostBetNumber>(_mapPostBetNumber);
    on<RequestUpdateBetAmount>(_mapRequestUpdateBetAmount);
    on<RequestDisplayBetNumber>(_mapDisplayBetNumber);
    on<RequestPostBetAmount>(_mapPostBetAmount);
    on<RequestDisplayBetAmount>(_mapRequestDisplayBetAmount);

    on<RequestCurrentDate>((event, emit) async {
      // final now = await getAfricaDateTime();
      final now = DateTime.now();
      String dateString = DateFormat.yMMMMd('en_US').format(now);
      String drawTime = DateFormat('h a').format(now);

      emit(DisplayCurrentDate(dateString));
      emit(DisplayDrawTime(drawTime));
    });
    on<PostBetPage>((event, emit) async {
      emit(UpdateSwipeLabel(event.isInitialPage ? AppStrings.swipeLabel1 : AppStrings.swipeLabel2));
    });

    //todo:
    on<RequestReprintTicket>((event, emit) async {
      // final currentDate = await getAfricaDateTime();
      final currentDate = DateTime.now();
      String initialDate = DateFormat('MMMM dd, yyyy').format(currentDate);
      String datePlaced = DateFormat('MMM dd, yyyy hh:mm a').format(currentDate);
      String drawTime = DateFormat('h a').format(currentDate);

      //todo: ticket no based on admin and random per transaction starting at
      // int min = pow(10, 6 - 1).toInt();
      // int max = (pow(10, 6) - 1).toInt();
      // final randomTicketNumber = min + Random().nextInt(max - min);

      var selectedNumberResponse = await providerAccount.getBetNumbers();
      var betAmountResponse = await providerAccount.getBetAmount();

      const platformMethodChannel = MethodChannel('com.methodchannel/test');
      platformMethodChannel.invokeMethod(AppStrings.printMethod, {
        AppStrings.p_initialDate: initialDate,
        AppStrings.p_processedDate: datePlaced,
        AppStrings.p_ticketNumber: "N/A",
        AppStrings.p_betNumber: (selectedNumberResponse != null) ? "${selectedNumberResponse[0]} and ${selectedNumberResponse[1]}" : "",
        AppStrings.p_stallName: "N/A",
        AppStrings.p_drawSchedule: drawTime,
        AppStrings.p_betAmount: betAmountResponse,
        AppStrings.p_priceAmount: ((int.parse(betAmountResponse!) / 100) * 20000).toStringAsFixed(0),
      });

      await providerAccount.deleteUserBetInput();
      emit(const RequestGoToHome());
    });

  }

  // Future<DateTime> getAfricaDateTime() async {
  //   var africa = tz.getLocation('Africa/Luanda');
  //   var now = tz.TZDateTime.now(africa);
  //   return now;
  // }

  Future<void> _mapUserDetails(
      GetUserDetails event, Emitter<StateAccount> emit) async {
    // try {
    //   var response = await providerAccount.getUser();
    //   if (response.error == null) {
    //     UserData data = response.response!.data!;
    //     var isAppNewLaunch = await providerAccount.getLocalNewLaunchStatus();
    //     await providerAccount.setNewLaunchStatus();
    //     emit(RequestGetUserSuccess(userData: data, isAppNewLaunch: isAppNewLaunch));
    //   } else {
    //     if(response.error!.relogin ?? false) providerAccount.logout();
    //     emit(RequestAccountFailed(response.error!.errorMsg, response.error!.relogin ?? false));
    //   }
    // } catch (e) {
    //   providerAccount.logout();
    //   emit(RequestAccountFailed(e.toString(), true));
    // }
  }

  Future<void> _mapFormFieldValueOnChangeState(
      FormFieldValueOnChange event, Emitter<StateAccount> emit) async {
    if (event.fieldName == FormLogin.ID_USERNAME ||
        event.fieldName == FormLogin.ID_PASSWORD) return;

    // emit(UpdateFormField(
    //     fieldName: formInput.fieldName,
    //     value: formInput.value,
    //     error: formInput.error.errorMessage,
    //     obscure: formInput.obscure,
    //     formPage: form.formPage(),
    //     formStatus: form.status));
    //
    // emit(UpdateFormField(fieldName: "Sign Up Button", value: (_formRegister1.status == ValidationStatus.valid && ((_formRegister1.isEULASigned.value ?? "false") == "true")) ? "true" : "false"));
  }

  Future<void> _mapFormFieldChangeObscurityState(
      FormFieldChangeObscurity event, Emitter<StateAccount> emit) async {
    FormInput formInput;
    switch (event.fieldName) {
      case FormLogin.ID_PASSWORD:
        formInput = _formLogin.setPasswordObscurity(event.fieldName);
        emit(UpdateFormField(
            fieldName: formInput.fieldName,
            value: formInput.value,
            error: formInput.error.errorMessage,
            obscure: formInput.obscure,
            formStatus: _formLogin.status));
        break;
    }
  }

  Future<void> _mapPostLogin(
      PostLoginCredentials event, Emitter<StateAccount> emit) async {
    // try {
    //   emit(const RequestLoadingAccount("logging in"));
    //
    //   final bool hasLogoutToken = await providerAccount.hasLogoutToken();
    //   if (hasLogoutToken) {
    //     await providerAccount.initTokenHeader();
    //     providerAccount.logout();
    //     providerAccount.setLogoutTag();
    //     emit(const RequestPostAccountFailed('Your email address is not verified.'));
    //     return;
    //   }

    // var response = await providerAccount.postLogin(RequestOAuth.newToken(email: event.username, password: event.password));
    //   if (response.error == null) {
    //
    //     /**load user details after successful login**/
    //     // await providerAccount.getUser();
    //
    emit(const RequestPostLoginSuccess());
    //   } else {
    //     providerAccount.logout();
    //     emit(RequestPostAccountFailed(response.error!.errorMsg));
    //   }
    // } catch (e) {
    //   // if (Foundation.kDebugMode) providerAccount.logout();
    //   emit(RequestPostAccountFailed(e.toString()));
    // }
  }

  Future<void> _mapPostLogoutUser(
      PostLogoutUser event, Emitter<StateAccount> emit) async {
    providerAccount.logout();
    providerAccount.setLogoutTag();
    emit(const RequestPostAccountFailed(''));
  }

  Future<void> _mapPostBetNumber(
      PostBetNumber event, Emitter<StateAccount> emit) async {
    if (betNumber1 == "0"){
      betNumber1 = event.selectedNumber;
      debugPrint(" betNumber1 $betNumber1");
      emit(const UpdateBetChooseLabel(AppStrings.chooseNumberLabel2));
    } else {
      debugPrint(" betNumber1 $betNumber1 and betnumber2 ${event.selectedNumber}");
      await providerAccount.saveBetNumbers([betNumber1, event.selectedNumber]);
      emit(RequestBetNumbersDone());
    }
  }

  Future<void> _mapPostBetAmount(
      RequestPostBetAmount event, Emitter<StateAccount> emit) async {
    if (betAmount != "0") {
      await providerAccount.saveBetAmount(betAmount);
    }
    emit(const RequestBetNumbersDone());
  }

  Future<void> _mapRequestUpdateBetAmount(
      RequestUpdateBetAmount event, Emitter<StateAccount> emit) async {
    if(event.amount != "0"){
      betAmount = event.amount;
      emit(DisplayBetAmount(betAmount));
    }
  }

  Future<void> _mapDisplayBetNumber(RequestDisplayBetNumber event, Emitter<StateAccount> emit) async {
    try {
      var response = await providerAccount.getBetNumbers();
      if (response != null && response.length == 2) {
        emit(UpdateBetSelectedNumbers('${response[0]} and ${response[1]}'));
      } else {
        emit(const UpdateBetSelectedNumbers(''));
      }
    } catch (e) {
      providerAccount.deleteUserBetInput();
      emit(const UpdateBetSelectedNumbers(''));
    }
  }

  Future<void> _mapRequestDisplayBetAmount(RequestDisplayBetAmount event, Emitter<StateAccount> emit) async {
    try {
      var response = await providerAccount.getBetAmount();
      if (response != null) {
        emit(DisplayBetAmount(response));
      } else {
        emit(const DisplayBetAmount(''));
      }
    } catch (e) {
      providerAccount.deleteUserBetInput();
      emit(const DisplayBetAmount(''));
    }
  }

}

class FormInput {
  final String fieldName;
  final dynamic value;
  final BaseInput error;
  final bool obscure;

  const FormInput(
      {this.fieldName = "",
      this.value,
      required this.error,
      this.obscure = false});
}

class FormLogin with ValidatorMixins {
  static const ID_USERNAME = 'user';
  static const ID_PASSWORD = 'pass';

  FormRequiredField username;
  FormPassword password;

  FormLogin({
    this.username = const FormRequiredField.init(),
    this.password = const FormPassword.init(),
  });

  @override
  List<BaseInput> get inputs => [
        username,
        password,
      ];

  FormInput setEmail(String fieldname, String value) {
    username = FormRequiredField.value(value);
    return FormInput(fieldName: fieldname, value: value, error: username);
  }

  FormInput setPassword(String fieldname, String value) {
    password = FormPassword.value(value, obscure: password.obscure);

    return FormInput(
        fieldName: fieldname,
        value: value,
        error: password,
        obscure: password.obscure);
  }

  FormInput setPasswordObscurity(String fieldname) {
    password = FormPassword.value(password.value, obscure: !password.obscure);
    return FormInput(
        fieldName: fieldname,
        value: password.value,
        error: password,
        obscure: password.obscure);
  }
}
