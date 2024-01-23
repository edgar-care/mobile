import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';

class CustomCard extends Card {
  CustomCard(
      {super.key,
      required bool isSelected,
      required IconData? icon,
      required String title,
      required Function()? onTap})
      : super(
          elevation: 0,
          margin: const EdgeInsets.all(0),
          color: isSelected ? AppColors.blue900 : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isSelected ? Colors.white : AppColors.blue900,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: isSelected ? Colors.white : AppColors.blue950,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        );
}
