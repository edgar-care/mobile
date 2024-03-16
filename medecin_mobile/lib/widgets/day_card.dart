import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DayCard extends StatefulWidget {
  final String day;
  bool isSelected;
  DayCard({super.key, required this.day, required this.isSelected});

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isSelected ? AppColors.blue700 : AppColors.grey300,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () {
          setState(() {
            widget.isSelected = !widget.isSelected;
          });
        },
        child: Center(
          child: Text(
            widget.day,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}