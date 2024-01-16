import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class EventAccount extends Equatable {
  const EventAccount();
  @override
  List<Object> get props => [];
}

class InitEvent extends EventAccount {
  @override
  List<Object> get props => [];
}

class RequestCurrentDate extends EventAccount {
  @override
  List<Object> get props => ["RequestCurrentDate", Random().nextInt(5000)];
}

class GetUserDetails extends EventAccount {
  @override
  List<Object> get props => ["GetUserDetails", Random().nextInt(5000)];
}

class FormFieldValueOnChange extends EventAccount {
  final String value;
  final String fieldName;
  final bool obscure;

  const FormFieldValueOnChange(this.fieldName, this.value, {this.obscure = false});

  @override
  List<Object> get props => [fieldName, value, obscure];
}

class PostLoginCredentials extends EventAccount {
  final String username;
  final String password;

  const PostLoginCredentials(
      this.username,
      this.password,
      );

  @override
  List<Object> get props => [username, password,];
}

class PostRegistration extends EventAccount {
  @override
  List<Object> get props => ['PostRegistration'];
}

class FormFieldChangeObscurity extends EventAccount {
  final String fieldName;

  const FormFieldChangeObscurity(this.fieldName);

  @override
  List<Object> get props => [fieldName];
}

class PostLogoutUser extends EventAccount {
  @override
  List<Object> get props => ['PostLogoutUser'];
}

class RequestReprintTicket extends EventAccount {
  @override
  List<Object> get props => ['RequestReprintTicket'];
}

class PostBetNumber extends EventAccount {
  final String selectedNumber;

  PostBetNumber(this.selectedNumber);

  @override
  List<Object> get props => ['PostBetNumber', Random().nextInt(5000), selectedNumber];
}

class PostBetPage extends EventAccount {
  final bool isInitialPage;

  PostBetPage(this.isInitialPage);

  @override
  List<Object> get props => ['PostBetPage', isInitialPage];
}

class RequestPostBetAmount extends EventAccount {
  const RequestPostBetAmount();

  @override
  List<Object> get props => ['RequestPostBetAmount', Random().nextInt(5000),];
}

class RequestUpdateBetAmount extends EventAccount {
  final String amount;

  const RequestUpdateBetAmount(this.amount);

  @override
  List<Object> get props => ['UpdateBetAmount', Random().nextInt(5000), amount];
}

class RequestDisplayBetNumber extends EventAccount {
  RequestDisplayBetNumber();

  @override
  List<Object> get props => ['RequestDisplayBetNumber', Random().nextInt(5000)];
}

class RequestDisplayBetAmount extends EventAccount {
  RequestDisplayBetAmount();

  @override
  List<Object> get props => ['RequestDisplayBetAmount', Random().nextInt(5000)];
}

