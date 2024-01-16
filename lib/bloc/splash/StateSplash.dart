import 'package:equatable/equatable.dart';

abstract class StateSplash extends Equatable {
  const StateSplash();

  @override
  List<Object> get props => [];
}

class InitState extends StateSplash {
  @override
  List<Object> get props => [];
}

class AuthenticationAuthenticated extends StateSplash {}

class AuthenticationUnauthenticated extends StateSplash {}

class AppInit extends StateSplash {
  final String appVersion;

  AppInit(this.appVersion);

  @override
  List<Object> get props => [appVersion];

  @override
  String toString() => 'AppVersion { appVersion: $appVersion }';
}