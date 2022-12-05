import 'package:flutter/material.dart';

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
              : IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Color.fromRGBO(206, 13, 13, 1))),
        );
}
