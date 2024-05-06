import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kambas/constants/app_strings.dart';
import 'package:kambas/models/object/TerminalData.dart';
import 'package:kambas/models/object/TransactionDetails.dart';
import 'package:kambas/models/object/TransactionRowItem.dart';
import 'package:kambas/models/object/UserDataItem.dart';
import 'package:kambas/models/request/RequestBetData.dart';
import 'package:kambas/models/request/RequestBets.dart';
import 'package:kambas/models/request/database/DbTransactions.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/ProviderAccount.dart';
import '../../models/request/RequestOAuth.dart';
import '../../utils/validator/BaseInput.dart';
import '../../utils/validator/Validator.dart';
import '../../utils/validator/field/FormPassword.dart';
import '../../utils/validator/field/FormRequiredField.dart';
import 'EventDashboard.dart';
import 'StateDashboard.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:to_csv/to_csv.dart' as exportCSV;

class BlocDashboard extends Bloc<EventDashboard, StateDashboard> {
  final ProviderAccount providerAccount;

  BlocDashboard({
    required this.providerAccount,
  }) : super(InitStateDashboard()) {

    on<RequestGetBetList>(_mapGetBetList);
  }

  Future<void> _mapGetBetList(RequestGetBetList event,
      Emitter<StateDashboard> emit) async {
    try {
      var response = await providerAccount.getBetList();
      if (response.response != null) {
        List<TransactionRowItemData> transactionList = [];
        response.response?.bets?.forEach((element) {
          transactionList.add(
              TransactionRowItemData(element.betId ?? 0,
                  ticketNumber: element.ticketNumber ?? '',
                  cutOff: element.cutOff ?? '',
                  stallName: element.stallName ??'',
                  location: element.location ?? '',
                  betNumber1: element.betNumber1.toString() ??'',
                  betNumber2: element.betNumber2.toString() ??'',
                  dateTimePlaced: element.dateTimePlaced ??'',
                  betAmount: element.betAmount.toString() ?? '',
                  betPrize: element.betPrize.toString() ?? '',
                  encodedByUserName: element.encodedByUserName ??''
              )
          );
        });
        emit(SetDashboardData(transactionsData: transactionList));
      } else {
        emit(const RequestFailed(AppStrings.error_general_throwable_msg));
      }
    } catch (e) {
      emit(RequestFailed(e.toString()));
    }
  }

}
