import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kambas/bloc/splash/BlocSplash.dart';
import 'package:kambas/bloc/splash/EventSplash.dart';
import 'package:kambas/bloc/splash/StateSplash.dart';
import 'package:kambas/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_icons.dart';
import '../constants/app_routes.dart';
import '../providers/ProviderAccount.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocProvider(
          create: (context) => BlocSplash(
            providerAccount: RepositoryProvider.of<ProviderAccount>(context),
          ),
          child: const MainLayout(),
        ),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // bool hasNotch = MediaQuery.of(context).viewPadding.top > 0;

    return BlocConsumer<BlocSplash, StateSplash>(
      listener: (context, state) {
        if (state is AuthenticationUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.of(context).loginScreen, (r) => false);
          return;
        }

        if (state is AuthenticationAuthenticated) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.of(context).loginScreen, (r) => false);
          return;
        }
      },
      builder: (context, state) {
        if (state is InitState) {
          context.read<BlocSplash>().add(AppStarted());
        }

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.PrimaryColor,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            AppIcons.LOGO_SVG,
            fit: BoxFit.fill,
            height: 140,
            width: 140,
          ),
        );
      },
    );
  }
}
