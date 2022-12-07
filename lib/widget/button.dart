import 'dart:ffi';

import 'package:flutter/material.dart';

class PrimaryButton extends ElevatedButton {
  PrimaryButton(String text, String page, TextStyle textstyle, {super.key})
      : super(
          onPressed: () {},
          child: Text(text, style: textstyle),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(73, 101, 242, 1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
}
