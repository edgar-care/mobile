import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomNavPatientCard extends StatelessWidget {
  Function setPages;
  String text;
  IconData? icon;
  int pageTo;
  CustomNavPatientCard(
      {super.key,
      required this.setPages,
      required this.text,
      required this.icon,
      required this.pageTo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.blue200, width: 2),
      ),
      child: InkWell(
        onTap: () {
          setPages(pageTo);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(children: [
            Icon(
              icon,
              color: AppColors.blue950,
              size: 16,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              text,
              style: const TextStyle(
                  color: AppColors.blue950,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Icon(
              BootstrapIcons.chevron_right,
              color: AppColors.black,
              size: 12,
            )
          ]),
        ),
      ),
    );
  }
}
