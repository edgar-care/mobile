import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MedicalBackground extends StatelessWidget {
  const MedicalBackground({super.key, required this.isActual});

  final bool isActual;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blue50,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.blue200, width: 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: InkWell(
          onTap: () {
            Logger().d('oui');
          },
          child: Row(
            children: [
              Icon(BootstrapIcons.capsule_pill, color: isActual ? AppColors.blue700 : AppColors.grey300,),
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
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Logger().d('delete');
                },
                child: const Icon(BootstrapIcons.x, color: AppColors.black, size: 24,)
              ),
            ],
          ),
        ),
      ),
    );
  }
}