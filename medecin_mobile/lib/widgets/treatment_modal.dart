import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_pro/services/medecines_services.dart';
import 'package:edgar_pro/services/medicines_services.dart';
import 'package:edgar_pro/utils/mapper_unit_medicine.dart';
import 'package:edgar_pro/utils/treatment_utils.dart';
import 'package:edgar_pro/widgets/card_traitement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ModalTreamentInfo extends StatefulWidget {
  final Function addMedicalAntecedents;
  const ModalTreamentInfo({super.key, required this.addMedicalAntecedents});

  @override
  // ignore: library_private_types_in_public_api
  _ModalTreamentInfoState createState() => _ModalTreamentInfoState();
}

class _ModalTreamentInfoState extends State<ModalTreamentInfo> {
  bool isDelete = false;

  String nameTreatment = "";

  List<Treatment> deleteList = [];

  void addTreatment(Treatment treatment) {
    setState(() {
      traitements.add(treatment);
    });
  }

  List<Treatment> traitements = [];

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
          onTap: () {
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
                        AddTreatmentModal(
                          addTreatment: addTreatment,
                        )
                      ],
                    );
                  },
                );
              },
            );
          },
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
        for (final treatment in traitements) ...[
          CardTreatmentAdd(
            removeDeleteList: () {
              setState(() {
                deleteList.remove(treatment);
              });
            },
            addDeleteList: () {
              setState(() {
                deleteList.add(treatment);
              });
            },
            antecedentName: nameTreatment,
            treatment: treatment,
            isDelete: isDelete,
            onDelete: () {
              setState(() {
                traitements.remove(treatment);
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
              onPressed: () {
                for (final id in deleteList) {
                  setState(() {
                    traitements.remove(id);
                  });
                }
                isDelete = false;
              }),
        ]
      ],
      footer: Column(
        children: [
          Buttons(
            variant: Variant.primary,
            size: SizeButton.md,
            msg: Text("Ajouter le sujet de santé"),
            onPressed: () {
              if (nameTreatment.isNotEmpty && traitements.isNotEmpty) {
                widget.addMedicalAntecedents(nameTreatment, traitements);
                Navigator.pop(context);
              }else{
                TopErrorSnackBar(message: "Veuillez remplir tout les champs",).show(context);
              }
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

class AddTreatmentModal extends StatefulWidget {
  final Function addTreatment;
  const AddTreatmentModal({super.key, required this.addTreatment});

  @override
  State<AddTreatmentModal> createState() => _AddTreatmentModalState();
}

class _AddTreatmentModalState extends State<AddTreatmentModal> {
  Treatment traitement = Treatment(
    startDate: DateTime.fromMillisecondsSinceEpoch(0),
    endDate: DateTime.fromMillisecondsSinceEpoch(0),
    medicines: [],
  );

  List<Map<String, dynamic>> medicalAntecedent = [];
  List<String> medId = [];
  String dosageform = '';
  List<Map<String, dynamic>> medicines = [];
  List<String> medicinesSuggestion = [];
  @override
  void initState() {
    super.initState();
    loadInfo();
  }

  Future<void> loadInfo() async {
    await getMedecines(context).then((value) {
      medicines = value;
    });
    for (int i = 0; i < medicines.length; i++) {
      medicinesSuggestion.add(
          "${medicines[i]['name']} - ${convertMedicineUnit(medicines[i]['dosage_form'])}");
    }
  }

  getMedicineName(String id) {
    for (int i = 0; i < medicines.length; i++) {
      if (medicines[i]['id'] == id) {
        return "${medicines[i]['name']}";
      }
    }
    return '';
  }


  void addMedicine(String id) {
    setState(() {
      traitement.medicines.add(Medicine(
        medicineId: id,
        comment: "",
        period: [
          Period(
            quantity: 1,
            frequency: 1,
            frequencyRatio: 1,
            frequencyUnit: FrequencyUnit.JOUR,
            periodLength: 1,
            periodUnit: PeriodUnit.JOUR,
          )
        ],
      ));
    });
  }

  void removeMedicine(int index) {
    setState(() {
      traitement.medicines.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      icon: IconModal(
        icon: Icon(
          BootstrapIcons.bandaid_fill,
          color: AppColors.blue700,
          size: 18,
        ),
        type: ModalType.info,
      ),
      title: 'Ajouter un traitement',
      subtitle: 'Renseigner les informations de votre traitement.',
      body: [
        Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date de début',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 38,
                  child: CustomDatePiker(
                    placeholder: '26/09/2022',
                    onChanged: (value) {
                      setState(() {
                        if (value.length == 10 &&
                            value[2] == '/' &&
                            value[5] == '/') {
                          traitement.startDate = DateTime(
                              int.parse(value.substring(6)),
                              int.parse(value.substring(3, 5)),
                              int.parse(value.substring(0, 2)));
                        } else {}
                      });
                    },
                  )),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Date de fin',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '(optionnel)',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 38,
                  child: CustomDatePiker(
                    placeholder: '26/09/2022',
                    onChanged: (value) {
                      setState(() {
                        if (value.length == 10 &&
                            value[2] == '/' &&
                            value[5] == '/') {
                          traitement.startDate = DateTime(
                              int.parse(value.substring(6)),
                              int.parse(value.substring(3, 5)),
                              int.parse(value.substring(0, 2)));
                        } else {}
                      });
                    },
                  )),
            ],
          )
        ]),
        const SizedBox(height: 12),
        CustomAutoComplete(
            label: 'Nom du médicament',
            icon: BootstrapIcons.search,
            keyboardType: TextInputType.text,
            onValidate: (value) {
              for (int i = 0; i < medicines.length; i++) {
                if ("${medicines[i]['name']} - ${convertMedicineUnit(medicines[i]['dosage_form'])}" ==
                    value) {
                  dosageform = convertMedicineUnit(medicines[i]['dosage_form']);
                  addMedicine(medicines[i]['id']);
                }
              }
            },
            suggestions: medicinesSuggestion),
        const SizedBox(height: 12),
        SizedBox(
            height: MediaQuery.of(context).size.height / 3,
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: traitement.medicines.length,
                itemBuilder: (context, index) {
                  return TreatementCard(
                    index: index,
                    medicine: traitement.medicines[index],
                    dosageForm: dosageform,
                    medicineName: getMedicineName(
                        traitement.medicines[index].medicineId),
                    removeMedicine: removeMedicine,
                  );
                },
              ),
            )
      ],
      footer: Column(
        children: [
          Buttons(
            variant: Variant.primary,
            size: SizeButton.md,
            msg: const Text(
              'Ajouter le traitement',
              style: TextStyle(color: AppColors.white),
            ),
            onPressed: () {
              if(traitement.medicines.isNotEmpty && traitement.startDate != DateTime.fromMillisecondsSinceEpoch(0)){
                for(var medicine in traitement.medicines){
                  if(medicine.comment.isEmpty || medicine.period.isEmpty || medicine.medicineId.isEmpty ){
                    TopErrorSnackBar(message: "Veuillez remplir tout les champs",).show(context);
                    return;
                  }
                }
                widget.addTreatment(traitement);
                Navigator.pop(context);
              }else{
                TopErrorSnackBar(message: "Veuillez remplir tout les champs",).show(context);
              }
            }
          ),
          const SizedBox(height: 8),
          Buttons(
            variant: Variant.secondary,
            size: SizeButton.md,
            msg: const Text(
              'Annuler',
              style: TextStyle(color: AppColors.white),
            ),
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
  final String antecedentName;
  final bool isDelete;
  final VoidCallback? onDelete;
  final Function? addDeleteList;
  final Function? removeDeleteList;
  const CardTreatmentAdd({
    super.key,
    required this.treatment,
    this.isDelete = false,
    required this.antecedentName,
    this.onDelete,
    this.addDeleteList,
    this.removeDeleteList,
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
                            medicalAntecedentName: widget.antecedentName,
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
                    if (_isChecked) {
                      widget.removeDeleteList!();
                      _isChecked = false;
                    } else {
                      widget.addDeleteList!();
                      _isChecked = true;
                    }
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
                      if(widget.treatment.endDate != DateTime.fromMillisecondsSinceEpoch(0)) ...[
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
                      ]
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

class ModalInfoAntecedent extends StatefulWidget {
  final Map<String, dynamic> medicalAntecedent;
  const ModalInfoAntecedent({super.key, required this.medicalAntecedent});

  @override
  State<ModalInfoAntecedent> createState() => _ModalInfoAntecedentState();
}

class _ModalInfoAntecedentState extends State<ModalInfoAntecedent> {
  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      icon: IconModal(
        icon: Icon(BootstrapIcons.capsule_pill, color: AppColors.blue700,size: 18,),
        type: ModalType.info,
      ),
      title: "Informations de votre sujet de santé",
      subtitle: "Vos traitements pour votre sujet de santé: ${widget.medicalAntecedent['name']}",
      body: [
        for (final treatment in widget.medicalAntecedent['treatments']) ...[
          CardTreatmentAdd(
            antecedentName: widget.medicalAntecedent['name'],
            treatment: treatment,
          ),
          const SizedBox(height: 4),
        ],
      ],
      footer: Buttons(
        variant: Variant.secondary,
        size: SizeButton.md,
        msg: Text("Revenir en arrière"),
        onPressed: () => Navigator.pop(context),
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
      icon: IconModal(
        icon: Icon(BootstrapIcons.capsule_pill, color: AppColors.blue700,size: 18,),
        type: ModalType.info,
      ),
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
              "Du ${DateFormat('dd/MM/yyyy').format(widget.treatment.startDate)}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            if (widget.treatment.endDate.millisecondsSinceEpoch != 0 &&
                widget.treatment.endDate.millisecondsSinceEpoch >
                    DateTime.now().millisecondsSinceEpoch) ...[
              Text(
                " au ${DateFormat('dd/MM/yyyy').format(widget.treatment.endDate)}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              )
            ]
          ],
        ),
        const SizedBox(height: 8),
        for (final medicine in widget.treatment.medicines) ...[
          CardMedicineInfo(
            medicineName: widget.medicalAntecedentName,
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
  final String medicineName;
  final Medicine medicine;
  final BuildContext context;
  const CardMedicineInfo(
      {super.key, required this.medicine, required this.context, required this.medicineName});

  @override
  State<CardMedicineInfo> createState() =>
      _CardMedicineInfoState(); // Création de l'état
}

class _CardMedicineInfoState extends State<CardMedicineInfo> {
  String medicineName = "Médicament inconnu"; // Déplacement de la variable ici
  String form = "forme inconnu";
  Future<bool> getMedicineName() async {
    final medicine = await getMedecineById(context, widget.medicine.medicineId);
    setState(() {
      form = medicine['dosage_form'];
    });
    return true;
  }

  getMedicineForm(bool plural) {
    return convertMedicineUsageUnit(form, plural);
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
              "${period != period ? 'Puis ' : ''}${period.quantity} ${getMedicineForm(period.quantity > 1)} ${period.frequency} fois tou${period.frequencyUnit == FrequencyUnit.JOUR || period.frequencyUnit == FrequencyUnit.MOIS ? 's' : 'tes'} les ${period.frequencyRatio > 1 ? "${period.frequencyRatio} " : ""}${periodConverter(period.frequencyUnit.toString().substring(period.frequencyUnit.toString().indexOf('.') + 1), true)} ${period.periodLength != null && period.periodUnit != null ? 'pendant ${period.periodLength} ${periodConverter(period.periodUnit.toString().substring(period.periodUnit.toString().indexOf('.') + 1), period.periodLength! > 1)}' : ""}",
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