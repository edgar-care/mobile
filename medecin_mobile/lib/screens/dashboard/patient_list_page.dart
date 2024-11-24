// ignore_for_file: use_build_context_synchronously

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/doctor_services.dart';
import 'package:edgar_pro/services/medical_antecedent_services.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar/colors.dart';
import 'package:edgar_pro/utils/treatment_utils.dart';
import 'package:edgar_pro/widgets/AddPatient/add_button.dart';
import 'package:edgar_pro/widgets/AddPatient/custom_preload_field.dart';
import 'package:edgar_pro/widgets/card_doctor.dart';
import 'package:edgar_pro/widgets/card_traitement_small.dart';
import 'package:edgar_pro/widgets/custom_nav_patient_card.dart';
import 'package:edgar_pro/widgets/navbarplus.dart';
import 'package:edgar_pro/widgets/treatment_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:edgar/widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PatientPage extends StatefulWidget {
  String id;
  final Function setPages;
  final Function setId;
  PatientPage(
      {super.key,
      required this.id,
      required this.setPages,
      required this.setId});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  Map<String, dynamic> patientInfo = {};
  Map<String, dynamic> tmpInfo = {};
  List<Treatment> tmpTraitments = [];
  List<dynamic> docs = [];
  int doctorindex = -1;
  ValueNotifier<int> selected = ValueNotifier(0);
  var pageIndex = ValueNotifier(0);

  void updateModalIndex(int index) {
    pageIndex.value = index;
  }

  void updateSelection(int newSelection) {
    selected.value = newSelection;
  }

  Future<void> _loadInfo() async {
    patientInfo = await getPatientById(widget.id, context);
    docs = await getAllDoctor(context);
    tmpInfo = Map.of(patientInfo);
    doctorindex =
        docs.indexWhere((doc) => doc['id'] == patientInfo['medecin_traitant']);
    switch (patientInfo['sexe']) {
      case 'MALE':
        selected.value = 0;
        break;
      case 'FEMALE':
        selected.value = 1;
        break;
      case 'OTHER':
        selected.value = 2;
        break;
    }
  }

  void updateData() async {
    setState(() {
      _loadInfo();
    });
    tmpInfo = Map.of(patientInfo);
    tmpTraitments = [];
  }

  String sexe(String sexe) {
    switch (sexe) {
      case 'MALE':
        return 'Masculin';
      case 'FEMALE':
        return 'Feminin';
      default:
        return 'Autre';
    }
  }

  String taille(String taille) {
    int tailleInt = int.parse(taille);
    return (tailleInt / 100).toString();
  }

  void refresh () {
    setState(() {
      _loadInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadInfo(),
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
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.blue200, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.vertical,
                            spacing: 12,
                            children: [
                              Text('Prénom: ${patientInfo['Prenom']}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500)),
                              Text('Nom: ${patientInfo['Nom']}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  'Date de naissance: ${patientInfo['date_de_naissance']}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500)),
                              Text('Sexe: ${sexe(patientInfo['sexe'])}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500)),
                              Text('Taille: ${taille(patientInfo['taille'])} m',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500)),
                              Text('Poids: ${taille(patientInfo['poids'])} kg',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500)),
                              if (doctorindex != -1)
                                Text(
                                    'Médecin traitant: ${docs[doctorindex]['firstname']} ${docs[doctorindex]['name']}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500)),
                              if (doctorindex == -1)
                                const Text('Médecin traitant: Non indiqué',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500)),
                              if (patientInfo['medical_antecedents'].isNotEmpty)
                                const Text(
                                    'Antécédants médicaux et sujets de santé: ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (patientInfo['medical_antecedents'].isNotEmpty) ... [
                           const SizedBox(height: 8),
                              Wrap(
                                alignment: WrapAlignment.start,
                                spacing: 4,
                                runSpacing: 4,
                                children: [
                                    for (var i = 0; i < patientInfo['medical_antecedents'].length; i++)
                                      if (i < 3)
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return IntrinsicWidth(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (patientInfo['medical_antecedents'].isNotEmpty) {
                                                    final model = Provider.of<BottomSheetModel>(
                                                        context,
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
                                                                SubMenuMedicalFolder(
                                                                  medicalAntecedent:
                                                                      patientInfo['medical_antecedents'][i],
                                                                  deleteAntecedent: () {
                                                                    setState(() {
                                                                      deleteMedicalAntecedent(
                                                                          patientInfo['medical_antecedents'][i]
                                                                              ["id"],
                                                                          context);
                                                                    });
                                                                  },
                                                                  refresh: () {
                                                                    refresh();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                child: CardTraitementSmall(
                                                  name: patientInfo['medical_antecedents'][i]['name'],
                                                  isEnCours:
                                                      patientInfo['medical_antecedents'][i]['treatments'].isEmpty
                                                          ? false
                                                          : true,
                                                ),
                                              ),
                                            );
                                          },
                                        ),],
                              )
                          ],
                          const SizedBox(
                            height: 16,
                          ),
                          Buttons(
                            variant: Variant.primary,
                            size: SizeButton.md,
                            msg: const Text('Modifier le dossier médical'),
                            onPressed: () {
                              pageIndex.value = 0;
                              final model = Provider.of<BottomSheetModel>(
                                  context,
                                  listen: false);
                              model.resetCurrentIndex();
                              tmpInfo = Map.of(patientInfo);
                              tmpTraitments = [];
                              pageIndex.value = 0;

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
                                          PatientAdd(
                                              info: tmpInfo,
                                              model: model),
                                          PatientAdd2(
                                              model: model,
                                              context: context,
                                              tmpInfo: tmpInfo,
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
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue700),
                strokeWidth: 2.0,
              ),
            );
          }
        });
  }

  Widget navigationPatient(BuildContext context, Map<String, dynamic> patient,
      Function setPages, Function setId) {
    return ModalContainer(
      title: '${patient['Prenom']} ${patient['Nom']}',
      subtitle: "Séléctionner une catégorie",
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

// ignore: must_be_immutable
class PatientAdd extends StatefulWidget {
  Map<String, dynamic> info;
  BottomSheetModel model;
  PatientAdd({super.key, required this.info, required this.model});

  @override
  State<PatientAdd> createState() => _PatientAddState();
}

class _PatientAddState extends State<PatientAdd> {
  ValueNotifier<int> selected = ValueNotifier(0);

  void updateSelection(int newSelection) {
    selected.value = newSelection;
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Mise à jour des informations",
      subtitle: "Mettez à jour les informations du patient",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.postcard_heart_fill,
          color: AppColors.grey700,
          size: 18,
        ),
        type: ModalType.info,
      ),
      footer: Row(
        children: [
          Flexible(
            child: Buttons(
              variant: Variant.secondary,
              size: SizeButton.sm,
              msg: const Text('Annuler'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: Buttons(
              variant: Variant.primary,
              size: SizeButton.sm,
              msg: const Text('Continuer'),
              onPressed: () {
                if (widget.info['Prenom'] == "" ||
                    widget.info['Nom'] == "" ||
                    widget.info['date_de_naissance'] == "" ||
                    widget.info['sexe'] == "" ||
                    widget.info['taille'] == "" ||
                    widget.info['poids'] == "") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    ErrorSnackBar(
                      message: "Veuillez remplir tous les champs",
                      context: context,
                    ),
                  );
                } else {
                  switch (selected.value) {
                    case 0:
                      widget.info['sexe'] = "MALE";
                      break;
                    case 1:
                      widget.info['sexe'] = "FEMALE";
                      break;
                    case 2:
                      widget.info['sexe'] = "OTHER";
                      break;
                    default:
                  }
                  widget.model.changePage(1);
                }
              },
            ),
          ),
        ],
      ),
      body: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.23,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.blue700,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.23,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.blue200,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.23,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.blue200,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Prénom",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomPreloadField(
              startUppercase: true,
              label: "Prénom",
              text: widget.info['Prenom'],
              onChanged: (value) => widget.info['Prenom'] = value,
              isPassword: false,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Nom",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomPreloadField(
              startUppercase: true,
              label: "Nom",
              text: widget.info['Nom'],
              onChanged: (value) => widget.info['Nom'] = value,
              isPassword: false,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Date de naissance",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 4,
            ),
            CustomDatePiker(
              onChanged: (value) => widget.info['date_de_naissance'] = value,
              endDate: DateTime.now(),
              placeholder: widget.info['date_de_naissance'],
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Sexe",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            ValueListenableBuilder<int>(
              valueListenable: selected,
              builder: (context, value, child) {
                return Row(
                  children: [
                    AddButton(
                        onTap: () => updateSelection(0),
                        label: "Masculin",
                        color:
                            value == 0 ? AppColors.blue700 : AppColors.white),
                    const SizedBox(
                      width: 16,
                    ),
                    AddButton(
                        onTap: () => updateSelection(1),
                        label: "Féminin",
                        color:
                            value == 1 ? AppColors.blue700 : AppColors.white),
                    const SizedBox(
                      width: 16,
                    ),
                    AddButton(
                        onTap: () => updateSelection(2),
                        label: "Autre",
                        color:
                            value == 2 ? AppColors.blue700 : AppColors.white),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Taille",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomPreloadField(
                        startUppercase: false,
                        text: (double.parse(widget.info['taille']) / 100).toString(),
                        label: "1,52m",
                        onChanged: (value) => widget.info['taille'] =
                            (double.parse(value.replaceAll(',', '.')) * 100)
                                .toString(),
                        keyboardType: TextInputType.number,
                        isPassword: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 32,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Poids",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomPreloadField(
                        startUppercase: false,
                        label: "45kg",
                        text: (double.parse(widget.info['poids']) / 100).toString(),
                        onChanged: (value) => widget.info['poids'] =
                            (double.parse(value.replaceAll(',', '.')) * 100)
                                .toString(),
                        keyboardType: TextInputType.number,
                        isPassword: false,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class PatientAdd2 extends StatefulWidget {
  final BottomSheetModel model;
  final BuildContext context;
  final Map<String, dynamic> tmpInfo;
  final Function refresh;
  const PatientAdd2({
    super.key,
    required this.model,
    required this.context,
    required this.tmpInfo,
    required this.refresh,
  });

  @override
  PatientAdd2State createState() => PatientAdd2State();
}

class PatientAdd2State extends State<PatientAdd2> {
  int selectedDoctor = -1;
  List<dynamic> docs = [];
  Future? _fetchDocsFuture;
  String nameFilter = "";

  @override
  void initState() {
    super.initState();
    _fetchDocsFuture = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    var tmp = await getAllDoctor(context);
    setState(() {
      docs = tmp;
    });
    if (widget.tmpInfo['medecin_traitant'] != "") {
      updateSelectedDoctor(docs.indexWhere(
          (doc) => doc['id'] == widget.tmpInfo['medecin_traitant']));
    }
    return docs;
  }

  void updateSelectedDoctor(int index) {
    setState(() {
      selectedDoctor = index;
    });
  }

  int getDoctor() {
    return selectedDoctor;
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Mise à jout des informations",
      subtitle: "Mettez à jour les informations du patient",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.postcard_heart_fill,
          color: AppColors.grey700,
          size: 18,
        ),
        type: ModalType.info,
      ),
      footer: Row(
        children: [
          Flexible(
            child: Buttons(
              variant: Variant.secondary,
              size: SizeButton.sm,
              msg: const Text('Précedent'),
              onPressed: () {
                widget.model.changePage(0);
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: Buttons(
              variant: Variant.primary,
              size: SizeButton.sm,
              msg: const Text('Continuer'),
              onPressed: () {
                if (getDoctor() != -1) {
                  String day =
                    widget.tmpInfo['date_de_naissance']?.substring(0, 2) ??
                        '00';
                String month =
                    widget.tmpInfo['date_de_naissance']?.substring(3, 5) ??
                        '00';
                String year =
                    widget.tmpInfo['date_de_naissance']?.substring(6, 10) ??
                        '0000';
                int date = DateTime.parse('$year-$month-$day')
                        .millisecondsSinceEpoch ~/
                    1000;
                  Map<String, dynamic>body = {
                    "name": widget.tmpInfo['Nom'],
                    "firstname": widget.tmpInfo['Prenom'],
                    "birthdate": date,
                    "sex": widget.tmpInfo['sexe'],
                    "weight": int.parse(widget.tmpInfo['taille']),
                    "height": int.parse(widget.tmpInfo['poids']),
                    "primary_doctor_id": widget.tmpInfo['medecin_traitant'],
                    "family_members_med_info_id": [],
                  };
                  putInformationPatient(context, body, widget.tmpInfo['id']).then((value) {
                    if (value == true) {
                      widget.refresh();
                      Navigator.pop(context);
                      TopSuccessSnackBar(message: "Modification appliqué avec succès").show(context);
                    } else {
                      TopErrorSnackBar(
                        message: "Erreur lors de la modification",
                      ).show(context);
                    }
                  });
                } else {
                  TopErrorSnackBar(
                    message: "Veuillez selectionner un médecin traitant",
                  ).show(context);
                }
              },
            ),
          ),
        ],
      ),
      body: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                height: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.blue700,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Flexible(
              child: Container(
                height: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.blue700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Nom du médecin traitant',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(height: 8),
        CustomFieldSearch(
          label: 'Docteur Edgar',
          icon: SvgPicture.asset("assets/images/utils/search.svg"),
          keyboardType: TextInputType.name,
          onValidate: (value) {
            setState(() {
              nameFilter = value;
            });
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: FutureBuilder(
            future: _fetchDocsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text("Erreur lors du chargement des données"));
              } else if (snapshot.hasData) {
                // Filtrer les docs basés sur nameFilter
                var filteredDocs = docs.where((doc) {
                  return doc['name']
                      .toLowerCase()
                      .contains(nameFilter.toLowerCase());
                }).toList();

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    var doc = filteredDocs[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return CardDoctor(
                            name: doc['name'] == ""
                                ? "Docteur Edgar"
                                : "Docteur ${doc['name']}",
                            street: doc['address']['street'] == ""
                                ? "1 rue de la paix"
                                : doc['address']['street'],
                            city: doc['address']['city'] == ""
                                ? "Paris"
                                : doc['address']['city'],
                            zipCode: doc['address']['zip_code'] == ""
                                ? "75000"
                                : doc['address']['zip_code'],
                            selected: index == getDoctor() ? true : false,
                            onclick: () {
                              setState(() {
                                if (getDoctor() == index) {
                                  updateSelectedDoctor(-1);
                                  widget.tmpInfo['medecin_traitant'] = "";
                                } else {
                                  updateSelectedDoctor(index);
                                }
                                if (getDoctor() != -1) {
                                  widget.tmpInfo['medecin_traitant'] =
                                      doc['id'];
                                }
                              });
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text("Aucune donnée disponible"));
              }
            },
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class SubMenuMedicalFolder extends StatelessWidget {
  Map<String, dynamic> medicalAntecedent;
  final Function deleteAntecedent;
  final Function refresh;
  SubMenuMedicalFolder(
      {super.key,
      required this.medicalAntecedent,
      required this.deleteAntecedent,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      body: [
        Text(
          medicalAntecedent['name'],
          style: const TextStyle(
              fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Container(
          color: AppColors.blue100,
          height: 1,
        ),
        NavbarPLusTab(
          title: 'Consulter les traitements',
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
                        ModalInfoAntecedent(
                            medicalAntecedent: medicalAntecedent)
                      ],
                    );
                  },
                );
              },
            );
          },
          type: 'Only',
          icon: const Icon(
            BootstrapIcons.bandaid_fill,
            color: AppColors.blue800,
            size: 16,
          ),
        ),
      ],
    );
  }
}