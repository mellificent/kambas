import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:kambas/models/object/TerminalData.dart';
import 'package:kambas/models/object/TransactionDetails.dart';
import 'package:kambas/models/object/TransactionRowItem.dart';
import 'package:kambas/models/object/UserDataItem.dart';
import 'package:uuid/uuid.dart';

import '../../utils/validator/Validator.dart';

abstract class StateDashboard extends Equatable {
  const StateDashboard();

  @override
  List<Object> get props => [];
}

class InitStateDashboard extends StateDashboard {
  @override
  List<Object> get props => [];
}

class SetDashboardData extends StateDashboard {
  final List<TransactionRowItemData> transactionsData;

  const SetDashboardData({
    required this.transactionsData
  });

  @override
  List<Object> get props => [transactionsData];
}

class RequestFailed extends StateDashboard {
  final String error;

  const RequestFailed(this.error);

  @override
  List<Object> get props => [error, Random().nextInt(5000)];

  @override
  String toString() => 'RequestPostAccountFailed { error: $error }';
}

class RequestSuccess extends StateDashboard {
  @override
  String toString() => 'RequestSuccess';
}

class RequestLoading extends StateDashboard {
  final String message;

  const RequestLoading(this.message);
}
