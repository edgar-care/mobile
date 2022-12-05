import 'dart:ffi';

import 'package:flutter/material.dart';

class PrimaryButton extends ElevatedButton {
  PrimaryButton(String text, String page, TextStyle textstyle, {super.key})
      : super(
          onPressed: () {},
          child: Text(text, style: textstyle),
          style: ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(73, 101, 242, 1),
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
}
