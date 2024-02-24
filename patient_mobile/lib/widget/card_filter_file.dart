import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';

class FilterCard extends StatefulWidget {
  final Widget header;
  final Function onTap;
  final String text;
  const FilterCard({super.key, required this.header, required this.onTap, required this.text});

  @override
  State<FilterCard> createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.blue700, width: 1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal:12),
      child: Row(
        children: [
          widget.header,
          const SizedBox(width: 8),
          Text(widget.text, style: const TextStyle(fontSize: 12, color: AppColors.blue700, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => widget.onTap(),
            child: const Icon(Icons.close, color: AppColors.blue700, size: 20),
          )
        ],
      ),
    );
  }
}