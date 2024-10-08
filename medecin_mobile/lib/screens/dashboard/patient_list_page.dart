// ignore_for_file: use_build_context_synchronously

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/doctor_services.dart';
import 'package:edgar_pro/services/medecines_services.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar/colors.dart';
import 'package:edgar_pro/widgets/AddPatient/add_button.dart';
import 'package:edgar_pro/widgets/AddPatient/custom_preload_field.dart';
import 'package:edgar_pro/widgets/card_doctor.dart';
import 'package:edgar_pro/widgets/card_traitement_day.dart';
import 'package:edgar_pro/widgets/card_traitement_small.dart';
import 'package:edgar_pro/widgets/custom_nav_patient_card.dart';
import 'package:edgar_pro/widgets/custom_patient_card_info.dart';
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
  List<Map<String, dynamic>> tmpTraitments = [];
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
    patientInfo = await getPatientById(widget.id);
    docs = await getAllDoctor();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
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
                          if (patientInfo['medical_antecedents'].isNotEmpty)
                            Expanded(
                              child: PatientInfoCard(
                                  context: context,
                                  tmpTraitments:
                                      patientInfo['medical_antecedents']),
                            ),
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
                                          patientAdd(context, model, tmpInfo),
                                          PatientAdd2(
                                              model: model,
                                              context: context,
                                              tmpInfo: tmpInfo),
                                          PatientAdd3(
                                              model: model,
                                              context: context,
                                              traitments: tmpTraitments,
                                              tmpInfo: tmpInfo)
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
            text: 'Messagerie',
            icon: BootstrapIcons.chat_dots_fill,
            setPages: setPages,
            pageTo: 9,
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
            setPages(1);
            Navigator.pop(context);
          }),
    );
  }

  Widget patientAdd(
      BuildContext context, BottomSheetModel model, Map<String, dynamic> info) {
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
              msg: const Text('Annuler'),
              onPressed: () {
                tmpInfo = Map.of(patientInfo);
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
                if (info['Prenom'] == "" ||
                    info['Nom'] == "" ||
                    info['date_de_naissance'] == "" ||
                    info['sexe'] == "" ||
                    info['taille'] == "" ||
                    info['poids'] == "") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    ErrorSnackBar(
                      message: "Veuillez remplir tous les champs",
                      context: context,
                    ),
                  );
                } else {
                  switch (selected.value) {
                    case 0:
                      info['sexe'] = "MALE";
                      break;
                    case 1:
                      info['sexe'] = "FEMALE";
                      break;
                    case 2:
                      info['sexe'] = "OTHER";
                      break;
                    default:
                  }
                  model.changePage(1);
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
              text: info['Prenom'],
              onChanged: (value) => info['Prenom'] = value,
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
              text: info['Nom'],
              onChanged: (value) => info['Nom'] = value,
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
              onChanged: (value) => info['date_de_naissance'] = value,
              endDate: DateTime.now(),
              value: info['date_de_naissance'],
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
                        text: (double.parse(info['taille']) / 100).toString(),
                        label: "1,52m",
                        onChanged: (value) => info['taille'] =
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
                        text: (double.parse(info['poids']) / 100).toString(),
                        onChanged: (value) => info['poids'] =
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

  const PatientAdd2({
    super.key,
    required this.model,
    required this.context,
    required this.tmpInfo,
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
    var tmp = await getAllDoctor();
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
                  widget.model.changePage(2);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    ErrorSnackBar(
                      message: "Veuillez selectionner un médecin traitant",
                      context: context,
                    ),
                  );
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
            const SizedBox(
              width: 16,
            ),
            Flexible(
              child: Container(
                height: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.blue200,
                ),
              ),
            )
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
class PatientAdd3 extends StatefulWidget {
  BottomSheetModel model;
  final BuildContext context;
  final List<Map<String, dynamic>> traitments;
  Map<String, dynamic> tmpInfo;

  PatientAdd3(
      {super.key,
      required this.model,
      required this.context,
      required this.traitments,
      required this.tmpInfo});

  @override
  PatientAdd3State createState() => PatientAdd3State();
}

class PatientAdd3State extends State<PatientAdd3> {
  final ValueNotifier<int> pageIndex = ValueNotifier(0);

  void updateData(int index) {
    setState(() {
      pageIndex.value = index;
    });
  }

  void addNewTraitement(
      String name, Map<String, dynamic> treatments, bool stillRelevant) {
    setState(() {
      widget.tmpInfo['medical_antecedents'].add({
        "name": name,
        "treatments": treatments["treatments"],
        "still_relevant": stillRelevant,
      });
    });
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
                color: AppColors.blue700,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        const Text(
          "Vos antécédents médicaux et sujets de santé",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            final model = Provider.of<BottomSheetModel>(context, listen: false);
            model.resetCurrentIndex();

            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) {
                return Consumer<BottomSheetModel>(
                  builder: (context, model, child) {
                    return ListModal(model: model, children: [
                      AddTreatment(addNewTraitement: addNewTraitement)
                    ]);
                  },
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.blue500, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Renseigner vos informations",
                  style: TextStyle(
                    color: AppColors.grey400,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SvgPicture.asset(
                  "assets/images/utils/plus-lg.svg",
                  // ignore: deprecated_member_use
                  color: AppColors.blue700,
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Vos antécédénts médicaux et sujets de santé renseignés",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: FutureBuilder(
            future: Future.delayed(const Duration(seconds: 0), () {
              return true;
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Expanded(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.blue700),
                      strokeWidth: 2,
                      backgroundColor: AppColors.white,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      runAlignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        if (widget.tmpInfo['medical_antecedents'].isNotEmpty)
                          for (var i = 0;
                              i < widget.tmpInfo['medical_antecedents'].length;
                              i++)
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return IntrinsicWidth(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (widget
                                          .tmpInfo['medical_antecedents'][i]
                                              ['treatments']
                                          .isEmpty) {
                                        return;
                                      }
                                      final model =
                                          Provider.of<BottomSheetModel>(context,
                                              listen: false);
                                      model.resetCurrentIndex();

                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Consumer<BottomSheetModel>(
                                            builder: (context, model, child) {
                                              return ListModal(
                                                  model: model,
                                                  children: [
                                                    InfoTreatment(
                                                        traitement: widget
                                                                .tmpInfo[
                                                            'medical_antecedents'][i])
                                                  ]);
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: CardTraitementSmall(
                                      name:
                                          widget.tmpInfo['medical_antecedents']
                                              [i]['name'],
                                      isEnCours: widget
                                              .tmpInfo['medical_antecedents'][i]
                                                  ['treatments']
                                              .isEmpty
                                          ? false
                                          : true,
                                      onTap: () {
                                        setState(
                                          () {
                                            widget
                                                .tmpInfo['medical_antecedents']
                                                .removeAt(i);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
      footer: Row(
        children: [
          Flexible(
            child: Buttons(
              variant: Variant.secondary,
              size: SizeButton.sm,
              msg: const Text('Revenir en arrière'),
              onPressed: () {
                widget.model.changePage(1);
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: Buttons(
              variant: Variant.validate,
              size: SizeButton.sm,
              msg: const Text('Confirmer'),
              onPressed: () {
                int poids = int.parse(widget.tmpInfo['poids']);
                int taille = int.parse(widget.tmpInfo['taille']);

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

                final Map<String, Object> body = {
                  "name": widget.tmpInfo['Nom'],
                  "firstname": widget.tmpInfo['Prenom'],
                  "birthdate": date,
                  "sex": widget.tmpInfo['sexe'],
                  "weight": poids,
                  "height": taille,
                  "primary_doctor_id": widget.tmpInfo['medecin_traitant'],
                  "medical_antecedents": widget.tmpInfo['medical_antecedents'],
                };
                putInformationPatient(context, body, widget.tmpInfo['id'])
                    .then((value) => {
                          if (value == true)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SuccessSnackBar(
                                      message:
                                          "Informations mises à jour avec succès",
                                      context: context)),
                              Navigator.pop(context),
                            }
                          else
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  ErrorSnackBar(
                                      message:
                                          "Erreur lors de la mises à jour des informations",
                                      context: context))
                            }
                        });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InfoTreatment extends StatefulWidget {
  final Map<String, dynamic> traitement;
  const InfoTreatment({super.key, required this.traitement});

  @override
  State<InfoTreatment> createState() => _InfoTreatmentState();
}

class _InfoTreatmentState extends State<InfoTreatment> {
  late Future<bool> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }

  List<Map<String, dynamic>> medicaments = [];

  List<String> medNames = [];

  Future<bool> fetchData() async {
    try {
      medicaments = await getMedecines();

      for (var i = 0; i < widget.traitement['treatments'].length; i++) {
        var medname = medicaments.firstWhere(
            (med) =>
                med['id'] == widget.traitement['treatments'][i]['medicine_id'],
            orElse: () => {'name': ''})['name'];
        medNames.add(medname);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isHealth =
        ValueNotifier(widget.traitement['still_relevant']);

    return ModalContainer(
      title: widget.traitement['name'],
      subtitle: "Votre traitement",
      icon: IconModal(
        icon: SvgPicture.asset(
          'assets/images/utils/Union.svg',
          width: 16,
          height: 16,
          // ignore: deprecated_member_use
          color: widget.traitement['treatments'].isEmpty
              ? AppColors.grey300
              : AppColors.blue700,
        ),
        type: ModalType.info,
      ),
      body: [
        const Text(
          'Le sujet de santé est toujours en cours ?',
          style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 4),
        ValueListenableBuilder<bool>(
          valueListenable: isHealth,
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AddButton(
                    onTap: (() {}),
                    label: "Oui",
                    color: value == true ? AppColors.blue700 : AppColors.white),
                const SizedBox(width: 8),
                AddButton(
                    onTap: (() {}),
                    label: "Non",
                    color:
                        value == false ? AppColors.blue700 : AppColors.white),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        const Text(
          'Les médicaments prescrits',
          style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: FutureBuilder<bool>(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.blue700,
                  strokeWidth: 2,
                ));
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else {
                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: widget.traitement['treatments'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return CardTraitementDay(
                              isClickable: false,
                              data: widget.traitement['treatments'][index],
                              name: medNames[index],
                              onTap: () {},
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class AddTreatment extends StatefulWidget {
  Function addNewTraitement;
  AddTreatment({super.key, required this.addNewTraitement});

  @override
  State<AddTreatment> createState() => _AddTreatmentState();
}

class _AddTreatmentState extends State<AddTreatment> {
  String name = "";
  bool stillRelevant = false;
  List<Map<String, dynamic>> medicaments = [];
  List<String> medNames = [];
  Map<String, dynamic> treatments = {"treatments": [], "name": "Parasetamole"};

  @override
  void initState() {
    super.initState();
    setState(() {
      treatments = {"treatments": [], "name": name};
    });
  }

  Future<bool> fetchData() async {
    medicaments = await getMedecines();
    medNames.clear(); // Effacer la liste existante pour éviter les doublons

    for (var treatment in treatments['treatments']) {
      var medId = treatment['medicine_id'];
      var med = medicaments.firstWhere((med) => med['id'] == medId,
          orElse: () => {'name': ''});
      var medName = med['name'];
      medNames.add(medName);
    }
    return true;
  }

  void updateMedicament(Map<String, dynamic> medicament) async {
    setState(() {
      treatments['treatments'].add(medicament);
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Ajouter un traitement",
      subtitle: "Compléter tout les champs",
      icon: IconModal(
        icon: SvgPicture.asset(
          'assets/images/utils/Subtract.svg',
          // ignore: deprecated_member_use
          color: AppColors.green700,
          width: 18,
        ),
        type: ModalType.success,
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Buttons(
                variant: Variant.secondary,
                size: SizeButton.sm,
                msg: const Text("Annuler"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Buttons(
              variant: Variant.validate,
              size: SizeButton.sm,
              msg: const Text("Ajouter"),
              onPressed: () {
                if (name == "") {
                  ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                      message: "Ajoutez un nom", context: context));
                  return;
                }
                widget.addNewTraitement(name, treatments, stillRelevant);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: [
        const Text(
          'Nom de votre sujet de santé',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        CustomField(
          label: 'Rhume',
          onChanged: (value) {
            setState(() {
              name = value.trim();
            });
          },
          keyboardType: TextInputType.name,
          action: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        const Text(
          'Le sujet de santé est-il toujours en cours ?',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<bool>(
          valueListenable: ValueNotifier(stillRelevant),
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AddButton(
                    onTap: (() {
                      setState(() {
                        stillRelevant = true;
                      });
                    }),
                    label: "Oui",
                    color:
                        value == true ? AppColors.blue700 : Colors.transparent),
                const SizedBox(width: 8),
                AddButton(
                    onTap: (() {
                      setState(() {
                        stillRelevant = false;
                      });
                    }),
                    label: "Non",
                    color: value == false
                        ? AppColors.blue700
                        : Colors.transparent),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            final model = Provider.of<BottomSheetModel>(context, listen: false);
            model.resetCurrentIndex();

            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) {
                return Consumer<BottomSheetModel>(
                  builder: (context, model, child) {
                    return ListModal(model: model, children: [
                      AddMedicament(
                          addNewTraitement: widget.addNewTraitement,
                          updateMedicaments: updateMedicament)
                    ]);
                  },
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.blue500, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Ajouter un médicament",
                  style: TextStyle(
                    color: AppColors.grey400,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SvgPicture.asset(
                  "assets/images/utils/plus-lg.svg",
                  // ignore: deprecated_member_use
                  color: AppColors.blue700,
                  width: 14,
                  height: 14,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: fetchData(), // Simulate some async operation
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: treatments['treatments'].length,
                  itemBuilder: (context, index) {
                    if (treatments['treatments'].isEmpty) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CardTraitementDay(
                        isClickable: true,
                        data: treatments['treatments'][index],
                        name: medNames[index],
                        onTap: () {
                          setState(() {
                            treatments['treatments'].removeAt(index);
                            medNames.removeAt(index);
                          });
                        },
                      ),
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

// ignore: must_be_immutable
class AddMedicament extends StatefulWidget {
  Function addNewTraitement;
  Function(Map<String, dynamic>) updateMedicaments;
  AddMedicament(
      {super.key,
      required this.addNewTraitement,
      required this.updateMedicaments});

  @override
  State<AddMedicament> createState() => _AddMedicamentState();
}

class _AddMedicamentState extends State<AddMedicament> {
  Map<String, dynamic> medicament = {
    "quantity": 0,
    "period": [],
    "day": [],
    "medicine_id": ""
  };

  List<Map<String, dynamic>> medicaments = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<String> nameMedic = [];

  Future<void> fetchData() async {
    medicaments = await getMedecines();
    for (var medicament in medicaments) {
      nameMedic.add(medicament['name']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Ajouter un médicament",
      subtitle: "Séléctionner un médicament",
      icon: IconModal(
        icon: SvgPicture.asset(
          'assets/images/utils/Union-lg.svg',
          // ignore: deprecated_member_use
          color: AppColors.green700,
          width: 18,
        ),
        type: ModalType.success,
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Buttons(
                variant: Variant.secondary,
                size: SizeButton.sm,
                msg: const Text("Annuler"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Buttons(
                variant: Variant.validate,
                size: SizeButton.sm,
                msg: const Text("Ajouter"),
                onPressed: () {
                  if (medicament['medicine_id'].isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                        message:
                            "Veuillez choisir un médicament ou entrer un medicament valide",
                        context: context));
                    return;
                  }
                  if (medicament['quantity'] == 0 ||
                      medicament['day'].isEmpty ||
                      medicament['period'].isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                        message: "Veuillez remplir tous les champs",
                        context: context));
                    return;
                  }
                  setState(() {
                    widget.updateMedicaments(medicament);
                  });
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
      body: [
        const Text(
          'Nom de votre médicament',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        CustomAutoComplete(
            label: 'Rechercher le nom du médicament ',
            icon: BootstrapIcons.search,
            keyboardType: TextInputType.name,
            onValidate: (value) {
              var selectedMedicament = medicaments.firstWhere(
                  (med) => med['name'] == value,
                  orElse: () => {'id': null});

              if (selectedMedicament['id'] != null) {
                setState(() {
                  medicament['medicine_id'] = selectedMedicament['id'];
                });
              } else {
                setState(() {
                  medicament['medicine_id'] = "";
                });
              }
            },
            suggestions: nameMedic),
        const SizedBox(height: 16),
        const Text(
          'Quantité de comprimés',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 50,
          child: CustomField(
            label: '1',
            action: TextInputAction.next,
            onChanged: (value) {
              setState(() {
                try {
                  medicament['quantity'] = int.parse(value);
                } catch (e) {
                  value = value.replaceAll(RegExp(r'[^0-9]'), '');
                  medicament['quantity'] = int.tryParse(value) ?? 0;
                }
              });
            },
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Jour de prise des médicaments',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['day'].contains('MONDAY')) {
                          medicament['day'].remove('MONDAY');
                        } else {
                          medicament['day'].add('MONDAY');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('MONDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Lu',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['day'].contains('TUESDAY')) {
                          medicament['day'].remove('TUESDAY');
                        } else {
                          medicament['day'].add('TUESDAY');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('TUESDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Ma',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['day'].contains('WEDNESDAY')) {
                          medicament['day'].remove('WEDNESDAY');
                        } else {
                          medicament['day'].add('WEDNESDAY');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('WEDNESDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Me',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['day'].contains('THURSDAY')) {
                          medicament['day'].remove('THURSDAY');
                        } else {
                          medicament['day'].add('THURSDAY');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('THURSDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Je',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['day'].contains('FRIDAY')) {
                          medicament['day'].remove('FRIDAY');
                        } else {
                          medicament['day'].add('FRIDAY');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('FRIDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Ve',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['day'].contains('SATURDAY')) {
                          medicament['day'].remove('SATURDAY');
                        } else {
                          medicament['day'].add('SATURDAY');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('SATURDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Sa',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['day'].contains('SUNDAY')) {
                          medicament['day'].remove('SUNDAY');
                        } else {
                          medicament['day'].add('SUNDAY');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('SUNDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Di',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Période de prise de la journée',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['period'].contains('MORNING')) {
                          medicament['period'].remove('MORNING');
                        } else {
                          medicament['period'].add('MORNING');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['period'].contains('MORNING')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Matin',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['period'].contains('NOON')) {
                          medicament['period'].remove('NOON');
                        } else {
                          medicament['period'].add('NOON');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['period'].contains('NOON')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Midi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['period'].contains('EVENING')) {
                          medicament['period'].remove('EVENING');
                        } else {
                          medicament['period'].add('EVENING');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['period'].contains('EVENING')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Soir',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['period'].contains('NIGHT')) {
                          medicament['period'].remove('NIGHT');
                        } else {
                          medicament['period'].add('NIGHT');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['period'].contains('NIGHT')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Nuit',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
