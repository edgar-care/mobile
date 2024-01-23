import 'package:flutter/material.dart';
import 'package:edgar_pro/styles/colors.dart';

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
    return InkWell(
          onTap: widget.onTap,
          child:Container(
      decoration: BoxDecoration(
        color: widget.color,
        border: Border.all(
          color: AppColors.blue700,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Text(widget.label,
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: widget.color == AppColors.blue700
                  ? AppColors.white
                  : AppColors.grey400)),
    )));
  }
}
