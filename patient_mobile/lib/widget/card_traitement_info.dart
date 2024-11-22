import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/colors.dart';
import 'package:edgar_app/utils/treatement_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class CardTraitementSimplify extends StatefulWidget {
  final Treatment traitement;
  final String name;
  final Map<String, String> medicaments;
  const CardTraitementSimplify(
      {super.key,
      required this.traitement,
      required this.name,
      required this.medicaments});

  @override
  State<CardTraitementSimplify> createState() => _CardTraitementSimplifyState();
}

class _CardTraitementSimplifyState extends State<CardTraitementSimplify> {
  String getMedicineName(String id) {
    return widget.medicaments.containsKey(id) ? widget.medicaments[id]! : '';
  }

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
              color: (widget.traitement.endDate.millisecondsSinceEpoch == 0 ||
                      widget.traitement.endDate.millisecondsSinceEpoch >
                          DateTime.now().millisecondsSinceEpoch)
                  ? AppColors.blue200
                  : AppColors.grey200,
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            child: IntrinsicWidth(
              child: SvgPicture.asset(
                'assets/images/utils/Subtract.svg',
                // ignore: deprecated_member_use
                color: (widget.traitement.endDate.millisecondsSinceEpoch == 0 ||
                        widget.traitement.endDate.millisecondsSinceEpoch >
                            DateTime.now().millisecondsSinceEpoch ~/ 1000)
                    ? AppColors.blue700
                    : AppColors.grey700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.traitement.endDate.millisecondsSinceEpoch != 0
                      ? "${widget.name} -"
                      : widget.name,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                if (widget.traitement.endDate.millisecondsSinceEpoch != 0) ...[
                  Text(
                    widget.traitement.endDate.millisecondsSinceEpoch.toString(),
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  )
                ],
                const SizedBox(height: 4),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final maxWidth = constraints.maxWidth;
                    double usedWidth = 0.0;
                    bool overflow = false;

                    List<Widget> treatmentWidgets = [];
                    for (var i = 0;
                        i < widget.traitement.medicines.length;
                        i++) {
                      final treatmentWidget = Container(
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: const BoxDecoration(
                          color: AppColors.blue100,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Text(
                          getMedicineName(
                              widget.traitement.medicines[i].medicineId),
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      );

                      final textPainter = TextPainter(
                        text: TextSpan(
                          text: getMedicineName(
                              widget.traitement.medicines[i].medicineId),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      )..layout();

                      usedWidth +=
                          textPainter.width + 20; // Add padding and margin

                      if (usedWidth > maxWidth) {
                        overflow = true;
                        break;
                      }

                      treatmentWidgets.add(treatmentWidget);
                    }

                    if (overflow) {
                      treatmentWidgets.add(
                        const Icon(
                          BootstrapIcons.plus,
                          color: AppColors.black,
                          size: 14,
                        ),
                      );
                    }

                    return Row(
                      children: treatmentWidgets,
                    );
                  },
                ),
              ],
            ),
          ),
          const Icon(
            BootstrapIcons.chevron_right,
            color: AppColors.black,
            size: 18,
            opticalSize: 18,
          ),
        ],
      ),
    );
  }
}
