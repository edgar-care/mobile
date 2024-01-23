import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ThreeDays extends StatefulWidget {
  final DateTime date;
  const ThreeDays({super.key, required this.date});

  @override
  // ignore: library_private_types_in_public_api
  _ThreeDaysState createState() => _ThreeDaysState();
}

class _ThreeDaysState extends State<ThreeDays> {
  
  @override
  Widget build(BuildContext context) {
    String capitalise(String date){
      return date.split(' ').map((word) => toBeginningOfSentenceCase(word)).join(' ');
    }
    return Padding(
      padding: const EdgeInsets.only(left: 43),
        child : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child:  
              Text(capitalise(DateFormat(MediaQuery.of(context).size.width < 380 ? "yMMMEd" : "yMMMMEEEEd", "fr").format(widget.date)), style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.bold, color: AppColors.blue700,), textAlign: TextAlign.center,),
            ),
          const VerticalDivider(color: AppColors.blue200, thickness: 1,),
          Expanded(child:
              Text(capitalise(DateFormat(MediaQuery.of(context).size.width < 380 ? "yMMMEd" : "yMMMMEEEEd", "fr").format(widget.date.add(const Duration(days: 1)))), style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.bold, color: AppColors.blue700),textAlign: TextAlign.center ), ),
          const VerticalDivider(color: AppColors.blue200, thickness: 1,),
          Expanded(child:
              Text(capitalise(DateFormat(MediaQuery.of(context).size.width < 380 ? "yMMMEd" : "yMMMMEEEEd", "fr").format(widget.date.add(const Duration(days: 2)))), style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.bold, color: AppColors.blue700), textAlign: TextAlign.center),),
        ]),
    );
  }
}