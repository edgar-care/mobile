import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProgressBarDisease extends StatelessWidget {
  int value;
  String disease;
  ProgressBarDisease({super.key, required this.value, required this.disease});
  Color barColor = AppColors.green400;
  Color backgroundColor = AppColors.orange400;
  Color textColor = AppColors.red400;
  @override
  Widget build(BuildContext context) {
    switch (value) {
      case < 30:
        barColor = AppColors.red700;
        backgroundColor = AppColors.red200;
        textColor = AppColors.red600;
        break;
      case < 60:
        barColor = AppColors.orange600;
        backgroundColor = AppColors.orange200;
        textColor = AppColors.orange600;
        break;
      default:
        barColor = AppColors.green700;
        backgroundColor = AppColors.green200;
        textColor = AppColors.green600;
    }

    return Row(
      children: [
        ProgressBar(
          max: 100,
          current: value.toDouble(),
          color: barColor,
          backgroundColor: backgroundColor,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.08,
          child: Text(
            '$value %',
            style: TextStyle(
                color: textColor,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
            width: MediaQuery.of(context).size.height * 0.155,
            child: Text(
              disease,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins'),
              overflow: TextOverflow.ellipsis,
            ))
      ],
    );
  }
}

class ProgressBar extends StatelessWidget {
 final double max;
 final double current;
 final Color color;
 final Color backgroundColor;

 const ProgressBar(
  {super.key,
  required this.max,
  required this.current,
  required this.color,
  required this.backgroundColor});
  @override
  Widget build(BuildContext context) {
  return LayoutBuilder(
  builder: (_, boxConstraints) {
    var percent = (current / max) * MediaQuery.of(context).size.width * 0.15;
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.15,
          height: 7,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: percent,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(35),
          ),
        ),
      ],
    );
  },
);
}
}