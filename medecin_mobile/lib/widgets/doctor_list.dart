import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/doctor_card.dart';
import 'package:flutter/material.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({super.key});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.separated(
          itemCount: 32,
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(
            height: 8,
          ),
          itemBuilder: (context, index) {
            return const DoctorCard();
        }
      )
    );
  }
}