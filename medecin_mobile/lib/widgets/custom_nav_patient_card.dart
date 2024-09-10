import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomNavPatientCard extends StatelessWidget {
  Function setPages;
  String text;
  IconData? icon;
  int pageTo;
  String id;
  Function setId;
  CustomNavPatientCard(
      {super.key,
      required this.setPages,
      required this.text,
      required this.icon,
      required this.pageTo,
      required this.id,
      required this.setId});

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
          setId(id);
          setPages(pageTo);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 10, 8),
          child: Row(children: [
            Icon(
              icon,
              color: AppColors.blue950,
              size: 17,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              text,
              style: const TextStyle(
                  color: AppColors.blue950,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins'),
            ),
            const Spacer(),
            const Icon(
              BootstrapIcons.chevron_right,
              color: AppColors.black,
              size: 16,
            )
          ]),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomCardModal extends StatelessWidget {
  Function onTap;
  String text;
  IconData? icon;
  CustomCardModal(
      {super.key, required this.onTap, required this.text, required this.icon});

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
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 10, 8),
          child: Row(children: [
            Icon(
              icon,
              color: AppColors.blue950,
              size: 17,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              text,
              style: const TextStyle(
                  color: AppColors.blue950,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins'),
            ),
            const Spacer(),
            const Icon(
              BootstrapIcons.chevron_right,
              color: AppColors.black,
              size: 16,
            )
          ]),
        ),
      ),
    );
  }
}
