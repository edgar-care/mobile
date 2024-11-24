// ignore_for_file: use_build_context_synchronously
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_app/services/medecine.dart';
import 'package:edgar_app/services/medical_antecedent.dart';
import 'package:edgar_app/utils/mapper_unit_medicine.dart';
import 'package:edgar_app/utils/treatement_utils.dart';
import 'package:edgar_app/widget/card_traitement.dart';
import 'package:edgar_app/widget/card_traitement_info.dart';
import 'package:edgar_app/widget/modal_treatment.dart';
import 'package:edgar_app/widget/navbarplus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';

class TraitmentPage extends StatefulWidget {
  const TraitmentPage({super.key});

  @override
  State<TraitmentPage> createState() => _TraitmentPageState();
}

class _TraitmentPageState extends State<TraitmentPage> {
  // ignore: non_constant_identifier_names
  List<Map<String, dynamic>> medicalAntecedent = [];
  Map<String, String> medicaments = {};
  ValueNotifier<int> isEncours = ValueNotifier(0);
  List<Map<String, dynamic>> traitements = [];
  List<Map<String, dynamic>> meds = [];

  Future<void> getFilteredTraitement() async {
    getAllMedicines();
    traitements.clear();
    medicalAntecedent = await getMedicalAntecedent(context);
    return;
  }

  @override
  void initState() {
    super.initState();
    getFilteredTraitement();
  }

  void getAllMedicines() async {
    meds = await getMedecines(context);
    for (var treatment in meds) {
      medicaments[treatment['id']] = treatment['name'];
    }
  }

  void deleteTraitement(String id) async {
    await deleteTraitementRequest(id, context).then((value) {
      if (value) {
        Navigator.pop(context);
        Navigator.pop(context);
        TopSuccessSnackBar(message: 'Traitement supprimé avec succès').show(context);
        getFilteredTraitement();
        setState(() {});
      } else {
        TopErrorSnackBar(message: 'Erreur lors de la suppression du traitement').show(context);
      }
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.blue700,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(children: [
            Image.asset(
              'assets/images/logo/edgar-high-five.png',
              width: 40,
            ),
            const SizedBox(width: 16),
            const Text(
              'Mes traitements',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder(
          valueListenable: isEncours,
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Buttons(
                    variant: value == 0 ? Variant.primary : Variant.secondary,
                    size: SizeButton.sm,
                    msg: const Text(
                      'Traitement en cours',
                    ),
                    onPressed: () {
                      setState(() {
                        isEncours.value = 0;
                      });
                    },
                    widthBtn:
                        (MediaQuery.of(context).size.width / 2 - 20).toInt(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Buttons(
                    variant: value == 1 ? Variant.primary : Variant.secondary,
                    size: SizeButton.sm,
                    msg: const Text(
                      'Traitement terminé',
                    ),
                    onPressed: () {
                      setState(() {
                        isEncours.value = 1;
                      });
                    },
                    widthBtn:
                        (MediaQuery.of(context).size.width / 2 - 20).toInt(),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Buttons(
          variant: Variant.primary,
          size: SizeButton.md,
          msg: const Text(
            "Ajouter un traitement",
            style: TextStyle(color: AppColors.white),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            final model = Provider.of<BottomSheetModel>(context, listen: false);
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
                          refresh: refresh,
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder(
            future: getFilteredTraitement(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blue700,
                    strokeCap: StrokeCap.round,
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text('Erreur de chargement des données');
              } else {
                for (var disease in medicalAntecedent) {
                  for (var treatment in disease["treatments"]) {
                    if (isEncours.value == 0) {
                      if (treatment["endDate"] == null ||
                          treatment["endDate"] == 0 ||
                          treatment["endDate"] >
                              DateTime.now().millisecondsSinceEpoch) {
                        traitements.add({
                          'medId': disease["id"],
                          "medNames": disease["name"],
                          "treatment": Treatment.fromJson(treatment),
                        });
                      }
                    } else {
                      if (treatment["endDate"] != null &&
                          treatment["endDate"] != 0 &&
                          treatment["endDate"] <
                              DateTime.now().millisecondsSinceEpoch) {
                        traitements.add({
                          'medId': disease["id"],
                          "medNames": disease["name"],
                          "treatment": Treatment.fromJson(treatment),
                        });
                      }
                    }
                  }
                }
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8,
                  ),
                  itemCount: traitements.length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        final model = Provider.of<BottomSheetModel>(context,
                            listen: false);
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
                                    SubMenu(
                                        treatment: traitements[index],
                                        deleteTraitement: deleteTraitement,
                                        index: index,
                                        meds: meds,
                                        medId: traitements[index]["medId"],
                                        refresh: refresh),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: CardTraitementSimplify(
                          medicaments: medicaments,
                          name: traitements[index]["medNames"],
                          traitement: traitements[index]["treatment"]),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class SubMenu extends StatelessWidget {
  final int index;
  final Function deleteTraitement;
  final Map<String, dynamic> treatment;
  final List<Map<String, dynamic>> meds;
  final Function refresh;
  final String medId;
  const SubMenu(
      {super.key,
      required this.deleteTraitement,
      required this.index,
      required this.treatment,
      required this.meds,
      required this.medId,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    Logger().d(treatment);
    return ModalContainer(
      body: [
        Text(
          treatment['medNames'],
          style: const TextStyle(
              fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Container(
          color: AppColors.blue100,
          height: 1,
        ),
        NavbarPLusTab(
          icon: Icon(BootstrapIcons.capsule, color: AppColors.blue800),
          title: 'Consulter le traitement',
          onTap: () {
            final model = Provider.of<BottomSheetModel>(context, listen: false);
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
                          treatment: treatment['treatment'],
                          medicalAntecedentName: treatment['medNames'],
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          type: 'Only',
          outlineIcon: Icon(
            BootstrapIcons.chevron_right,
          ),
        ),
        Container(
          color: AppColors.blue100,
          height: 1,
        ),
        NavbarPLusTab(
          icon: Icon(BootstrapIcons.pen_fill, color: AppColors.blue800),
          title: 'Modifier le traitement',
          onTap: () {
            final model = Provider.of<BottomSheetModel>(context, listen: false);
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
                        UpdateTreatment(
                          name: treatment['medNames'],
                          treatment: treatment['treatment'],
                          medicines: meds,
                          medId: medId,
                          refresh: refresh,
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          type: 'Only',
          outlineIcon: Icon(
            BootstrapIcons.chevron_right,
          ),
        ),
        Container(
          color: AppColors.blue100,
          height: 1,
        ),
        NavbarPLusTab(
          icon: Icon(BootstrapIcons.trash_fill, color: AppColors.red700),
          title: 'Supprimer le traitement',
          color: AppColors.red700,
          onTap: () {
            final model = Provider.of<BottomSheetModel>(context, listen: false);
            model.resetCurrentIndex();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return Consumer<BottomSheetModel>(
                  builder: (context, model, child) {
                    return ListModal(model: model, children: [
                      DeleteModal(
                        delete: deleteTraitement,
                        index: treatment['treatment'].id,
                      ),
                    ]);
                  },
                );
              },
            );
          },
          type: 'Only',
        ),
      ],
    );
  }
}

class DeleteModal extends StatelessWidget {
  final String index;
  final Function delete;
  const DeleteModal({super.key, required this.delete, required this.index});

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: 'Supprimer le traitement',
      subtitle:
          'Vous êtes sur le point de supprimer votre traitement. Si vous supprimez ce traitement, vous ne pourrez plus le consulter.',
      footer: Column(
        children: [
          Buttons(
            variant: Variant.delete,
            size: SizeButton.md,
            msg: const Text(
              'Supprimer le traitement',
              style: TextStyle(color: AppColors.blue700),
            ),
            onPressed: () {
              delete(index);
            },
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
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.x_lg,
          color: AppColors.red700,
          size: 18,
        ),
        type: ModalType.error,
      ),
    );
  }
}

class AddTreatmentModal extends StatefulWidget {
  final Function refresh;
  const AddTreatmentModal({super.key, required this.refresh});

  @override
  State<AddTreatmentModal> createState() => _AddTreatmentModalState();
}

class _AddTreatmentModalState extends State<AddTreatmentModal> {
  Map<String, dynamic> traitement = {
    "id": "",
    "startDate": 0,
    "endDate": 0,
    "medicines": []
  };

  List<Map<String, dynamic>> medicalAntecedent = [];
  List<String> suggestion = [];
  List<String> medId = [];
  String dosageform = '';
  List<Map<String, dynamic>> medicines = [];
  List<String> medicinesSuggestion = [];
  @override
  void initState() {
    super.initState();
    loadInfo();
    getMedical();
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

  Future getMedical() async {
    medicalAntecedent = await getMedicalAntecedent(context);
    for (var disease in medicalAntecedent) {
      suggestion.add(disease["name"]);
      medId.add(disease["id"]);
    }
  }

  void addMedicine(String id) {
    setState(() {
      traitement['medicines'].add(Medicine(
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
      traitement['medicines'].removeAt(index);
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
        Text(
          'Le nom de votre sujet de santé',
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        CustomAutoComplete(
          keyboardType: TextInputType.name,
          icon: BootstrapIcons.search,
          label: "Nom de votre sujet de santé",
          suggestions: suggestion,
          onValidate: (value) {
            for (int i = 0; i < medicalAntecedent.length; i++) {
              if (medicalAntecedent[i]['name'] == value) {
                traitement["id"] = medId[i];
              }
            }
          },
        ),
        const SizedBox(height: 12),
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
                          traitement["startDate"] = DateTime(
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
                          traitement["endDate"] = DateTime(
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
                itemCount: traitement['medicines'].length,
                itemBuilder: (context, index) {
                  return TreatementCard(
                    index: index,
                    medicine: traitement['medicines'][index],
                    dosageForm: dosageform,
                    medicineName: getMedicineName(
                        traitement['medicines'][index].medicineId),
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
              if (traitement["id"] != "" &&
                  traitement["startDate"] != "0" &&
                  traitement["medicines"].length != 0 &&
                  traitement["medicines"][0].comment != "") {
                postTraitement({
                  "medical_antecedent_id": traitement["id"],
                  "start_date":
                      traitement["startDate"].toUtc().millisecondsSinceEpoch ~/
                          1000,
                  "end_date": traitement["endDate"] != 0
                      ? traitement["endDate"].toUtc().millisecondsSinceEpoch ~/
                          1000
                      : 0,
                  "medicines":
                      traitement["medicines"].map((e) => e.toJson()).toList()
                }, context)
                    .then((value) {
                  if (value) {
                    widget.refresh();
                    Navigator.pop(context);
                    TopSuccessSnackBar(message: 'Traitement ajouté avec succès')
                        .show(context);
                  } else {
                    TopErrorSnackBar(
                            message: 'Erreur lors de l\'ajout du traitement')
                        .show(context);
                  }
                });
              } else {
                TopErrorSnackBar(message: 'Veuillez remplir tous les champs')
                    .show(context);
              }
            },
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

// ignore: must_be_immutable
class UpdateTreatment extends StatefulWidget {
  final String medId;
  Treatment treatment;
  final String name;
  final Function refresh;
  final List<Map<String, dynamic>> medicines;
  UpdateTreatment(
      {super.key,
      required this.name,
      required this.treatment,
      required this.medicines,
      required this.medId,
      required this.refresh});

  @override
  State<UpdateTreatment> createState() => _UpdateTreatmentState();
}

class _UpdateTreatmentState extends State<UpdateTreatment> {
  List<Map<String, dynamic>> medicalAntecedent = [];
  List<String> suggestion = [];
  List<String> medId = [];
  String dosageform = '';
  List<String> medicinesSuggestion = [];

  @override
  void initState() {
    super.initState();
    loadInfo();
    getMedical();
  }

  Future<void> loadInfo() async {
    for (int i = 0; i < widget.medicines.length; i++) {
      medicinesSuggestion.add(
          "${widget.medicines[i]['name']} - ${convertMedicineUnit(widget.medicines[i]['dosage_form'])}");
    }
  }

  getMedicineName(String id) {
    for (int i = 0; i < widget.medicines.length; i++) {
      if (widget.medicines[i]['id'] == id) {
        return "${widget.medicines[i]['name']}";
      }
    }
    return '';
  }

  Future getMedical() async {
    medicalAntecedent = await getMedicalAntecedent(context);
    for (var disease in medicalAntecedent) {
      suggestion.add(disease["name"]);
      medId.add(disease["id"]);
    }
  }

  void addMedicine(String id) {
    setState(() {
      widget.treatment.medicines.add(Medicine(
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
      widget.treatment.medicines.removeAt(index);
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
      title: "Mise à jour du traitement",
      subtitle:
          "Renseigner les informations de votre traitement pour le sujet de santé: ${widget.name}",
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
                    initialValue:
                        "${widget.treatment.startDate.day.toString().padLeft(2, '0')}/${widget.treatment.startDate.month.toString().padLeft(2, '0')}/${widget.treatment.startDate.year}",
                    placeholder: '26/09/2022',
                    onChanged: (value) {
                      setState(() {
                        if (value.length == 10 &&
                            value[2] == '/' &&
                            value[5] == '/') {
                          widget.treatment.startDate = DateTime(
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
                          widget.treatment.endDate = DateTime(
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
              for (int i = 0; i < widget.medicines.length; i++) {
                if ("${widget.medicines[i]['name']} - ${convertMedicineUnit(widget.medicines[i]['dosage_form'])}" ==
                    value) {
                  dosageform =
                      convertMedicineUnit(widget.medicines[i]['dosage_form']);
                  addMedicine(widget.medicines[i]['id']);
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
                itemCount: widget.treatment.medicines.length,
                itemBuilder: (context, index) {
                  return TreatementCard(
                    index: index,
                    medicine: widget.treatment.medicines[index],
                    dosageForm: dosageform,
                    medicineName: getMedicineName(
                        widget.treatment.medicines[index].medicineId),
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
                'Mettre à jour',
                style: TextStyle(color: AppColors.white),
              ),
              onPressed: () {
                Logger().d(widget.treatment.id);
                Logger().d(widget.treatment.toJson());
                if (widget.treatment.id != "" &&
                    widget.treatment.startDate !=
                        DateTime.fromMillisecondsSinceEpoch(0) &&
                    widget.treatment.medicines[0].comment != "") {
                  putTraitement(widget.treatment.toJson(), widget.treatment.id, context)
                      .then((value) {
                    if (value) {
                      widget.refresh();
                      Navigator.pop(context);
                      TopSuccessSnackBar(
                              message: 'Traitement mis à jour avec succès')
                          .show(context);
                    } else {
                      TopErrorSnackBar(
                              message:
                                  'Erreur lors de la mise à jour du traitement')
                          .show(context);
                    }
                  });
                } else {
                  TopErrorSnackBar(message: 'Veuillez remplir tous les champs')
                      .show(context);
                }
              }),
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
