import 'dart:io';
import 'dart:math';

import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/models/object/TerminalData.dart';
import 'package:kambas/models/object/TransactionDetails.dart';
import 'package:kambas/models/object/UserDataItem.dart';
import 'package:kambas/models/request/database/DbTransactions.dart';
import 'package:uuid/uuid.dart';
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
    on<RequestPrintTicket>(_mapRequestPrintTicket);
    on<RequestReprintTicket>(_mapRequestReprintTicket);
    on<RequestSelectedFilterDate>(_mapRequestSelectedFilterDate);
    on<GetDbUserList>(_mapRequestDbUserList);
    on<RequestAddUser>(_mapRequestAddUser);
    on<RequestUpdateUser>(_mapRequestUpdateUser);
    on<RequestDeleteUser>(_mapRequestDeleteUser);
    on<GetTerminalSettings>(_mapGetTerminalSettings);
    on<RequestSaveSettings>(_mapRequestSaveSettings);
    on<GetTransactionDetails>(_mapGetTransactionDetails);

    on<RequestCurrentDate>((event, emit) async {
      // final now = await getAfricaDateTime();
      final now = DateTime.now();
      String dateString = DateFormat.yMMMMd('en_US').format(now);
      // String drawTime = DateFormat('h a').format(now);
      String drawTime = (now.hour <= 13 && now.hour > 6) ? "2 PM" : "8 PM";

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
    try {
      var response = await providerAccount.getStoredDBUserData(event.userID);
      if (response != null) {
        emit(RequestGetUserSuccess(response));
      } else {
        emit(const RequestFailed(AppStrings.error_general_throwable_msg));
      }
    } catch (e) {
      emit(RequestFailed(e.toString()));
    }
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
        await providerAccount.storeUsername(event.username);
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
    selectedFilteredDate = event.selectedDatetime.copyWith(
      hour: (event.selectedDatetime.hour <= 13 && event.selectedDatetime.hour > 6) ? 14 : 20,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
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

  Future<void> _mapGetTerminalSettings(
      GetTerminalSettings event, Emitter<StateAccount> emit) async {
    final response = await providerAccount.getDBTerminalData();
    final terminalData = TerminalData(
        stallName: response?.stallName ?? '',
        location: response?.location ?? '',
        agent: response?.agent ?? "",
        ticketNumber: response?.ticketNumber ?? '');

    emit(DisplayTerminalSettings(data: terminalData));
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

  Future<void> _mapRequestUpdateUser(
      RequestUpdateUser event, Emitter<StateAccount> emit) async {
    if (event.userID == -1) {
      emit(const RequestFailed(AppStrings.error_general_throwable_msg));
      return;
    }
    if (event.userName.isEmpty ||
        event.fullName.isEmpty ||
        event.email.isEmpty ||
        event.contactNo.isEmpty) {
      emit(const RequestFailed(AppStrings.error_register_inputfields_msg));
      return;
    }

    final isUpdated = await providerAccount.updateUser(
        user_id: event.userID,
        username: event.userName,
        fullName: event.fullName,
        email: event.email,
        contactNo: event.contactNo,
        updatedDate: DateTime.now());

    emit(isUpdated
        ? RequestSuccess()
        : const RequestFailed("error updating user"));
  }

  Future<void> _mapRequestDeleteUser(
      RequestDeleteUser event, Emitter<StateAccount> emit) async {
    if (event.userID == -1) {
      emit(const RequestFailed(AppStrings.error_general_throwable_msg));
      return;
    }

    final isDeleted = await providerAccount.deleteDBUserData(
      event.userID,
    );

    emit(isDeleted
        ? RequestSuccess()
        : const RequestFailed("error deleting user"));
  }

  Future<void> _mapRequestSaveSettings(
      RequestSaveSettings event, Emitter<StateAccount> emit) async {
    if (event.stallName.isEmpty || event.location.isEmpty) {
      emit(const RequestFailed(AppStrings.error_register_inputfields_msg));
      return;
    }

    final isUpdated = await providerAccount.setTerminalData(
        data: TerminalData(
            stallName: event.stallName,
            location: event.location,
            agent: event.agentName,
            ticketNumber: ''));

    emit(isUpdated
        ? RequestSuccess()
        : const RequestFailed("error saving changes"));
  }

  Future<void> _mapGetTransactionDetails(
      GetTransactionDetails event, Emitter<StateAccount> emit) async {
    if (event.ticket.isEmpty) {
      emit(const RequestFailed("Please Enter Ticket Number."));
      return;
    }

    final dbData = await providerAccount.getTransactionDetails(event.ticket);
    if (dbData != null) {
      final data = TransactionDetails(
          selectedBetNumber: "${dbData.betNumber1} and ${dbData.betNumber2}",
          placedDate: dbData.datePlaced,
          stallName: dbData.stallName,
          drawTime: dbData.drawTime,
          betAmount: dbData.betAmount,
          betPrize: dbData.betPrize);

      emit(DisplayTransactionDetails(data: data));
    } else {
      emit(const RequestFailed("No transaction Found."));
    }
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
        List<String> data1 = [
          element.stallName,
          element.location,
          element.datePlaced,
          element.ticketNo,
          element.drawTime,
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

  Future<void> _mapRequestPrintTicket(
      RequestPrintTicket event, Emitter<StateAccount> emit) async {
    // final currentDate = await getAfricaDateTime();
    final currentDate = DateTime.now();
    String initialDate = DateFormat('MMMM dd, yyyy').format(currentDate);
    String datePlaced = DateFormat('MMM dd, yyyy hh:mm a').format(currentDate);
    String drawTime = (currentDate.hour <= 13 && currentDate.hour > 6) ? "2 PM" : "8 PM";
    String drawTimePortuguese = (currentDate.hour <= 13 && currentDate.hour > 6) ? "14 Horas" : "20 Horas";

    final dbCreatedDate = currentDate.copyWith(
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );

    var terminalData = await providerAccount.getDBTerminalData();
    var selectedNumberResponse = await providerAccount.getBetNumbers();
    var betAmountResponse = await providerAccount.getBetAmount();

    const platformMethodChannel = MethodChannel('com.methodchannel/test');
    platformMethodChannel.invokeMethod(AppStrings.printMethod, {
      AppStrings.p_initialDate: initialDate,
      AppStrings.p_processedDate: datePlaced,
      AppStrings.p_ticketNumber: terminalData?.ticketNumber ?? "",
      AppStrings.p_betNumber:
          "${selectedNumberResponse![0]} and ${selectedNumberResponse[1]}",
      AppStrings.p_stallName: terminalData?.stallName ?? "N/A",
      AppStrings.p_agentName: terminalData?.agent ?? "N/A",
      AppStrings.p_drawSchedule: drawTimePortuguese,
      AppStrings.p_betAmount: betAmountResponse ?? "N/A",
      AppStrings.p_priceAmount:
          ((int.parse(betAmountResponse!) / 100) * 20000).toStringAsFixed(0),
    }).then((value) async {
      await providerAccount.storeDBTransaction(
        createdDate: dbCreatedDate,
        data: DBTransactions(
            datePlaced: datePlaced,
            drawTime: drawTime,
            stallName: terminalData?.stallName ?? "N/A",
            agentName: terminalData?.agent ?? "N/A",
            location: terminalData?.location ?? "N/A",
            ticketNo: terminalData?.ticketNumber ?? "",
            betNumber1: selectedNumberResponse[0].toString(),
            betNumber2: selectedNumberResponse[1].toString(),
            betAmount: betAmountResponse,
            betPrize: ((int.parse(betAmountResponse) / 100) * 20000)
                .toStringAsFixed(0),
            userName: await providerAccount.getCurrentUsername()),
      );

      //sets new ticket series after print success
      final uuid = const Uuid().v4().substring(0, 4);
      final ticketNumber = "T${Random().nextInt(5000)}$uuid";
      await providerAccount.setDBTicketSeriesNo(ticketNumber: ticketNumber);
    });

    await providerAccount.deleteUserBetInput();
    emit(const RequestGoToHome());
  }

  Future<void> _mapRequestReprintTicket(
      RequestReprintTicket event, Emitter<StateAccount> emit) async {
    if (event.ticketNo.isEmpty) {
      emit(const RequestFailed("Please Enter Ticket Number."));
      return;
    }

    final dbData = await providerAccount.getTransactionDetails(event.ticketNo);
    if (dbData != null) {

      const platformMethodChannel = MethodChannel('com.methodchannel/test');
      platformMethodChannel.invokeMethod(AppStrings.printMethod, {
        AppStrings.p_initialDate:
            DateFormat('MMMM dd, yyyy').format(DateTime.now()),
        AppStrings.p_processedDate: dbData.datePlaced,
        AppStrings.p_ticketNumber: dbData.ticketNo,
        AppStrings.p_betNumber: "${dbData.betNumber1} and ${dbData.betNumber2}",
        AppStrings.p_stallName: dbData.stallName,
        AppStrings.p_agentName: dbData.agentName,
        AppStrings.p_drawSchedule: dbData.drawTime,
        AppStrings.p_betAmount: dbData.betAmount,
        AppStrings.p_priceAmount: dbData.betPrize,
      });
    } else {
      emit(const RequestFailed("No transaction Found."));
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
