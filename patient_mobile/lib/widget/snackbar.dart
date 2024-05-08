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
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.red700,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Column(
                  children: [
                    Icon(BootstrapIcons.exclamation_triangle,
                        color: Colors.white, size: 28),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
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
                      fontSize: 10,
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
                child: const Icon(BootstrapIcons.check,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
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
                mainAxisSize: MainAxisSize.min,
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

class SuccessLoginSnackBar extends SnackBar {
  final String message;
  SuccessLoginSnackBar(
      {super.key, required this.message, required BuildContext context})
      : super(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          backgroundColor: AppColors.green400,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.green500, width: 2),
            borderRadius: BorderRadius.circular(64),
          ),
          content: Row(children: [
            Container(
              height: 48,
              width: 48,
              decoration: const BoxDecoration(
                color: AppColors.green600,
                shape: BoxShape.circle,
              ),
              child: const Icon(BootstrapIcons.check,
                  color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Text(message,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ]),
        );
}

class ErrorLoginSnackBar extends SnackBar {
  final String message;
  ErrorLoginSnackBar(
      {super.key, required this.message, required BuildContext context})
      : super(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          backgroundColor: AppColors.red400,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.red500, width: 2),
            borderRadius: BorderRadius.circular(64),
          ),
          content: Row(children: [
            Container(
              height: 48,
              width: 48,
              decoration: const BoxDecoration(
                color: AppColors.red600,
                shape: BoxShape.circle,
              ),
              child: const Icon(BootstrapIcons.exclamation_triangle,
                  color: Colors.white),
            ),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Une erreur est survenue",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(message,
                    style:
                        const TextStyle(fontFamily: 'Poppins', fontSize: 12)),
              ),
            ]),
          ]),
        );
}

class InfoLoginSnackBar extends SnackBar {
  final String message;
  InfoLoginSnackBar(
      {super.key, required this.message, required BuildContext context})
      : super(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(minutes: 1),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          backgroundColor: AppColors.blue600,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.blue700, width: 2),
            borderRadius: BorderRadius.circular(64),
          ),
          content: Row(children: [
            const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
                backgroundColor: AppColors.green400),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(message,
                  style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold)),
            ]),
          ]),
        );
}
