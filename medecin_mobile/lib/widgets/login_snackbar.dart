import 'package:flutter/material.dart';
import 'package:medecin_mobile/styles/colors.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class SuccessLoginSnackBar extends SnackBar {
  final String message;
  SuccessLoginSnackBar({super.key, required this.message, required BuildContext context}) : super(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      backgroundColor: AppColors.green400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(64),
      ),
      content: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: const BoxDecoration(
              color: AppColors.green600,
              shape: BoxShape.circle,
            ),
            child: const Icon(BootstrapIcons.check, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Text(message, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
          ]),
  );
}

class ErrorLoginSnackBar extends SnackBar {
  final String message;
  ErrorLoginSnackBar({super.key, required this.message, required BuildContext context}) : super (
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 2),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    backgroundColor: AppColors.red400,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: AppColors.red500, width: 2),
      borderRadius: BorderRadius.circular(64),
    ),
    content: Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: const BoxDecoration(
            color: AppColors.red600,
            shape: BoxShape.circle,
          ),
          child: const Icon(BootstrapIcons.exclamation_triangle, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Une erreur est survenue", style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
            Text(message, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12)),
      ]),
      ]),
  );
}