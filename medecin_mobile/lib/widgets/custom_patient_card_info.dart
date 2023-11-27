import 'package:flutter/material.dart';
import 'package:medecin_mobile/styles/colors.dart';


class PatientInfoCard extends SizedBox{
  PatientInfoCard({super.key, required BuildContext context, required Map<String, dynamic> patient, required String champ}) : super (
    width: MediaQuery.of(context).size.width * 0.78,
    child: Wrap(
      alignment: WrapAlignment.start,
      spacing: 8,
      runSpacing: 8,
      direction: Axis.horizontal,
      children: [
        for (var i = 0; i < patient[champ].length; i++)
          Card(
            elevation: 0,
            margin: const EdgeInsets.all(0),
            color: AppColors.blue50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: AppColors.blue200,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                patient[champ][i],
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}