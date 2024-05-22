import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SymptomsList extends StatelessWidget {
  List<String> symptoms;
  SymptomsList({super.key, required this.symptoms});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 4,
            runSpacing: 4,
            direction: Axis.horizontal,
            children: [
              for (int index = 0; index < symptoms.length; index++)
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.blue200, width: 1),
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.blue50),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    symptoms[index],
                    style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500),
                  ),
                ),
            ]));
  }
}
