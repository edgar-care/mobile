import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../styles/colors.dart';

class AppBarCustom extends AppBar {
  AppBarCustom(String title, {super.key})
      : super(
          title: Image.asset(
            'assets/images/logo/logo-full-color.png',
            height: 40,
          ),
          centerTitle: true,
          leading: title == 'home'
              ? null
              : const Center(
                  child: FaIcon(FontAwesomeIcons.circleArrowLeft,
                      color: AppColors.blue700, size: 24)),
        );
}
