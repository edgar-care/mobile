import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';

class PlainButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const PlainButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.buttonBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

class PlainBorderButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const PlainBorderButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.buttonBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(width: 2, color: AppColors.blue400),
        ),
      ),
      onPressed: onPressed,
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

class GreenPlainButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const GreenPlainButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.green500,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(width: 2, color: AppColors.green200),
        ),
      ),
      onPressed: onPressed,
      child: Text(text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

class GreenPlainButtonWithIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function() onPressed;
  const GreenPlainButtonWithIcon(
      {super.key, required this.text, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onLongPress: () {
        ElevatedButton.styleFrom(
          backgroundColor: AppColors.grey700,
        );
      },
      style: ElevatedButton.styleFrom(
        maximumSize: const Size(140, 50),
        elevation: 0,
        backgroundColor: AppColors.green500,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(width: 2, color: AppColors.green200),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children : [
          Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, 
                fontWeight: FontWeight.bold
            )
          ),
          Icon(icon, color: Colors.white, size: 18)
        ]
      ),
    );
  }
}