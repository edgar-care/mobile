import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

class MedsCard extends StatefulWidget {
  const MedsCard({super.key});

  @override
  State<MedsCard> createState() => _MedsCardState();
}

class _MedsCardState extends State<MedsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blue200, width: 2),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
    );
  }
}