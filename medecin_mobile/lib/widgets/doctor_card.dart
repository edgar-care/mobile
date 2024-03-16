import 'package:bootstrap_icons/bootstrap_icons.dart';
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
      child: const Wrap(
        direction: Axis.horizontal,
        children: [
          Column(
            children: [
            Text("Docteur XX", style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),),
            Text("10 rue du machin, 54000 - Nancy", style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w300),),
            ],
          ),
          Spacer(),
          Icon(BootstrapIcons.arrow_right, size: 12,),
        ],
      ),
    );
  }
}