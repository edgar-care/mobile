import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatefulWidget {
  const DoctorCard({super.key});

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.blue200,
          width: 2,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child:
          Wrap(
            direction: Axis.horizontal,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("Docteur XX", style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold),),
                Text("10 rue du médecin, 54000 - Nancy", style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600),),
                ],
              ),
            ],
          ),
      ),
    );
  }
}