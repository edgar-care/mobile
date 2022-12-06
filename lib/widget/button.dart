import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';

class PrimaryButton extends ElevatedButton {
  PrimaryButton(String text, String page, TextStyle textstyle, {super.key})
      : super(
          onPressed: () {},
          child: Text(text, style: textstyle),
          style: ElevatedButton.styleFrom(
            primary: AppColors.blue300,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
}

class SecondaryButton extends ElevatedButton {
  SecondaryButton(String text, String page, TextStyle textstyle, {super.key})
      : super(
          onPressed: () {},
          child: Text(text, style: textstyle),
          style: ElevatedButton.styleFrom(
            primary: AppColors.white,
            onPrimary: AppColors.purple600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
}
