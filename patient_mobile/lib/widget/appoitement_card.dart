import 'package:edgar/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppoitementCard extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String doctor;
  final Function onTap;
  const AppoitementCard(
      {super.key,
      required this.startDate,
      required this.endDate,
      required this.doctor,
      required this.onTap});

  @override
  State<AppoitementCard> createState() => _AppoitementCardState();
}

class _AppoitementCardState extends State<AppoitementCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap;
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
            decoration: const BoxDecoration(
              color: AppColors.green500,
              borderRadius: BorderRadius.all(Radius.circular(4)),
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
                    "${widget.startDate.day}/${widget.startDate.month}/${widget.startDate.year} - ${widget.startDate.hour.toString().padLeft(2, '0')}h${widget.startDate.minute.toString().padLeft(2, '0')}",
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
