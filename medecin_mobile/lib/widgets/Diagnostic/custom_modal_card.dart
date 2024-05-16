import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomModalCard extends StatelessWidget {
  Function ontap;
  String text;
  IconData? icon;
  CustomModalCard({
    super.key,
    required this.ontap,
    required this.text,
    required this.icon,
  });

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
          ontap();
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
              size: 15,
            )
          ]),
        ),
      ),
    );
  }
}
