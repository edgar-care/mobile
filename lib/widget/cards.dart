import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';

class PrimaryCard extends Card {
  PrimaryCard(List<String> text, TextStyle textstyle, {super.key})
      : super(
          margin: const EdgeInsets.all(15),
          child: SizedBox(
              height: 100,
              width: 450,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < text.length; i++)
                    Text(
                      text[i],
                      style: textstyle,
                    ),
                ],
              ))),
          color: AppColors.purple100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        );
}
