import 'dart:io';
import 'dart:math';

import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/models/object/UserDataItem.dart';
import 'package:kambas/models/request/database/DbTransactions.dart';
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
import 'package:to_csv/to_csv.dart' as exportCSV;

class BlocAccount extends Bloc<EventAccount, StateAccount> {
  final ProviderAccount providerAccount;
  FormLogin _formLogin = FormLogin();

  String betNumber1 = "0";
  String betAmount = "0";
  DateTime selectedFilteredDate = DateTime.now();

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
    on<RequestExportCSV>(_mapRequestExportCSV);
    on<RequestReprintTicket>(_mapRequestReprintTicket);
    on<RequestSelectedFilterDate>(_mapRequestSelectedFilterDate);
    on<GetDbUserList>(_mapRequestDbUserList);
    on<RequestAddUser>(_mapRequestAddUser);

    on<RequestCurrentDate>((event, emit) async {
      // final now = await getAfricaDateTime();
      final now = DateTime.now();
      String dateString = DateFormat.yMMMMd('en_US').format(now);
      String drawTime = DateFormat('h a').format(now);

      emit(DisplayCurrentDate(dateString));
      emit(DisplayDrawTime(drawTime));
    });
    on<PostBetPage>((event, emit) async {
      emit(UpdateSwipeLabel(event.isInitialPage
          ? AppStrings.swipeLabel1
          : AppStrings.swipeLabel2));
    });
    on<RequestDialog>((event, emit) async {
      emit(ShowDialog(true));
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
    try {
      emit(const RequestLoadingAccount("logging in"));

      final storedList = await providerAccount.getStoredDBUsers();
      final list = storedList
          .where((element) => (element.userName == event.username &&
              element.password == event.password))
          .toList();

      if (list.isNotEmpty ||
          (event.username == "admin" && event.password == "kambas123")) {
        emit(RequestPostLoginSuccess(isAdminUser: event.username == "admin"));
      } else {
        emit(const RequestFailed(AppStrings.error_login_invalidfields_msg));
      }
    } catch (e) {
      emit(RequestFailed(e.toString()));
    }
  }

  Future<void> _mapPostLogoutUser(
      PostLogoutUser event, Emitter<StateAccount> emit) async {
    providerAccount.logout();
    providerAccount.setLogoutTag();
    emit(const RequestFailed(''));
  }

  Future<void> _mapPostBetNumber(
      PostBetNumber event, Emitter<StateAccount> emit) async {
    if (betNumber1 == "0") {
      betNumber1 = event.selectedNumber;
      debugPrint(" betNumber1 $betNumber1");
      emit(const UpdateBetChooseLabel(AppStrings.chooseNumberLabel2));
    } else {
      debugPrint(
          " betNumber1 $betNumber1 and betnumber2 ${event.selectedNumber}");
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
    if (event.amount != "0") {
      betAmount = event.amount;
      emit(DisplayBetAmount(betAmount));
    }
  }

  Future<void> _mapDisplayBetNumber(
      RequestDisplayBetNumber event, Emitter<StateAccount> emit) async {
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

  Future<void> _mapRequestDisplayBetAmount(
      RequestDisplayBetAmount event, Emitter<StateAccount> emit) async {
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

  Future<void> _mapRequestSelectedFilterDate(
      RequestSelectedFilterDate event, Emitter<StateAccount> emit) async {
    selectedFilteredDate = event.selectedDatetime;
    final label = DateFormat('EEE MMM dd ha').format(selectedFilteredDate);

    emit(DisplayFilterDate(label));
  }

  Future<void> _mapRequestDbUserList(
      GetDbUserList event, Emitter<StateAccount> emit) async {
    // selectedFilteredDate = event.selectedDatetime;
    // final label = DateFormat('EEE MMM dd ha').format(selectedFilteredDate);

    final list = await providerAccount.getStoredDBUsers();
    emit(DisplayUserList(list));
  }

  Future<void> _mapRequestAddUser(
      RequestAddUser event, Emitter<StateAccount> emit) async {
    if (event.userName.isEmpty ||
        event.fullName.isEmpty ||
        event.email.isEmpty ||
        event.contactNo.isEmpty ||
        event.password.isEmpty) {
      emit(RequestFailed(AppStrings.error_register_inputfields_msg));
      return;
    }
    final currentDate = DateTime.now().toString();
    final isStored = await providerAccount.storeNewUser(UserItemData(
        Random().nextInt(1000),
        userName: event.userName,
        fullName: event.fullName,
        email: event.email,
        contactNo: event.contactNo,
        password: event.password,
        createdAt: currentDate,
        updatedAt: currentDate));

    emit(
        isStored ? RequestSuccess() : const RequestFailed("error adding user"));
  }

  Future<void> _mapRequestExportCSV(
      RequestExportCSV event, Emitter<StateAccount> emit) async {
    try {
      List<String> header = [
        "stall_name",
        "location",
        "date/time placed",
        "ticket_number",
        "cut-off",
        "bet_number1",
        "bet_number2",
        "bet_amount",
        "bet_prize",
        "encoded_by_username"
      ];

      final storedData =
          await providerAccount.getFilteredDBTransactions(selectedFilteredDate);
      List<List<String>> listOfLists = [];

      for (var element in storedData) {
        final date = DateTime.parse(element.createdDate);
        String datePlaced = DateFormat('MMM dd, yyyy hh a').format(date);
        String drawTime = DateFormat('h a').format(date);

        List<String> data1 = [
          element.stallName,
          element.location,
          datePlaced,
          element.ticketNo,
          drawTime,
          element.betNumber1,
          element.betNumber2,
          element.betAmount,
          element.betPrize,
          element.userName
        ];

        listOfLists.add(data1);
      }

      var response =
          await exportCSV.myCSV(header, listOfLists, fileName: "kambas");

      // var response = await providerAccount.getBetAmount();
      // if (response != null) {
      //   // emit(DisplayBetAmount(response));
      // } else {
      //   // emit(const DisplayBetAmount(''));
      // }
    } catch (e) {
      // emit(const DisplayBetAmount(''));
    }
  }

  Future<void> _mapRequestReprintTicket(
      RequestReprintTicket event, Emitter<StateAccount> emit) async {
    // final currentDate = await getAfricaDateTime();
    final currentDate = DateTime.now();
    String initialDate = DateFormat('MMMM dd, yyyy').format(currentDate);
    String datePlaced = DateFormat('MMM dd, yyyy hh:mm a').format(currentDate);
    String drawTime = DateFormat('h a').format(currentDate);

    //todo: ticket no based on admin and random per transaction starting at
    int min = pow(10, 6 - 1).toInt();
    int max = (pow(10, 6) - 1).toInt();
    final randomTicketNumber = min + Random().nextInt(max - min);

    var selectedNumberResponse = await providerAccount.getBetNumbers();
    var betAmountResponse = await providerAccount.getBetAmount();

    const platformMethodChannel = MethodChannel('com.methodchannel/test');
    platformMethodChannel.invokeMethod(AppStrings.printMethod, {
      AppStrings.p_initialDate: initialDate,
      AppStrings.p_processedDate: datePlaced,
      AppStrings.p_ticketNumber: "N/A",
      AppStrings.p_betNumber:
          "${selectedNumberResponse![0]} and ${selectedNumberResponse[1]}",
      AppStrings.p_stallName: "N/A",
      AppStrings.p_drawSchedule: drawTime,
      AppStrings.p_betAmount: betAmountResponse ?? "N/A",
      AppStrings.p_priceAmount:
          ((int.parse(betAmountResponse!) / 100) * 20000).toStringAsFixed(0),
    }).then((value) async {
      final dbCreatedDate = currentDate
          .copyWith(
            minute: 0,
            second: 0,
            millisecond: 0,
            microsecond: 0,
          )
          .toString();
      await providerAccount.storeDBTransaction(
        DBTransactions(
            createdDate: dbCreatedDate,
            stallName: "N/A",
            location: "N/A",
            ticketNo: randomTicketNumber.toString(),
            betNumber1: selectedNumberResponse[0].toString(),
            betNumber2: selectedNumberResponse[1].toString(),
            betAmount: betAmountResponse,
            betPrize: ((int.parse(betAmountResponse) / 100) * 20000)
                .toStringAsFixed(0),
            userName: "testUser"),
      );
    });

    await providerAccount.deleteUserBetInput();
    emit(const RequestGoToHome());
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
