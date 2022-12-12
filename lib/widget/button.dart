import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';

class PrimaryButton extends ElevatedButton {
  PrimaryButton(
      String text, String page, TextStyle textstyle, BuildContext context,
      {super.key})
      : super(
          onPressed: () {
            Navigator.pushNamed(context, '/$page');
          },
          child: Text(text, style: textstyle),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.blue400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
}

class SecondaryButton extends ElevatedButton {
  SecondaryButton(
      String text, String page, TextStyle textstyle, BuildContext context,
      {super.key})
      : super(
          onPressed: () {
            Navigator.pushNamed(context, '/$page');
          },
          child: Text(text, style: textstyle),
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.purple600,
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: AppColors.blue200, width: 2),
            ),
          ),
        );
}
