import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_app/services/medecine.dart';
import 'package:edgar_app/utils/mapper_unit_medicine.dart';
import 'package:edgar_app/utils/treatement_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ModalTreamentInfo extends StatefulWidget {
  // Changement de StatelessWidget à StatefulWidget
  const ModalTreamentInfo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ModalTreamentInfoState createState() =>
      _ModalTreamentInfoState(); // Création de l'état
}

class _ModalTreamentInfoState extends State<ModalTreamentInfo> {
  // État associé
  bool isDelete = false; // Déplacement de la variable ici

  List<Treatment> treatments = [
    Treatment(
      id: "1",
      createdBy: "1",
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 7)),
      medicines: [
        Medicine(
          medicineId: "66ddb27b87cda8934bb5bcf6",
          comment: "Comment",
          period: [
            Period(
              quantity: 2,
              frequency: 1,
              frequencyRatio: 2,
              frequencyUnit: FrequencyUnit.JOUR,
              periodLength: 3,
              periodUnit: PeriodUnit.SEMAINE,
            ),
          ],
        ),
        Medicine(
          medicineId: "66ddb27b87cda8934bb5bcf6",
          comment: "Comment",
          period: [
            Period(
              quantity: 2,
              frequency: 1,
              frequencyRatio: 2,
              frequencyUnit: FrequencyUnit.JOUR,
              periodLength: 3,
              periodUnit: PeriodUnit.SEMAINE,
            ),
          ],
        ),
      ],
    ),
    Treatment(
      id: "2",
      createdBy: "2",
      startDate: DateTime.now().subtract(Duration(days: 2)),
      endDate: DateTime.now().add(Duration(days: 3)),
      medicines: [
        Medicine(
          medicineId: "66ddb27b87cda8934bb5bcf6",
          comment: "Coucou",
          period: [
            Period(
              quantity: 2,
              frequency: 1,
              frequencyRatio: 2,
              frequencyUnit: FrequencyUnit.JOUR,
              periodLength: 3,
              periodUnit: PeriodUnit.SEMAINE,
            ),
          ],
        ),
        Medicine(
          medicineId: "66ddb27b87cda8934bb5bcf6",
          comment: "Coucou",
          period: [
            Period(
              quantity: 2,
              frequency: 1,
              frequencyRatio: 2,
              frequencyUnit: FrequencyUnit.JOUR,
              periodLength: 3,
              periodUnit: PeriodUnit.SEMAINE,
            ),
            Period(
              quantity: 4,
              frequency: 2,
              frequencyRatio: 1,
              frequencyUnit: FrequencyUnit.MOIS,
              periodLength: 3,
              periodUnit: PeriodUnit.MOIS,
            ),
          ],
        ),
      ],
    ),
  ];

  String nameTreatment = "";

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      icon: SvgPicture.asset(
        'assets/images/utils/infoTreatment.svg',
      ),
      title: "Ajouter un sujet de santé",
      subtitle: "Renseigner les informations de votre sujet de santé.",
      body: [
        Text(
          "Le nom de votre sujet de santé",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 4),
        CustomField(
          label: "Rhume",
          onChanged: (value) {
            setState(() {
              nameTreatment = value.trim();
            });
          },
          action: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Text(
                "Ajouter un traitement",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              Spacer(),
              SvgPicture.asset(
                'assets/images/utils/plus-lg.svg',
                height: 12,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              // Appel à setState pour mettre à jour l'interface
              isDelete = !isDelete;
            });
          },
          child: isDelete
              ? Container(
                  decoration: BoxDecoration(
                    color: AppColors.red100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.red200, width: 1),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        "Supprimer le traitement",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: AppColors.red700,
                        ),
                      ),
                      Spacer(),
                      SvgPicture.asset(
                        'assets/images/utils/minus-lg.svg',
                        // ignore: deprecated_member_use
                        color: AppColors.red700,
                      ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    Text(
                      "Supprimer un traitement",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Spacer(),
                    SvgPicture.asset(
                      'assets/images/utils/minus-lg.svg',
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 12),
        for (final treatment in treatments) ...[
          CardTreatmentAdd(
            treatment: treatment,
            isDelete: isDelete,
            onDelete: () {
              setState(() {
                treatments.remove(treatment);
              });
            },
          ),
          const SizedBox(height: 4),
        ],
        if (isDelete) ...[
          const SizedBox(height: 8),
          Buttons(
              variant: Variant.deleteBordered,
              size: SizeButton.sm,
              msg: Text("Supprimer les traitements"),
              onPressed: () {}),
        ]
      ],
      footer: Column(
        children: [
          Buttons(
            variant: Variant.primary,
            size: SizeButton.md,
            msg: Text("Ajouter le sujet de santé"),
            onPressed: () {
              Logger().i(nameTreatment);
            },
          ),
          const SizedBox(height: 8),
          Buttons(
            variant: Variant.secondary,
            size: SizeButton.md,
            msg: Text("Revenir en arrière"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class CardTreatmentAdd extends StatefulWidget {
  final Treatment treatment;
  final bool isDelete;
  final VoidCallback? onDelete;

  const CardTreatmentAdd({
    super.key,
    required this.treatment,
    this.isDelete = false,
    this.onDelete,
  });

  @override
  State<CardTreatmentAdd> createState() => _CardTreatmentAddState();
}

class _CardTreatmentAddState extends State<CardTreatmentAdd> {
  bool _isChecked = false;

  // Memoized date formatter
  static final _dateFormatter = DateFormat('dd/MM/yyyy');

  // Constants for styling
  static const _cardPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const _borderRadius = 8.0;
  static const _spacing = 8.0;

  void _handleCheckboxChange(bool? value) {
    if (value == null) return;
    setState(() {
      _isChecked = value;
    });
    if (value && widget.onDelete != null) {
      widget.onDelete!();
    }
  }

  @override
  void initState() {
    super.initState();
    getAllMedicineName();
  }

  List<String> medicineName = []; // Déplacement de la variable ici,

  Future<bool> getAllMedicineName() async {
    final ids = widget.treatment.medicines
        .map((e) => e.medicineId)
        .take(3)
        .toList(); // Utilisation de widget.treatment
    for (final id in ids) {
      final medicine = await getMedecineById(context, id.toString());
      setState(
        () {
          medicineName.add(medicine['name']);
        },
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isDelete
          ? () => _handleCheckboxChange(!_isChecked)
          : () {
              final model =
                  Provider.of<BottomSheetModel>(context, listen: false);
              model.resetCurrentIndex();

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return Consumer<BottomSheetModel>(
                    builder: (context, model, child) {
                      return ListModal(
                        model: model,
                        children: [
                          ModalInfoTreatment(
                            treatment: widget.treatment,
                            medicalAntecedentName: "Test",
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
      child: Container(
        padding: _cardPadding,
        decoration: BoxDecoration(
          color: AppColors.blue50,
          borderRadius: BorderRadius.circular(_borderRadius),
          border: Border.all(color: AppColors.blue200, width: 1),
        ),
        child: Row(
          children: [
            if (widget.isDelete) ...[
              CustomCheckBox(
                validate: _isChecked,
                onChanged: () {
                  setState(() {
                    _isChecked = !_isChecked;
                  });
                },
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _dateFormatter.format(widget.treatment.startDate),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(width: _spacing),
                      SvgPicture.asset(
                        'assets/images/utils/arrow_appointement.svg',
                      ),
                      const SizedBox(width: _spacing),
                      Text(
                        _dateFormatter.format(widget.treatment.endDate),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: _spacing),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final name in medicineName) ...[
                        CardMiniMedecine(name: name),
                        const SizedBox(width: 4),
                      ]
                    ],
                  ),
                ],
              ),
            ),
            if (!widget.isDelete)
              SvgPicture.asset(
                'assets/images/utils/arrowRightIphone.svg',
                height: 12,
                width: 12,
              ),
          ],
        ),
      ),
    );
  }
}

class CardMiniMedecine extends StatelessWidget {
  final String name;
  const CardMiniMedecine({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blue200, width: 1),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

class CustomCheckBox extends StatefulWidget {
  final bool validate;
  final Function() onChanged;
  const CustomCheckBox(
      {super.key, required this.validate, required this.onChanged});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onChanged,
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          color: widget.validate ? AppColors.blue700 : AppColors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: widget.validate ? AppColors.blue700 : AppColors.blue100,
            width: 1,
          ),
        ),
        child: widget.validate
            ? Icon(
                Icons.check,
                size: 12,
                color: AppColors.white,
              )
            : null,
      ),
    );
  }
}

class ModalInfoTreatment extends StatefulWidget {
  final Treatment treatment;
  final String medicalAntecedentName;
  const ModalInfoTreatment(
      {super.key,
      required this.treatment,
      required this.medicalAntecedentName});

  @override
  State<ModalInfoTreatment> createState() => _ModalInfoTreatmentState();
}

class _ModalInfoTreatmentState extends State<ModalInfoTreatment> {
  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Informations sur votre traitement",
      subtitle:
          "Consulter votre traitement pour le sujet de santé: ${widget.medicalAntecedentName}",
      body: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/images/utils/calendar_modal.svg',
              // ignore: deprecated_member_use
              color: AppColors.black,
              height: 16,
              width: 16,
            ),
            const SizedBox(width: 12),
            Text(
              "Du ${DateFormat('dd/MM/yyyy').format(widget.treatment.startDate)} au ${DateFormat('dd/MM/yyyy').format(widget.treatment.endDate)}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final medicine in widget.treatment.medicines) ...[
          CardMedicineInfo(
            medicine: medicine,
            context: context,
          ),
          const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class CardMedicineInfo extends StatefulWidget {
  // Changement de StatelessWidget à StatefulWidget
  final Medicine medicine;
  final BuildContext context;
  const CardMedicineInfo(
      {super.key, required this.medicine, required this.context});

  @override
  State<CardMedicineInfo> createState() =>
      _CardMedicineInfoState(); // Création de l'état
}

class _CardMedicineInfoState extends State<CardMedicineInfo> {
  String medicineName = "Médicament inconnu"; // Déplacement de la variable ici

  Future<bool> getMedicineName() async {
    final medicine = await getMedecineById(context, widget.medicine.medicineId);
    setState(() {
      medicineName = medicine['name'];
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blue200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/utils/Union-lg.svg',
                height: 16,
                width: 16,
                // ignore: deprecated_member_use
                color: AppColors.blue800,
              ),
              const SizedBox(width: 8),
              FutureBuilder<bool>(
                // Utilisation de FutureBuilder pour afficher le nom du médicament
                future: getMedicineName(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.blue800)); // Indicateur de chargement
                  } else if (snapshot.hasError) {
                    return Text(
                        'Erreur: ${snapshot.error}'); // Gestion des erreurs
                  } else {
                    return Text(
                      medicineName, // Affichage du nom du médicament
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final period in widget.medicine.period) ...[
            // Utilisation de widget.medicine
            Text(
              "${period != widget.medicine.period.first ? 'Puis ' : ''}${period.quantity} ${period.frequency} fois tou${period.frequencyUnit == FrequencyUnit.JOUR || period.frequencyUnit == FrequencyUnit.MOIS ? 's' : 'tes'} les ${period.frequencyRatio > 1 ? "${period.frequencyRatio} " : ""}${periodConverter(period.frequencyUnit.toString(), true)} ${period.periodLength != null && period.periodUnit != null ? 'pendant ${period.periodLength} ${periodConverter(period.periodUnit.toString(), period.periodLength! > 1)}' : ""}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            if (widget.medicine.period.indexOf(period) !=
                widget.medicine.period.length - 1) ...[
              const SizedBox(height: 8),
              Container(
                height: 1,
                width: double.infinity,
                color: AppColors.blue200,
              ),
              SizedBox(height: 8),
            ]
          ],
          const SizedBox(height: 8),
          Container(
            height: 1,
            width: double.infinity,
            color: AppColors.blue200,
          ),
          const SizedBox(height: 8),
          Text(
            "Commentaire:",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            widget.medicine.comment, // Utilisation de widget.medicine
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
