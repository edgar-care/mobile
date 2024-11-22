// ignore_for_file: must_be_immutable

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_pro/widgets/custom_treatment_period.dart';
import 'package:edgar_pro/utils/medicine_type.dart';
import 'package:flutter/material.dart';

class TreatementCard extends StatefulWidget {
  final int index;
  Medicine medicine;
  String medicineName;
  String dosageForm;
  Function removeMedicine;
  TreatementCard(
      {super.key,
      required this.index,
      required this.medicine,
      required this.medicineName,
      required this.dosageForm,
      required this.removeMedicine});

  @override
  State<TreatementCard> createState() => _TreatementCardState();
}

class _TreatementCardState extends State<TreatementCard> {
  bool isOpen = false;
  List<String> units = ['Jours', 'Semaines', 'Mois', 'Années'];

  void addPeriod() {
    setState(() {
      widget.medicine.periods.add(Period(
        quantity: 1,
        frequency: 1,
        frequencyRatio: 1,
        frequencyUnit: 'Jours',
        periodLength: 1,
        periodUnit: 'Jours',
      ));
    });
  }

  void removePeriod(int index) {
    setState(() {
      widget.medicine.periods.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.blue200, width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.medicineName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                if (!isOpen) ...[
                  widget.medicine.periods.length > 1
                      ? Text(
                          '${widget.medicine.periods.length} périodes renseignées',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500))
                      : Text(
                          '${widget.medicine.periods.length} période renseignée',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500)),
                ]
              ]),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isOpen = !isOpen;
                    });
                  },
                  child: Icon(
                    isOpen
                        ? BootstrapIcons.chevron_up
                        : BootstrapIcons.chevron_down,
                  ))
            ]),
            if (isOpen) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("QSP",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 26,
                    width: 30,
                    decoration: const UnderlineTabIndicator(
                      borderSide:
                          BorderSide(color: AppColors.blue300, width: 2),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
                          text: widget.medicine.qsp.toString()),
                      onChanged: (value) {
                        setState(() {
                          widget.medicine.qsp = int.parse(value);
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                        value: widget.medicine.qspUnit,
                        items: units.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            widget.medicine.qspUnit = value.toString();
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                      )),
                ],
              ),
              Container(
                height: 2,
                color: AppColors.blue200,
              ),
              const SizedBox(
                height: 4,
              ),
              for (int i = 0; i < widget.medicine.periods.length; i++)
                TreatmentPeriodCard(
                    index: i,
                    form: widget.dosageForm,
                    period: widget.medicine.periods[i],
                    removePeriod: removePeriod),
              const SizedBox(
                height: 4,
              ),
              CustomField(
                label: 'Commentaire',
                onChanged: (value) {
                  setState(() {
                    widget.medicine.comment = value;
                  });
                },
                action: TextInputAction.done,
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.medicine.periods.add(Period(
                      quantity: 1,
                      frequency: 1,
                      frequencyRatio: 1,
                      frequencyUnit: 'Jours',
                      periodLength: 1,
                      periodUnit: 'Jours',
                    ));
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        BootstrapIcons.plus,
                        color: AppColors.grey500,
                      ),
                      SizedBox(width: 8),
                      Text('Ajouter une periode',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey500)),
                    ],
                  ),
                ),
              ),
            ],
            GestureDetector(
              onTap: () {
                widget.removeMedicine(widget.index);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      BootstrapIcons.trash_fill,
                      color: AppColors.grey500,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text('Supprimer le médicament',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey500)),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
