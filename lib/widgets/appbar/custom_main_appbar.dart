import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kambas/constants/app_colors.dart';

import '../../constants/app_icons.dart';
import '../../constants/app_strings.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants/app_icons.dart';

class CustomMainAppBar extends StatelessWidget {
  final bool isMobile;
  final VoidCallback? onMenuPressed;

  final double? height;
  final double? width;

  const CustomMainAppBar({
    super.key,
    required this.isMobile,
    this.onMenuPressed,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return (isMobile)
        ? AppBar(
      leadingWidth: 200.0,
      leading: Row(
        children: [
          IconButton(
            onPressed: onMenuPressed ?? () {},
            icon: const Icon(Icons.menu),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person),
        )
      ],
    )

    //todo: update (textfield for bloc etc)
        : Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          //todo: update
          child: TextFormField(
            decoration: InputDecoration(
              hoverColor: Colors.transparent,
              border: InputBorder.none,
              filled: true,
              fillColor: AppColors.scaffoldBGColor,
              hintText: AppStrings.login,
              hintStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: AppStrings.FONT_POPPINS_REGULAR,
                      color: AppColors.TextFieldHint_TextColor),
              // prefixIcon: Align(
              //   widthFactor: 1.0,
              //   heightFactor: 1.0,
              //   child: SvgPicture.asset(
              //     AppIcons.SEARCH_SVG,
              //     height: 16.0,
              //     width: 16.0,
              //   ),
              // ),
            ),
            cursorColor: AppColors.PrimaryColor,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: AppStrings.FONT_POPPINS_REGULAR,
            )
          ),
        ),

        // SvgPicture.asset(
        //   AppIcons.CALCULATOR_SVG,
        //   height: 16.0,
        //   width: 12.0,
        // ),
        const SizedBox(width: 10.0,),
        SizedBox(
          width: 18,
          child: Stack(
            children: [
              // SvgPicture.asset(
              //   AppIcons.NOTIFICATION_SVG,
              //   height: 16.0,
              //   width: 14.0,
              // ),
              const Positioned(
                  right: 0.1,
                  top: 0.1,
                  child: Icon(Icons.brightness_1, color: Colors.red, size: 5.0,)
              ),
            ],
          ),
        ),
        const SizedBox(width: 10.0,),
        const CircleAvatar(
          radius: 10.0,
          backgroundImage: NetworkImage('https://images.pexels.com/photos/2820884/pexels-photo-2820884.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
        ),
      ],
    );
  }
}
