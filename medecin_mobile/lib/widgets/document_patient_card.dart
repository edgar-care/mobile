import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DocumentPatientCard extends StatelessWidget {
  final String type;
  final String date;
  final String name;
  DocumentPatientCard({super.key, required this.type, required this.date, required this.name});
  Color? color;
  // ignore: non_constant_identifier_names
  Switch(type) {
    switch (type) {
      case 'XRAY':
        color = AppColors.green300;
        break;
      case 'PRESCRIPTION':
        color = AppColors.green500;
        break;
      case 'CERTIFICATE':
        color = AppColors.blue700;
        break;
      default:
        color = AppColors.blue200;
    }
  }

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
          //modal
        },
        child: Row(
          children: [
            Container(
              height: 20,
              width: 10,
              color: color,
            ),
            Column(
              children: [
                Text(name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
                Text("Ajouté le $date", style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600), ),
              ],
            ),
            const Spacer(),
            const Icon(BootstrapIcons.chevron_right, size: 12,)
          ],
        ),
      ),
    );
  }
}