import 'package:edgar_pro/widgets/medical_background_card.dart';
import 'package:flutter/material.dart';


class MedicalBackgroundList extends StatefulWidget {
  const MedicalBackgroundList({super.key});

  @override
  State<MedicalBackgroundList> createState() => _MedicalBackgroundListState();
}

class _MedicalBackgroundListState extends State<MedicalBackgroundList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.80,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 8,
        direction: Axis.horizontal,
        children: [
          for (var i = 0; i < 4; i++)
            const MedicalBackground(isActual: true),
        ]
      ),
    );
  }
}