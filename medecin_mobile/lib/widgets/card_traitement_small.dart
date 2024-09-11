import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class CardTraitementSmall extends StatefulWidget {
  final String name;
  bool isEnCours;
  final Function() onTap;
  bool withDelete;
  CardTraitementSmall(
      {super.key,
      required this.name,
      required this.isEnCours,
      required this.onTap,
      this.withDelete = true});

  @override
  State<CardTraitementSmall> createState() => _CardTraitementSmallState();
}

class _CardTraitementSmallState extends State<CardTraitementSmall> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.blue50,
        border: Border.all(
          color: AppColors.blue200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/utils/Union.svg',
            width: 16,
            height: 16,
            // ignore: deprecated_member_use
            color: widget.isEnCours ? AppColors.blue700 : AppColors.grey300,
          ),
          const SizedBox(width: 8),
          Text(
            widget.name,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.withDelete) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: widget.onTap,
              child: const Icon(
                BootstrapIcons.x,
                color: AppColors.black,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
