// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import '../styles/colors.dart';

enum Variante {
  primary,
  secondary,
  tertiary,
  primaryBordered,
  validate,
  delete,
}

enum SizeButton {
  sm,
  md,
  lg,
  xl,
  xxl,
  xxxl,
}

// ignore: must_be_immutable
class Buttons extends StatelessWidget {
  Variante variant;
  SizeButton size;
  Text msg;
  Function? onPressed;
  Buttons({super.key, required this.variant, required this.size, required this.msg , this.onPressed});
  

  @override
  Widget build(BuildContext context) {

    Color backgroundcolor;
    BorderSide borderSide;
    TextStyle textStyle;
    Color? borderColor;
    double radius;

    switch (size) {
      case SizeButton.sm:
        textStyle = TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: variant == Variante.secondary ? const Color(0xFF2E4C9A) : Colors.white,
          fontFamily: 'Poppins',
        );
        radius = 8;
        break;
      case SizeButton.md:
        textStyle = TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: variant == Variante.secondary ? const Color(0xFF2E4C9A) : Colors.white,
          fontFamily: 'Poppins',
        );
        radius = 10;
        break;
      case SizeButton.lg:
        textStyle = TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: variant == Variante.secondary ? const Color(0xFF2E4C9A) : Colors.white,
          fontFamily: 'Poppins',
        );
        radius = 12;
        break;
      case SizeButton.xl:
        textStyle = TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: variant == Variante.secondary ? const Color(0xFF2E4C9A) : Colors.white,
          fontFamily: 'Poppins',
        );
        radius = 12;
        break;
      case SizeButton.xxl:
        textStyle = TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: variant == Variante.secondary ? const Color(0xFF2E4C9A) : Colors.white,
          fontFamily: 'Poppins',
        );
        radius = 16;
        break;
      case SizeButton.xxxl:
        textStyle = TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: variant == Variante.secondary ? const Color(0xFF2E4C9A) : Colors.white,
          fontFamily: 'Poppins',
        );
        radius = 16;
        break;
      default:
        textStyle = const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color:AppColors.blue300,
          fontFamily: 'Poppins',
        );
        radius = 8;
        break;
    }

    switch (variant) {
      case Variante.primary:
        backgroundcolor = AppColors.blue700;
        borderSide = const BorderSide(
          color: Colors.transparent,
          style: BorderStyle.solid,
          width: 0,
        );
        break;
      case Variante.secondary:
        backgroundcolor = Colors.white;
        borderSide = const BorderSide(
          color: AppColors.blue200,
          style: BorderStyle.solid,
          width: 2,
        );
        break;
      case Variante.tertiary:
        backgroundcolor = AppColors.grey500;
        borderSide = const BorderSide(
          color: AppColors.grey400,
          style: BorderStyle.solid,
          width: 2,
        );
        break;
      case Variante.primaryBordered:
        backgroundcolor = AppColors.blue700;
        borderSide = const BorderSide(
          color: AppColors.blue700,
          style: BorderStyle.solid,
          width: 2,
        );
        break;
      case Variante.validate:
        backgroundcolor = AppColors.green600;
        borderSide = const BorderSide(
          color: Colors.transparent,
          style: BorderStyle.solid,
          width: 0,
        );
        break;
      case Variante.delete:
        backgroundcolor = AppColors.red600;
        borderSide = const BorderSide(
          color: Colors.transparent,
          style: BorderStyle.solid,
          width: 0,
        );
        break;
      default:
        backgroundcolor = Colors.grey;
        borderSide = const BorderSide(
          color: Colors.transparent,
          style: BorderStyle.solid,
          width: 0,
        );
        break;
    }

    return GestureDetector(
      onTap: () async {
        onPressed!();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: size == SizeButton.sm || size == SizeButton.lg || size == SizeButton.md ? 6 : 12 , horizontal: size == SizeButton.sm || size == SizeButton.lg || size == SizeButton.md ? 16 : 24),
        decoration: BoxDecoration(
          color: backgroundcolor,
          border: Border.fromBorderSide(borderSide),
          borderRadius: BorderRadius.circular(radius),
        ),
        width: double.infinity,
        child: Center(
          child: Text(
            msg.data.toString(),
            style: textStyle,
          ),
        ),
      ),
    );
  }
}