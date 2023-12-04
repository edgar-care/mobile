import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';




class ErrorSnackBar extends SnackBar {
  ErrorSnackBar({
    super.key,
    required String message,
    Duration? duration,
    required BuildContext context,
  }) : super(
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          backgroundColor: Colors.white,
          elevation: 10,
          width: MediaQuery.of(context).size.width * 0.9,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.red700,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Column(
                  children: [
                    Icon(BootstrapIcons.exclamation_triangle, color: Colors.white, size: 28),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(width: 8 ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min  ,
                children: [
                  const Text(
                    'Une erreur est survenue',
                    style: TextStyle(
                      color: AppColors.grey950,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    message,
                    softWrap: true,
                    style: const TextStyle(
                      color: AppColors.grey950,
                      fontSize: 10  ,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              )
            ],
          ),
          duration: duration ?? const Duration(seconds: 5),
        );
}

class ValidateSnackBar extends SnackBar {
  ValidateSnackBar({
    super.key,
    required String message,
    Duration? duration,
    required BuildContext context,
  }) : super(
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          backgroundColor: Colors.white,
          elevation: 10,
          width: MediaQuery.of(context).size.width * 0.9,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.green400,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const
                    Icon(BootstrapIcons.check, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 8 ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min  ,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      color: AppColors.grey950,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                ],
              )
            ],
          ),
          duration: duration ?? const Duration(seconds: 5),
        );
}

class WaittingSnackBar extends SnackBar {
  WaittingSnackBar({
    super.key,
    required String message,
    Duration? duration,
    required BuildContext context,
  }) : super(
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          backgroundColor: Colors.white,
          elevation: 10,
          width: MediaQuery.of(context).size.width * 0.9,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          content: Row(
            children: [
              const SizedBox(width: 8, height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.green400),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min  ,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      color: AppColors.grey950,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                ],
              )
            ],
          ),
          duration: duration ?? const Duration(seconds: 5),
        );
}

