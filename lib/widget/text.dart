import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class TextGradiant {
  final String text;
  final bool isGrandiant;

  TextGradiant(this.text, {this.isGrandiant = false});
}

class TextWhithGradiant extends Flex {
  TextWhithGradiant(List<TextGradiant> txt, TextStyle style, {super.key})
      : super(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var i = 0; i < txt.length; i++) ...[
              if (txt[i].isGrandiant == false) ...[
                Text(
                  txt[i].text,
                  style: style,
                )
              ] else ...[
                const SizedBox(
                  width: 5,
                ),
                GradientText(
                  txt[i].text,
                  style: style,
                  colors: const [
                    AppColors.blue500,
                    AppColors.pink500,
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ],
          ],
        );
}
