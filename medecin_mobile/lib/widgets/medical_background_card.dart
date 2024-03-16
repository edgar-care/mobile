import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

class MedicalBackground extends StatelessWidget {
  final bool isActual;
  const MedicalBackground({super.key, required this.isActual});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //open the medical background
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blue50,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(BootstrapIcons.capsule_pill, color: isActual ? AppColors.blue700 : AppColors.grey300, size: 24,),
            const SizedBox(width: 8),
            const Text(
              'Antecedent',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                //delete the medical background
              },
              child: const Icon(BootstrapIcons.x_lg, color: AppColors.black, size: 24,)
            ),
          ],
        ),
      ),
    );
  }
}