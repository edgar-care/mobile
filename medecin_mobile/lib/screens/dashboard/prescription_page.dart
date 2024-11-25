// ignore_for_file: must_be_immutable, use_build_context_synchronously
import "package:bootstrap_icons/bootstrap_icons.dart";
import "package:edgar/colors.dart";
import "package:edgar/widget.dart";
import "package:edgar_pro/widgets/custom_treatment_card.dart";
import "package:edgar_pro/services/medicines_services.dart";
import "package:edgar_pro/services/patient_info_service.dart";
import "package:edgar_pro/services/prescription_services.dart";
import "package:edgar_pro/utils/mapper_unit_medicine.dart";
import "package:edgar_pro/utils/medicine_type.dart";
import "package:edgar_pro/widgets/custom_nav_patient_card.dart";
import "package:edgar_pro/widgets/prescription_card.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class PrescriptionPage extends StatefulWidget {
  String id;
  Function setPages;
  Function setId;
  PrescriptionPage(
      {super.key,
      required this.id,
      required this.setPages,
      required this.setId});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  Map<String, dynamic> patientInfo = {};
  List<Map<String, dynamic>> prescriptionList = [];

  Future<void> loadInfo() async {
    prescriptionList = await getAllPrescription(widget.id);
    patientInfo = await getPatientById(widget.id, context);
  }

  void refresh(){
    setState(() {
      loadInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Container(
                key: const ValueKey("Header"),
                decoration: BoxDecoration(
                  color: AppColors.blue700,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(children: [
                    Image.asset(
                      "assets/images/logo/edgar-high-five.png",
                      height: 40,
                      width: 37,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      "Mes Patients",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: AppColors.white),
                    ),
                  ]),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.blue100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.blue200,
                    width: 2,
                  ),
                ),
                child: InkWell(
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
                                navigationPatient(context, patientInfo,
                                    widget.setPages, widget.setId)
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 3,
                          decoration: BoxDecoration(
                            color: AppColors.green500,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${patientInfo['Prenom']} ${patientInfo['Nom']}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                        ),
                        const Spacer(),
                        const Text(
                          'Voir Plus',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          BootstrapIcons.chevron_right,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                  child: ListView.separated(
                      itemCount: prescriptionList.length,
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 4,
                          ),
                      itemBuilder: (BuildContext context, int index) {
                        return PrescriptionCard(
                          date: DateFormat.yMd('fr')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  prescriptionList[index]['prescription']
                                          ['createdAt'] *
                                      1000))
                              .toString(),
                          name: "Ordonnance",
                          url: prescriptionList[index]['url_prescription'],
                        );
                      })),
              Buttons(
                variant: Variant.primary,
                size: SizeButton.md,
                msg: const Text('Ajouter une ordonnance'),
                onPressed: () {
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
                              AddPrescriptionModal(
                                  firstname: patientInfo['Prenom'],
                                  lastname: patientInfo['Nom'],
                                  id: widget.id,
                                  refresh: refresh),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget navigationPatient(BuildContext context, Map<String, dynamic> patient,
      Function setPages, Function setId) {
    return ModalContainer(
      title: '${patient['Prenom']} ${patient['Nom']}',
      subtitle: "Veuillez choisir une catégorie",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.person,
          size: 18,
        ),
        type: ModalType.info,
      ),
      body: [
        CustomNavPatientCard(
            text: 'Dossier médical',
            icon: BootstrapIcons.postcard_heart_fill,
            setPages: setPages,
            pageTo: 6,
            id: patient['id'],
            setId: setId),
        const SizedBox(height: 4),
        CustomNavPatientCard(
            text: 'Rendez-vous',
            icon: BootstrapIcons.calendar2_week_fill,
            setPages: setPages,
            pageTo: 7,
            id: patient['id'],
            setId: setId),
        const SizedBox(height: 4),
        CustomNavPatientCard(
            text: 'Documents',
            icon: BootstrapIcons.file_earmark_text_fill,
            setPages: setPages,
            pageTo: 8,
            id: patient['id'],
            setId: setId),
        const SizedBox(height: 4),
        CustomNavPatientCard(
            text: 'Ordonnance',
            icon: BootstrapIcons.capsule,
            setPages: setPages,
            pageTo: 9,
            id: patient['id'],
            setId: setId),
        const SizedBox(height: 4),
        CustomNavPatientCard(
            text: 'Messagerie',
            icon: BootstrapIcons.chat_dots_fill,
            setPages: setPages,
            pageTo: 10,
            id: patient['id'],
            setId: setId),
        const SizedBox(height: 12),
        Container(height: 2, color: AppColors.blue200),
        const SizedBox(height: 12),
      ],
      footer: Buttons(
          variant: Variant.primary,
          size: SizeButton.sm,
          msg: const Text(
            'Revenir à la patientèle',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          onPressed: () {
            setPages(3);
            Navigator.pop(context);
          }),
    );
  }
}

class AddPrescriptionModal extends StatefulWidget {
  String firstname;
  String lastname;
  String id;
  Function refresh;
  AddPrescriptionModal(
      {super.key, required this.firstname, required this.lastname, required this.id, required this.refresh});

  @override
  State<AddPrescriptionModal> createState() => _AddPrescriptionModalState();
}

class _AddPrescriptionModalState extends State<AddPrescriptionModal> {
  List<Map<String, dynamic>> medicines = [];
  List<String> suggestions = [];
  Future<void> loadInfo() async {
    await getAllMedicines().then((value) {
      medicines = value;
    });
    for (int i = 0; i < medicines.length; i++) {
      suggestions.add(
          "${medicines[i]['name']} - ${convertMedicineUnit(medicines[i]['dosage_form'])}");
    }
  }

  @override
  void initState() {
    loadInfo();
    super.initState();
  }

  List<Medicine> medicineList = [];
  void addMedicine(String id) {
    setState(() {
      medicineList.add(Medicine(
        medicineId: id,
        qsp: 1,
        qspUnit: "Jours",
        comment: "",
        periods: [
          Period(
            quantity: 1,
            frequency: 1,
            frequencyRatio: 1,
            frequencyUnit: "Jours",
            periodLength: 1,
            periodUnit: "Jours",
          )
        ],
      ));
    });
  }

  void removeMedicine(int index) {
    setState(() {
      medicineList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Création d'une ordonnance",
      subtitle:
          "Créer une ordonnance pour votre patient: ${widget.firstname} ${widget.lastname}",
      body: [
        CustomAutoComplete(
            label: 'Nom du médicament',
            icon: BootstrapIcons.search,
            keyboardType: TextInputType.text,
            onValidate: (value) {
              for (int i = 0; i < medicines.length; i++) {
                if ("${medicines[i]['name']} - ${convertMedicineUnit(medicines[i]['dosage_form'])}" ==
                    value) {
                  addMedicine(medicines[i]['id']);
                }
              }
            },
            suggestions: suggestions),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: medicineList.length,
            itemBuilder: (context, index) {
              return TreatementCard(
                index: index,
                medicine: medicineList[index],
                medicineName: medicines
                    .where((element) =>
                        element['id'] == medicineList[index].medicineId)
                    .first['name'],
                dosageForm: medicines
                    .where((element) =>
                        element['id'] == medicineList[index].medicineId)
                    .first['dosage_form'],
                removeMedicine: removeMedicine,
              );
            },
          ),
        ),
        Column(
          children: [
            Buttons(
              variant: Variant.primary,
              size: SizeButton.md,
              msg: const Text('Ajouter le document'),
              onPressed: () {
                if (medicineList.isEmpty) {
                  TopErrorSnackBar(
                    message: 'Veuillez ajouter au moins un médicament',
                  ).show(context);
                  return;
                }
                final List<Map<String, dynamic>> prescription = [];
                for (int i = 0; i < medicineList.length; i++) {
                  prescription.add({
                    "medicine_id": medicineList[i].medicineId,
                    "qsp": medicineList[i].qsp,
                    "qsp_unit": periodConvertertoBack(medicineList[i].qspUnit),
                    "comment": medicineList[i].comment,
                    "periods": medicineList[i].periods
                        .map((e) => {
                              "quantity": e.quantity,
                              "frequency": e.frequency,
                              "frequency_ratio": e.frequencyRatio,
                              "frequency_unit": periodConvertertoBack(e.frequencyUnit),
                              "period_length": e.periodLength,
                              "period_unit": periodConvertertoBack(e.periodUnit),
                            })
                        .toList()
                  });
                }
                final Map<String, dynamic> data = {
                  "patient_id": widget.id,
                  "medicines": prescription
                };
                postPrescription(data).then((value) {
                  if (value) {
                    Navigator.pop(context);
                    Future.delayed(const Duration(milliseconds: 500), () {
                      widget.refresh();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SuccessSnackBar(
                        message: 'Ordonnance ajouté avec succès',
                        context: context,
                      ));
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      ErrorSnackBar(
                        message: 'Erreur lors de l\'ajout de l\'ordonnance',
                        context: context,
                      ));
                  }
                });
              }
            ),
            const SizedBox(height: 8),
            Buttons(
              variant: Variant.secondary,
              size: SizeButton.md,
              msg: const Text('Annuler'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.capsule,
          size: 18,
          color: AppColors.blue700,
        ),
        type: ModalType.info,
      ),
    );
  }
}
