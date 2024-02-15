import 'package:flutter/material.dart';

class PatientListCard extends StatelessWidget {
  Map<String, dynamic> patientData;
  Function onTap;
  PatientListCard({required this.patientData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(

      ),
    );
  }
}