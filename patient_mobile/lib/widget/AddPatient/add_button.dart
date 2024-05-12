import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';

class AddButton extends StatefulWidget {
  final Function()? onTap;
  final String label;
  final Color color;

  const AddButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.color,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        side: BorderSide(
            width: 2.0,
            color: widget.color == AppColors.blue700
                ? AppColors.blue700
                : AppColors.blue500),
        backgroundColor: widget.color,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
      child: Text(widget.label,
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: widget.color == AppColors.blue700
                  ? AppColors.white
                  : AppColors.blue700)),
    );
  }
}

class AddButtonSpe extends StatefulWidget {
  final Function()? onTap;
  final String label;
  final Color color;
  final Color background;

  const AddButtonSpe(
      {super.key,
      required this.onTap,
      required this.label,
      required this.color,
      required this.background});

  @override
  // ignore: library_private_types_in_public_api
  _AddButtonSpeState createState() => _AddButtonSpeState();
}

class _AddButtonSpeState extends State<AddButtonSpe> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: widget.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.background == AppColors.blue700
                ? AppColors.blue700
                : AppColors.blue500,
            width: 2.0,
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}

class AddButtonSpeHealth extends StatefulWidget {
  final Function()? onTap;
  final String label;
  final Color color;
  final Color background;

  const AddButtonSpeHealth(
      {super.key,
      required this.onTap,
      required this.label,
      required this.color,
      required this.background});

  @override
  // ignore: library_private_types_in_public_api
  _AddButtonSpeHealthState createState() => _AddButtonSpeHealthState();
}

class _AddButtonSpeHealthState extends State<AddButtonSpeHealth> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: widget.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.background == AppColors.blue700
                ? AppColors.blue700
                : AppColors.blue200,
            width: 2.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}
