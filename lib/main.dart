import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kambas/providers/ProviderAccount.dart';
import 'package:kambas/providers/ProviderSelections.dart';
import 'package:kambas/repository/DatabaseRepository.dart';
import 'package:kambas/repository/HardCodeRepository.dart';
import 'package:kambas/repository/PreferenceRepository.dart';
import 'package:kambas/repository/RemoteRepository.dart';
import 'package:kambas/screens/ScreenSplash.dart';
import 'package:kambas/screens/account/login/ScreenLogin.dart';
import 'package:kambas/screens/main/ScreenReprint.dart';
import 'package:kambas/screens/main/admin/ScreenAdmin.dart';
import 'package:kambas/screens/main/ScreenAmount.dart';
import 'package:kambas/screens/main/ScreenBet.dart';
import 'package:kambas/screens/main/ScreenCheckout.dart';
import 'package:kambas/screens/main/ScreenMain.dart';
import 'package:kambas/screens/main/admin/ScreenExport.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'constants/app_routes.dart';
import 'constants/app_settings.dart';

import 'package:timezone/data/latest_all.dart' as tz;

import 'screens/main/admin/ScreenAddUser.dart';
import 'screens/main/admin/ScreenSettings.dart';
import 'screens/main/admin/ScreenUpdateUser.dart';
import 'screens/main/admin/ScreenUserManagement.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await EasyLocalization.ensureInitialized();
  tz.initializeTimeZones();

  initializeDateFormatting();
  await FastCachedImageConfig.init();

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  //note: only available for mobile platforms. web not supported
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent, // status bar color
  ));

  // Logging
  Fimber.plantTree(DebugTree());

  // App Version
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  // Repositories
  PreferenceRepository preferenceRepository = PreferenceRepository();
  HardCodeRepository hardCodeRepository = HardCodeRepository();
  RemoteRepository remoteRepository = RemoteRepository(preferenceRepository: preferenceRepository, navigator: GlobalKey<NavigatorState>());
  DatabaseRepository databaseRepository = DatabaseRepository();

  //hide status bar and navigation bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProviderAccount>(
          create: (context) => ProviderAccount(
            remoteRepository: remoteRepository,
            preferenceRepository: preferenceRepository,
            databaseRepository: databaseRepository,
          ),
        ),
        RepositoryProvider<ProviderSelections>(
            create: (context) =>
                ProviderSelections(hardCodeRepository: hardCodeRepository)),
      ],
      child: AppRoutes(
        child: App(),
      ),
    ),
  );

  // Logging
  Fimber.plantTree(DebugTree.elapsed());
}

class PayoBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    Fimber.e(stacktrace.toString());
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    Fimber.d(transition.toString());
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
  }
}

class App extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    Bloc.observer = PayoBlocObserver();

    ProviderAccount providerAccount = RepositoryProvider.of<ProviderAccount>(context);

    _initOrientation();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: MaterialApp(
        home: const ScreenSplash(),
        initialRoute: AppRoutes.of(context).splashScreen,
        debugShowCheckedModeBanner: AppSettings.isDebug,
        navigatorKey: navigatorKey,
        navigatorObservers: [NavigatorObserverWithOrientation()],
        routes: {
          AppRoutes.of(context).splashScreen: (context) => const ScreenSplash(),
          AppRoutes.of(context).loginScreen: (context) => const ScreenLogin(),
          AppRoutes.of(context).mainScreen: (context) => const ScreenMain(),
          AppRoutes.of(context).betPageScreen: (context) => const ScreenBet(),
          AppRoutes.of(context).amountPageScreen: (context) => const ScreenAmount(),
          AppRoutes.of(context).checkoutScreen: (context) => const ScreenCheckout(),
          AppRoutes.of(context).mainAdminScreen: (context) => const ScreenAdmin(),
          AppRoutes.of(context).exportScreen: (context) => const ScreenExport(),
          AppRoutes.of(context).userManagementScreen: (context) => const ScreenUserManagement(),
          AppRoutes.of(context).createUserScreen: (context) => const ScreenCreateUser(),
          AppRoutes.of(context).updateUserScreen: (context) => const ScreenUpdateUser(),
          AppRoutes.of(context).generalSettingsScreen: (context) => const ScreenSettings(),
          AppRoutes.of(context).reprintScreen: (context) => const ScreenReprint(),
        },
      ),
    );
  }

  void _initOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  LifecycleEventHandler({
    required this.resumeCallBack,
    required this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await suspendingCallBack();
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }
}

RouteSettings rotationSettings(
    RouteSettings settings, ScreenOrientation rotation) {
  return RouteSettings(name: settings.name, arguments: rotation);
}

class NavigatorObserverWithOrientation extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.arguments is ScreenOrientation) {
      _setOrientation(route.settings.arguments as ScreenOrientation);
    } else {
      // Portrait-only is the default option
      _setOrientation(ScreenOrientation.portraitOnly);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute?.settings.arguments is ScreenOrientation) {
      _setOrientation(previousRoute!.settings.arguments as ScreenOrientation);
    } else {
      // Portrait-only is the default option
      _setOrientation(ScreenOrientation.portraitOnly);
    }
  }
}

enum ScreenOrientation {
  portraitOnly,
  landscapeOnly,
  rotating,
}

void _setOrientation(ScreenOrientation orientation) {
  List<DeviceOrientation> orientations;
  switch (orientation) {
    case ScreenOrientation.portraitOnly:
      orientations = [
        DeviceOrientation.portraitUp,
      ];
      break;
    case ScreenOrientation.landscapeOnly:
      orientations = [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
      break;
    case ScreenOrientation.rotating:
      orientations = [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
      break;
  }
  SystemChrome.setPreferredOrientations(orientations);
}
