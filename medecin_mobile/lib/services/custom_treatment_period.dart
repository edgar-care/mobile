// ignore_for_file: must_be_immutable

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/colors.dart';
import 'package:edgar_pro/utils/medicine_type.dart';
import 'package:flutter/material.dart';

class TreatmentPeriodCard extends StatefulWidget {
  final String form;
  Period period;
  Function removePeriod;
  int index;
  TreatmentPeriodCard(
      {super.key,
      required this.form,
      required this.period,
      required this.removePeriod,
      required this.index});

  @override
  State<TreatmentPeriodCard> createState() => _TreatmentPeriodCardState();
}

class _TreatmentPeriodCardState extends State<TreatmentPeriodCard> {
  bool isOpen = false;
  List<String> units = ['Jours', 'Semaines', 'Mois', 'Années'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 26,
              width: 30,
              decoration: const UnderlineTabIndicator(
                borderSide: BorderSide(color: AppColors.blue300, width: 2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey500),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                    text: widget.period.quantity.toString()),
                onChanged: (value) {
                  setState(() {
                    widget.period.quantity = int.parse(value);
                  });
                },
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(widget.form,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
        Row(
          children: [
            Container(
              height: 26,
              width: 30,
              decoration: const UnderlineTabIndicator(
                borderSide: BorderSide(color: AppColors.blue300, width: 2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey500),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                    text: widget.period.frequency.toString()),
                onChanged: (value) {
                  setState(() {
                    widget.period.frequency = int.parse(value);
                  });
                },
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            const Text("fois tout les ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(
              width: 4,
            ),
            Container(
              height: 26,
              width: 30,
              decoration: const UnderlineTabIndicator(
                borderSide: BorderSide(color: AppColors.blue300, width: 2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey500),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                    text: widget.period.frequencyRatio.toString()),
                onChanged: (value) {
                  setState(() {
                    widget.period.frequencyRatio = int.parse(value);
                  });
                },
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Container(
                height: 34,
                width: 106,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: DropdownButton(
                  isDense: true,
                  underline: Container(
                    color: AppColors.blue300,
                    height: 2,
                  ),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey500),
                  value: widget.period.frequencyUnit,
                  items: units.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      widget.period.frequencyUnit = value.toString();
                    });
                  },
                  icon: const Icon(Icons.keyboard_arrow_down),
                )),
          ],
        ),
        if (isOpen) ...[
          Row(children: [
            const Text('Pendant',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(
              width: 8,
            ),
            Container(
              height: 26,
              width: 30,
              decoration: const UnderlineTabIndicator(
                borderSide: BorderSide(color: AppColors.blue300, width: 2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey500),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                    text: widget.period.periodLength.toString()),
                onChanged: (value) {
                  setState(() {
                    widget.period.periodLength = int.parse(value);
                  });
                },
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Container(
                height: 34,
                width: 106,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: DropdownButton(
                  isDense: true,
                  underline: Container(
                    color: AppColors.blue300,
                    height: 2,
                  ),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey500),
                  value: widget.period.periodUnit,
                  items: units.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      widget.period.periodUnit = value.toString();
                    });
                  },
                  icon: const Icon(Icons.keyboard_arrow_down),
                )),
          ]),
        ],
        const SizedBox(
          height: 12,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isOpen = !isOpen;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                const Icon(BootstrapIcons.clock_fill, color: AppColors.grey500),
                const SizedBox(
                  width: 8,
                ),
                isOpen
                    ? const Text('Supprimer la durée',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey500))
                    : const Text('Ajouter une durée',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey500)),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.removePeriod(widget.index);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Icon(BootstrapIcons.x, color: AppColors.grey500),
                SizedBox(
                  width: 8,
                ),
                Text('Supprimer la periode',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey500)),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          color: AppColors.blue200,
          height: 2,
        )
      ],
    );
  }
}
