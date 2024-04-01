import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


// ignore: must_be_immutable
class CustomModifHour extends StatefulWidget {
  bool selected;
  final int id;
  final Map<String, dynamic> info;
  final void Function()? onTap;
  CustomModifHour({super.key, required this.selected, required this.id, required this.onTap, required this.info});

  @override
  // ignore: library_private_types_in_public_api
  _CustomModifHourState createState() => _CustomModifHourState();
}

class _CustomModifHourState extends State<CustomModifHour> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context){
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      color: widget.selected ? AppColors.blue700 : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        side: BorderSide(
          color: widget.selected ? AppColors.blue700 : AppColors.blue200,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: widget.onTap,
        child:
          Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            "${DateFormat('Hm', 'fr').format((DateTime.fromMillisecondsSinceEpoch(widget.info['start_date'] * 1000)))} / ${DateFormat('Hm', 'fr').format((DateTime.fromMillisecondsSinceEpoch(widget.info['start_date'] * 1000)).add(const Duration(minutes: 30)))}",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: widget.selected ? AppColors.white : AppColors.blue700,
              fontWeight: FontWeight.w600
            ),
          ),
        )
      ),
    );
  }
}