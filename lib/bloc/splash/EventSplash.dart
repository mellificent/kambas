import 'package:equatable/equatable.dart';

abstract class EventSplash extends Equatable {
  const EventSplash();
  @override
  List<Object> get props => [];
}

class AppStarted extends EventSplash {}

class GetAppVersion extends EventSplash {}
