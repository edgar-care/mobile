import 'package:bootstrap_icons/bootstrap_icons.dart';
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
          color: AppColors.blue200,
          width: 2,
        ),
      ),
      child: InkWell(
          onTap: () {
            onTap();
          },
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
              child: Row(children: [
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
                  child: Text(
                    patientData['Nom'] + ' ' + patientData['Prenom'] ??
                        'Nom Prénom',
                    style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        color: AppColors.black,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                const Icon(
                  BootstrapIcons.chevron_right,
                  color: AppColors.black,
                  size: 15,
                ),
              ]))),
    );
  }
}
