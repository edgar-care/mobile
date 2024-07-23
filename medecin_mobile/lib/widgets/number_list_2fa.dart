import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

class FieldNumberList2FA extends StatefulWidget {
  const FieldNumberList2FA({super.key});

  @override
  State<FieldNumberList2FA> createState() => _FieldNumberList2FAState();
}

class _FieldNumberList2FAState extends State<FieldNumberList2FA> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        NumberField(),
        SizedBox(width: 8),
        NumberField(),
        SizedBox(width: 8),
        NumberField(),
        SizedBox(width: 8),
        NumberField(),
        SizedBox(width: 8),
        NumberField(),
        SizedBox(width: 8),
        NumberField(),
      ],
    );
  }
}

class NumberField extends StatefulWidget {
  const NumberField({super.key});

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.blue300,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const TextField(
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
      ),
    );
  }
}