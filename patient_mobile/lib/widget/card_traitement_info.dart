import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class CardTraitementSimplify extends StatefulWidget {
  final Map<String, dynamic> traitement;
  final List<String> medNames;
  const CardTraitementSimplify(
      {super.key, required this.traitement, required this.medNames});

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
              color: widget.traitement['antedisease']['still_relevant'] as bool
                  ? AppColors.blue200
                  : AppColors.grey200,
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            child: IntrinsicWidth(
              child: SvgPicture.asset(
                'assets/images/utils/Subtract.svg',
                // ignore: deprecated_member_use
                color:
                    widget.traitement['antedisease']['still_relevant'] as bool
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
                widget.traitement['antedisease']['name'] as String,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (widget.traitement['treatments'] != null) ...[
                    for (var i = 0;
                        i < (widget.traitement['treatments'] as List).length &&
                            i < 2;
                        i++) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: const BoxDecoration(
                          color: AppColors.blue100,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Text(
                          widget.medNames[i],
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                    if (widget.traitement['treatments'].length > 2) ...[
                      const Icon(
                        BootstrapIcons.plus,
                        color: AppColors.black,
                        size: 16,
                      ),
                    ]
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
