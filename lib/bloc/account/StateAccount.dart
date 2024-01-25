import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:kambas/models/object/TerminalData.dart';
import 'package:kambas/models/object/TransactionDetails.dart';
import 'package:kambas/models/object/UserDataItem.dart';
import 'package:uuid/uuid.dart';

import '../../utils/validator/Validator.dart';

abstract class StateAccount extends Equatable {
  const StateAccount();

  @override
  List<Object> get props => [];
}

class InitStateAccount extends StateAccount {
  @override
  List<Object> get props => [];
}

class DisplayCurrentDate extends StateAccount {
  final String text;

  const DisplayCurrentDate(this.text);

  @override
  List<Object> get props => ['DisplayCurrentDate', text];
}

class DisplayDrawTime extends StateAccount {
  final String text;

  const DisplayDrawTime(this.text);

  @override
  List<Object> get props => ['DisplayDrawTime', text];
}

class RequestGetUserSuccess extends StateAccount {
  final UserItemData userData;

  const RequestGetUserSuccess(
    this.userData,
  );

  @override
  List<Object> get props => [userData];

  @override
  String toString() => 'RequestGetUserSuccess $userData';
}

class RequestAccountFailed extends StateAccount {
  final String error;
  final bool relogin;

  const RequestAccountFailed(this.error, [this.relogin = false]);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'RequestGetUserFailed { error: $error }';
}

class UpdateFormField extends StateAccount {
  final String fieldName;
  final dynamic value;
  final String? error;
  final bool obscure;
  final String? formPage;
  final ValidationStatus formStatus;

  const UpdateFormField(
      {required this.fieldName,
      this.value,
      this.error,
      this.obscure = false,
      this.formPage,
      this.formStatus = ValidationStatus.valid});

  @override
  List<Object> get props => [value, fieldName, obscure];

  @override
  String toString() =>
      'UpdateFormField { fieldName: $fieldName, value: $value, error: $error, obscure: $obscure, status: $formStatus }';
}

class RequestPostLoginSuccess extends StateAccount {
  final bool isAdminUser;

  const RequestPostLoginSuccess({required this.isAdminUser});

  @override
  List<Object> get props => ['RequestPostLoginSuccess', isAdminUser];
}

class RequestFailed extends StateAccount {
  final String error;

  const RequestFailed(this.error);

  @override
  List<Object> get props => [error, Random().nextInt(5000)];

  @override
  String toString() => 'RequestPostAccountFailed { error: $error }';
}

class RequestSuccess extends StateAccount {
  @override
  String toString() => 'RequestSuccess';
}

class RequestLoadingAccount extends StateAccount {
  final String message;

  const RequestLoadingAccount(this.message);
}

class ShowDialog extends StateAccount {
  final bool showDialog;

  const ShowDialog(this.showDialog);

  @override
  List<Object> get props => [showDialog, Random().nextInt(5000)];

  @override
  String toString() => 'ShowDialog $showDialog';
}

class UpdateBetChooseLabel extends StateAccount {
  final String labelText;

  const UpdateBetChooseLabel(this.labelText);
}

class UpdateSwipeLabel extends StateAccount {
  final String labelText;

  const UpdateSwipeLabel(this.labelText);
}

class RequestBetNumbersDone extends StateAccount {
  const RequestBetNumbersDone();

  @override
  List<Object> get props => ['RequestBetNumbersDone'];
}

class UpdateBetSelectedNumbers extends StateAccount {
  final String text;

  const UpdateBetSelectedNumbers(this.text);

  @override
  List<Object> get props => ['UpdateBetSelectedNumbers', text];
}

class DisplayBetAmount extends StateAccount {
  final String text;

  const DisplayBetAmount(this.text);

  @override
  List<Object> get props => ['DisplayBetAmount', text];
}

class RequestGoToHome extends StateAccount {
  const RequestGoToHome();

  @override
  List<Object> get props => ['RequestGoToHome'];
}

class DisplayFilterDate extends StateAccount {
  final String text;

  const DisplayFilterDate(this.text);

  @override
  List<Object> get props => ['DisplayFilterDate', text];
}

class DisplayUserList extends StateAccount {
  final List<UserItemData> list;

  const DisplayUserList(this.list);

  @override
  List<Object> get props => ['DisplayUserList', list];
}

class DisplayTerminalSettings extends StateAccount {
  final TerminalData data;

  const DisplayTerminalSettings(
      {required this.data,});

  @override
  List<Object> get props => ['DisplayUserList', data,];
}

class DisplayTransactionDetails extends StateAccount {
  final TransactionDetails data;

  const DisplayTransactionDetails({required this.data,});

  @override
  List<Object> get props => ['DisplayTransactionDetails', data,];
}
