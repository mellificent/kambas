import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class EventDashboard extends Equatable {
  const EventDashboard();

  @override
  List<Object> get props => [];
}

class InitEvent extends EventDashboard {
  @override
  List<Object> get props => [];
}

class RequestGetBetList extends EventDashboard {
  const RequestGetBetList();

  @override
  List<Object> get props => [
        'RequestGetBetList',
        Random().nextInt(5000),
      ];
}
