import 'package:edgar/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum AppointementStatus { done, waiting }

class AppoitementCard extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String doctor;
  final Function onTap;
  final AppointementStatus status;
  const AppoitementCard(
      {super.key,
      required this.startDate,
      required this.endDate,
      required this.doctor,
      required this.onTap, required this.status});

  @override
  State<AppoitementCard> createState() => _AppoitementCardState();
}

class _AppoitementCardState extends State<AppoitementCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 74,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.blue200, width: 2),
        ),
        child: Row(children: [
          Container(
            width: 4,
            decoration:  BoxDecoration(
              color: widget.status == AppointementStatus.done ? AppColors.blue200 : AppColors.green500,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.doctor,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins"),
              ),
              Row(
                children: [
                  Text(
                    "${widget.startDate.day.toString().padLeft(2, '0')}/${widget.startDate.month.toString().padLeft(2, '0')}/${widget.startDate.year} - ${widget.startDate.hour.toString().padLeft(2, '0')}h${widget.startDate.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins"),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                      "assets/images/utils/arrow_appointement.svg"),
                  const SizedBox(width: 4),
                  Text(
                    "${widget.endDate.hour.toString().padLeft(2, '0')}h${widget.endDate.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins"),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          SvgPicture.asset("assets/images/utils/arrowRightIphone.svg"),
        ]),
      ),
    );
  }
}
