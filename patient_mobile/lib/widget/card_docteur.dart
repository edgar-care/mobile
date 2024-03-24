import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/styles/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardDoctor extends StatefulWidget {
  bool selected;
  final String name;
  final String address;
  CardDoctor(
      {super.key,
      required this.name,
      required this.address,
      required this.selected});

  @override
  State<CardDoctor> createState() => _CardDoctorState();
}

class _CardDoctorState extends State<CardDoctor> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.selected = !widget.selected;
        });
      },
      child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.selected ? AppColors.blue700 : AppColors.white,
            border: Border.all(
              color: widget.selected ? AppColors.blue700 : AppColors.blue200,
              width: 2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      color:
                          widget.selected ? AppColors.white : AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.address,
                    style: TextStyle(
                      color:
                          widget.selected ? AppColors.white : AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.selected = !widget.selected;
                  });
                },
                child: Icon(
                  BootstrapIcons.chevron_right,
                  color: widget.selected ? AppColors.white : AppColors.black,
                ),
              )
            ],
          )),
    );
  }
}
