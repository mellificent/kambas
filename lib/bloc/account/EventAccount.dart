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

class GetUserDetails extends EventAccount {
  final int userID;

  const GetUserDetails(this.userID,);

  @override
  List<Object> get props => ["GetUserDetails", userID, Random().nextInt(5000)];
}

class GetDbUserList extends EventAccount {
  @override
  List<Object> get props => ["GetDbUserList", Random().nextInt(5000)];
}

class GetTerminalSettings extends EventAccount {
  @override
  List<Object> get props => ["GetTerminalSettings", Random().nextInt(5000)];
}

class GetTransactionDetails extends EventAccount {
  final String ticket;

  const GetTransactionDetails(this.ticket,);

  @override
  List<Object> get props => ["GetTransactionDetails", ticket, Random().nextInt(5000)];
}

class FormFieldValueOnChange extends EventAccount {
  final String value;
  final String fieldName;
  final bool obscure;

  const FormFieldValueOnChange(this.fieldName, this.value,
      {this.obscure = false});

  @override
  List<Object> get props => [fieldName, value, obscure];
}

class FormFieldChangeObscurity extends EventAccount {
  final String fieldName;

  const FormFieldChangeObscurity(this.fieldName);

  @override
  List<Object> get props => [fieldName];
}



class PostLoginCredentials extends EventAccount {
  final String username;
  final String password;

  const PostLoginCredentials(
    this.username,
    this.password,
  );

  @override
  List<Object> get props => [
        username,
        password,
      ];
}

class PostRegistration extends EventAccount {
  @override
  List<Object> get props => ['PostRegistration'];
}

class PostLogoutUser extends EventAccount {
  @override
  List<Object> get props => ['PostLogoutUser'];
}

class PostBetNumber extends EventAccount {
  final String selectedNumber;

  PostBetNumber(this.selectedNumber);

  @override
  List<Object> get props =>
      ['PostBetNumber', Random().nextInt(5000), selectedNumber];
}

class PostBetPage extends EventAccount {
  final bool isInitialPage;

  PostBetPage(this.isInitialPage);

  @override
  List<Object> get props => ['PostBetPage', isInitialPage];
}



class RequestCurrentDate extends EventAccount {
  @override
  List<Object> get props => ["RequestCurrentDate", Random().nextInt(5000)];
}

class RequestPrintTicket extends EventAccount {
  @override
  List<Object> get props => ['RequestPrintTicket'];
}

class RequestReprintTicket extends EventAccount {
  final String ticketNo;

  const RequestReprintTicket(this.ticketNo);

  @override
  List<Object> get props => ['RequestReprintTicket', Random().nextInt(5000), ticketNo];
}

class RequestPostBetAmount extends EventAccount {
  const RequestPostBetAmount();

  @override
  List<Object> get props => [
        'RequestPostBetAmount',
        Random().nextInt(5000),
      ];
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

class RequestExportCSV extends EventAccount {
  @override
  List<Object> get props => ['RequestExportCSV'];
}

class RequestSelectedFilterDate extends EventAccount {
  final DateTime selectedDatetime;

  const RequestSelectedFilterDate(this.selectedDatetime);

  @override
  List<Object> get props => ['RequestSelectedFilterDate', selectedDatetime];
}

class RequestAddUser extends EventAccount {
  final String userName;
  final String fullName;
  final String email;
  final String contactNo;
  final String password;

  const RequestAddUser({
    required this.userName,
    required this.fullName,
    required this.email,
    required this.contactNo,
    required this.password,
  });

  @override
  List<Object> get props => [userName, fullName, email, contactNo, password];
}

class RequestUpdateUser extends EventAccount {
  final int userID;
  final String userName;
  final String fullName;
  final String email;
  final String contactNo;

  const RequestUpdateUser({
    required this.userID,
    required this.userName,
    required this.fullName,
    required this.email,
    required this.contactNo,
  });

  @override
  List<Object> get props => [userID, userName, fullName, email, contactNo,];
}

class RequestDeleteUser extends EventAccount {
  final int userID;

  const RequestDeleteUser({
    required this.userID,
  });

  @override
  List<Object> get props => [userID,];
}

class RequestDialog extends EventAccount {
  RequestDialog();

  @override
  List<Object> get props => ["RequestDialog", Random().nextInt(5000)];
}

class RequestSaveSettings extends EventAccount {
  final String stallName;
  final String location;
  final String agentName;

  const RequestSaveSettings({
    required this.stallName,
    required this.location,
    required this.agentName,
  });

  @override
  List<Object> get props => [stallName, location, agentName];
}
