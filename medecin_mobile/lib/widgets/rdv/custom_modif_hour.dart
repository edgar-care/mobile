import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';


class CustomModifHour extends StatefulWidget {
  int selected;
  final int id;
  CustomModifHour({super.key, required this.selected, required this.id});

  @override
  _CustomModifHourState createState() => _CustomModifHourState();
}

class _CustomModifHourState extends State<CustomModifHour> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context){
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      color: widget.selected == widget.id ? AppColors.blue700 : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(
          color: AppColors.blue200,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => {widget.selected = widget.id},
        child:
          Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            "10h00 / 10h30",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: widget.selected == widget.id ? AppColors.white : AppColors.blue800,
              fontWeight: FontWeight.w600
            ),
          ),
        )
      ),
    );
  }
}