import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PatientListCard extends StatelessWidget {
  Map<String, dynamic> patientData;
  Function onTap;
  PatientListCard({super.key, required this.patientData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.blue100,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            children: [
              Container(
                height: 20,
                width: 3,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(patientData['Prenom'] + ' ' + patientData['Nom'] ?? 'Nom Prénom', style: const TextStyle(fontSize: 16, fontFamily: 'Poppins', color: AppColors.black), overflow: TextOverflow.ellipsis,),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.black,
              ),
            ]
            )
        )
      ),
    );
  }
}