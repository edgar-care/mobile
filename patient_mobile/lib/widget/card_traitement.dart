import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_app/utils/treatement_utils.dart';
import 'package:edgar_app/widget/card_traitement_period.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
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
      widget.medicine.period.add(Period(
        quantity: 1,
        frequency: 1,
        frequencyRatio: 1,
        frequencyUnit: FrequencyUnit.JOUR,
        periodLength: 1,
        periodUnit: PeriodUnit.JOUR,
      ));
    });
  }

  void removePeriod(int index) {
    setState(() {
      widget.medicine.period.removeAt(index);
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
                  widget.medicine.period.length > 1
                      ? Text(
                          '${widget.medicine.period.length} périodes renseignées',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500))
                      : Text(
                          '${widget.medicine.period.length} période renseignée',
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
              for (int i = 0; i < widget.medicine.period.length; i++)
                TreatmentPeriodCard(
                    index: i,
                    form: widget.dosageForm,
                    period: widget.medicine.period[i],
                    removePeriod: removePeriod),
              const SizedBox(
                height: 4,
              ),
              CustomField(
                value: widget.medicine.comment.isNotEmpty
                    ? widget.medicine.comment
                    : '',
                label: 'Commentaire',
                onChanged: (value) {
                  setState(() {
                    widget.medicine.comment = value.trim();
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
                    widget.medicine.period.add(Period(
                      quantity: 1,
                      frequency: 1,
                      frequencyRatio: 1,
                      frequencyUnit: FrequencyUnit.JOUR,
                      periodLength: 1,
                      periodUnit: PeriodUnit.JOUR,
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
