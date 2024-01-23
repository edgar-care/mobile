import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDropdownButton extends StatefulWidget {
  final List<String> list;
  final Function(String?)? onChanged;
  String dropdownvalue;
  CustomDropdownButton({super.key, required this.list, required this.onChanged, required this.dropdownvalue});
  @override
  State<CustomDropdownButton> createState() => _DropdownState();
}

class _DropdownState extends State<CustomDropdownButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue500, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<String>(
      value: widget.dropdownvalue,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 0,
      alignment: Alignment.centerLeft,
      isExpanded: true,
      iconSize: 24,
      underline: Container(
        height: 0,
        color: Colors.transparent,
      ),
      borderRadius: BorderRadius.circular(8),
      style: const TextStyle(color: AppColors.blue700), 
      onChanged: (value) {
        setState(() {
          widget.dropdownvalue = value!;
        });
        widget.onChanged!(value);
      },
      items: widget.list
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: AppColors.blue700), textAlign: TextAlign.left,),
        );
      }).toList(),
    ),
    );
  }
}