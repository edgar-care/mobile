import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class CardTraitementSimplify extends StatefulWidget {
  final Map<String, Object> traitement;
  const CardTraitementSimplify({super.key, required this.traitement});

  @override
  State<CardTraitementSimplify> createState() => _CardTraitementSimplifyState();
}

class _CardTraitementSimplifyState extends State<CardTraitementSimplify> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: AppColors.blue200, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.traitement['still_relevant'] as bool
                  ? AppColors.blue200
                  : AppColors.grey200,
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            child: IntrinsicWidth(
              child: SvgPicture.asset(
                'assets/images/utils/Subtract.svg',
                // ignore: deprecated_member_use
                color: widget.traitement['still_relevant'] as bool
                    ? AppColors.blue700
                    : AppColors.grey700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.traitement['name'] as String,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  for (var i = 0;
                      i < (widget.traitement['medicines'] as List).length &&
                          i < 3;
                      i++) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: const BoxDecoration(
                        color: AppColors.blue100,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        '${widget.traitement['name']}',
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    if (i == 2 &&
                        (widget.traitement['medicines'] as List).length >
                            3) ...[
                      const Icon(
                        BootstrapIcons.plus,
                        color: AppColors.black,
                        size: 16,
                      ),
                    ],
                  ],
                ],
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            BootstrapIcons.chevron_right,
            color: AppColors.black,
            size: 16,
          ),
        ],
      ),
    );
  }
}
