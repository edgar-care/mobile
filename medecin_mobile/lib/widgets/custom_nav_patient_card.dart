import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

class CustomNavPatientCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function ontap;
  const CustomNavPatientCard({super.key, required this.text, required this.icon, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue200, width: 2),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child:InkWell( 
        onTap: (){ontap;},
        child:
          Row(
          children:[
            Icon(icon, color: AppColors.blue950, size: 16),
            const SizedBox(width: 16),
            Text(text, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600),),
            const Spacer(),
            const Icon(BootstrapIcons.chevron_right, color: AppColors.blue950, size: 12),
          ]
        ),
      ),
    );
  }
}