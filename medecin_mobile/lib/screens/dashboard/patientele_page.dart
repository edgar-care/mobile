// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/doctor_services.dart';
import 'package:edgar_pro/services/medecines_services.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/widgets/card_doctor.dart';
import 'package:edgar_pro/widgets/card_traitement_day.dart';
import 'package:edgar_pro/widgets/card_traitement_small.dart';
import 'package:edgar_pro/widgets/custom_date_picker.dart';
import 'package:edgar_pro/widgets/login_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/AddPatient/add_button.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_patient_list.dart';
import 'package:edgar_pro/widgets/field_custom.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

String name = "";
String lastname = "";
String birthdate = "";
String sexe = "MALE";
String height = "";
String weight = "";
String primaryDoctorId = "";
bool isHealths = false;

// ignore: must_be_immutable
class Patient extends StatefulWidget {
  Function setPages;
  Function setId;
  Patient({super.key, required this.setPages, required this.setId});

  @override
  // ignore: library_private_types_in_public_api
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  ValueNotifier<Map<String, dynamic>> info = ValueNotifier({
    'email': '',
    'prenom': '',
    'nom': '',
    'date': '',
    'sexe': '',
    'taille': '',
    'poids': '',
    'medecin_traitant': '',
    'medical_antecedents': [],
  });

  ValueNotifier<int> selected = ValueNotifier(0);
  var pageindex = ValueNotifier(0);

  void updateModalIndex(int index) {
    pageindex.value = index;
  }

  void updateSelection(int newSelection) {
    selected.value = newSelection;
  }

  List<Map<String, dynamic>> patients = [];

  Future<void> _loadInfo() async {
    patients = await getAllPatientId();
  }

  void refresh() {
    setState(() {
      _loadInfo();
    });
  }

  void deletePatientList(String id) {
    setState(() {
      for (int i = 0; i < patients.length; i++) {
        if (patients[i]['id'] == id) {
          patients.removeAt(i);
        }
      }
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      refresh();
    });
  }

  void updatePatient(Map<String, dynamic> patient, String id) {
    setState(() {
      for (int i = 0; i < patients.length; i++) {
        if (patients[i]['id'] == id) {
          patients[i] = patient;
        }
      }
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          key: const ValueKey("Header"),
          decoration: BoxDecoration(
            color: AppColors.blue700,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                "Ma patientèle",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: AppColors.white),
              ),
            ]),
          ),
        ),
        const SizedBox(
          height: 8,
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
                    FutureBuilder(
                      future: _loadInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return CustomList(
                            deletePatientList: deletePatientList,
                            setId: widget.setId,
                            setPages: widget.setPages,
                            patients: patients,
                            updatePatient: updatePatient,
                          );
                        } else {
                          return const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.blue700),
                                strokeWidth: 2.0,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    Buttons(
                      variant: Variante.primary,
                      size: SizeButton.md,
                      msg: const Text('Ajouter un patient +'),
                      onPressed: () {
                        WoltModalSheet.show<void>(
                            context: context,
                            pageIndexNotifier: pageindex,
                            pageListBuilder: (modalSheetContext) {
                              return [
                                addPatient(context, pageindex),
                                addPatient2(updateModalIndex, context),
                                addPatient3(updateModalIndex, context)
                              ];
                            });
                      },
                    ),
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  SliverWoltModalSheetPage addPatient(
      BuildContext context, ValueNotifier<int> pageIndexNotifier) {
    return WoltModalSheetPage(
      hasTopBarLayer: false,
      backgroundColor: AppColors.white,
      hasSabGradient: true,
      enableDrag: true,
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
        child: Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          spacing: 12,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              child: Buttons(
                variant: Variante.secondary,
                size: SizeButton.sm,
                msg: const Text('Annuler'),
                onPressed: () {
                  Navigator.pop(context);
                  pageIndexNotifier.value = 0;
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              child: Buttons(
                variant: Variante.primary,
                size: SizeButton.sm,
                msg: const Text('Continuer'),
                onPressed: () {
                  switch (selected.value) {
                    case 0:
                      info.value['sexe'] = "MALE";
                      break;
                    case 1:
                      info.value['sexe'] = "FEMALE";
                      break;
                    case 2:
                      info.value['sexe'] = "OTHER";
                      break;
                    default:
                  }
                  pageIndexNotifier.value = pageIndexNotifier.value + 1;
                },
              ),
            ),
          ],
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 86),
          child: Column(children: [
            Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: AppColors.grey200,
                ),
                child: const Icon(BootstrapIcons.postcard_heart_fill,
                    color: AppColors.grey700)),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Ajoutez les informations du patient",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 8,
            ),
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
                  "Adresse mail",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomField(
                  startUppercase: false,
                  label: "prenom.nom@gmail.com",
                  onChanged: (value) => info.value['email'] = value,
                  isPassword: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Prénom",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomField(
                  startUppercase: true,
                  label: "Prénom",
                  onChanged: (value) => info.value['prenom'] = value,
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
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomField(
                  startUppercase: true,
                  label: "Nom",
                  onChanged: (value) => info.value['nom'] = value,
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
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                CustomDatePiker(
                    onChanged: (value) => info.value['date'] = value,
                    endDate: DateTime.now()),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Sexe",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
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
                            color: value == 0
                                ? AppColors.blue700
                                : AppColors.white),
                        const SizedBox(
                          width: 16,
                        ),
                        AddButton(
                            onTap: () => updateSelection(1),
                            label: "Féminin",
                            color: value == 1
                                ? AppColors.blue700
                                : AppColors.white),
                        const SizedBox(
                          width: 16,
                        ),
                        AddButton(
                            onTap: () => updateSelection(2),
                            label: "Autre",
                            color: value == 2
                                ? AppColors.blue700
                                : AppColors.white),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Taille",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomField(
                            startUppercase: false,
                            label: "1,52m",
                            onChanged: (value) => info.value['taille'] =
                                (double.parse(value) * 100).round().toString(),
                            keyboardType: TextInputType.number,
                            isPassword: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 32,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Poids",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomField(
                            startUppercase: false,
                            label: "45kg",
                            onChanged: (value) => info.value['poids'] =
                                (double.parse(value) * 100).round().toString(),
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
          ]),
        ),
      ),
    );
  }
}

SliverWoltModalSheetPage addPatient2(
    final Function(int) updateSelectedIndex, BuildContext context) {
  int selectedDoctor = -1;

  void updateSelectedDoctor(int index) {
    selectedDoctor = index;
  }

  int getDoctor() {
    return selectedDoctor;
  }

  return WoltModalSheetPage(
    backgroundColor: AppColors.white,
    hasTopBarLayer: false,
    stickyActionBar: Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        spacing: 12,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.43,
            child: Buttons(
              variant: Variante.secondary,
              size: SizeButton.sm,
              msg: const Text('Précedent'),
              onPressed: () {
                updateSelectedIndex(0);
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.43,
            child: Buttons(
              variant: Variante.primary,
              size: SizeButton.sm,
              msg: const Text('Continuer'),
              onPressed: () {
                if (getDoctor() != -1) {
                  updateSelectedIndex(2);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    ErrorLoginSnackBar(
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
    ),
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 86),
        child: Column(children: [
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: AppColors.grey200,
              ),
              child: const Icon(BootstrapIcons.postcard_heart_fill,
                  color: AppColors.grey700)),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "Ajoutez les informations du patient",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 8,
          ),
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
                  color: AppColors.blue200,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Body2(
            updateSelectedIndex: updateSelectedIndex,
            getDoctor: getDoctor,
            setDoctor: updateSelectedDoctor,
          ),
        ]),
      ),
    ),
  );
}

SliverWoltModalSheetPage addPatient3(
    final Function(int) updateSelectedIndex, BuildContext context) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(children: [
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: AppColors.grey200,
              ),
              child: const Icon(BootstrapIcons.postcard_heart_fill,
                  color: AppColors.grey700)),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "Ajoutez les informations du patient",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 8,
          ),
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
          Body3(
            updateSelectedIndex: updateSelectedIndex,
          ),
        ]),
      ),
    ),
  );
}

class Body2 extends StatefulWidget {
  final Function(int) updateSelectedIndex;
  final Function getDoctor;
  final Function setDoctor;
  const Body2(
      {required this.updateSelectedIndex,
      super.key,
      required this.getDoctor,
      required this.setDoctor});

  @override
  State<Body2> createState() => _onboarding2State();
}

// ignore: camel_case_types
class _onboarding2State extends State<Body2> {
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
    if (primaryDoctorId != "") {
      widget.setDoctor(docs.indexWhere((doc) => doc['id'] == primaryDoctorId));
    }
    return docs;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 204,
      child: Column(
        children: [
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
                              selected:
                                  index == widget.getDoctor() ? true : false,
                              onclick: () {
                                setState(() {
                                  if (widget.getDoctor() == index) {
                                    widget.setDoctor(-1);
                                    primaryDoctorId = "";
                                  } else {
                                    widget.setDoctor(index);
                                  }
                                  if (widget.getDoctor() != -1) {
                                    primaryDoctorId = doc['id'];
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
      ),
    );
  }
}

class Body3 extends StatefulWidget {
  final Function(int) updateSelectedIndex;

  const Body3({
    super.key,
    required this.updateSelectedIndex,
  });

  @override
  State<Body3> createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Body3> {
  final ValueNotifier<int> pageIndex = ValueNotifier(0);

  void updateData(int index) {
    setState(() {
      pageIndex.value = index;
    });
  }

  List<Map<String, dynamic>> traitments = [];

  void addNewTraitement(
      String name, Map<String, dynamic> medicines, bool stillRelevant) {
    setState(() {
      traitments.add({
        "name": name,
        "treatments": medicines["treatments"],
        "still_relevant": stillRelevant,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        "Vos antécédents médicaux et sujets de santé",
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: () {
          WoltModalSheet.show<void>(
            context: context,
            pageIndexNotifier: pageIndex,
            pageListBuilder: (modalSheetContext) {
              return [
                addTraitement(
                  context,
                  pageIndex,
                  updateData,
                  addNewTraitement,
                ),
              ];
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
          fontWeight: FontWeight.w700,
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
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    if (traitments.isNotEmpty)
                      for (var i = 0; i < traitments.length; i++)
                        if (i < 3)
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return IntrinsicWidth(
                                child: GestureDetector(
                                  onTap: () {
                                    if (traitments[i]['treatments']
                                        .isNotEmpty) {
                                      WoltModalSheet.show<void>(
                                        context: context,
                                        pageIndexNotifier: pageIndex,
                                        pageListBuilder: (modalSheetContext) {
                                          return [
                                            infoTraitement(
                                              context,
                                              pageIndex,
                                              updateData,
                                              traitments[i],
                                            ),
                                          ];
                                        },
                                      );
                                    }
                                  },
                                  child: CardTraitementSmall(
                                    name: traitments[i]['name'],
                                    isEnCours:
                                        traitments[i]['treatments'].isEmpty
                                            ? false
                                            : true,
                                    onTap: () {
                                      setState(() {
                                        traitments.removeAt(i);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      const SizedBox(height: 16),
      Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        spacing: 12,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.42,
            child: Buttons(
              variant: Variante.secondary,
              size: SizeButton.sm,
              msg: const Text('Revenir en arrière'),
              onPressed: () {
                widget.updateSelectedIndex(1);
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.42,
            child: Buttons(
              variant: Variante.validate,
              size: SizeButton.sm,
              msg: const Text('Confirmer'),
              onPressed: () async {
                if (traitments.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
                      message: "Ajouter des informations", context: context));
                  return;
                }
                List<String> parts = birthdate.split('/');
                String americanDate = '${parts[2]}-${parts[1]}-${parts[0]}';
                final birth = DateTime.parse(americanDate);
                final integerDate =
                    (birth.millisecondsSinceEpoch / 1000).round();

                final Map<String, Object> body = {
                  "name": name,
                  "firstname": lastname,
                  "birthdate": integerDate,
                  "sex": sexe,
                  "weight": int.parse(weight) * 100,
                  "height": int.parse(height),
                  "primary_doctor_id": primaryDoctorId,
                  "medical_antecedents": traitments,
                };

                var reponse = await addPatientService(context, body);
                if (reponse == true) {
                  widget.updateSelectedIndex(3);
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
                      message: "Erreur lors de l'ajout des informations",
                      // ignore: use_build_context_synchronously
                      context: context));
                }

                widget.updateSelectedIndex(3);
              },
            ),
          ),
        ],
      ),
    ]);
  }
}

WoltModalSheetPage infoTraitement(
  BuildContext context,
  ValueNotifier<int> pageIndex,
  Function(int) updateData,
  Map<String, dynamic> traitement,
) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: BodyInfoModal(
          pageIndex: pageIndex,
          updateData: updateData,
          traitement: traitement,
        ),
      ),
    ),
  );
}

// ignore: must_be_immutable
class BodyInfoModal extends StatefulWidget {
  ValueNotifier<int> pageIndex;
  Function(int) updateData;
  Map<String, dynamic> traitement;
  BodyInfoModal(
      {super.key,
      required this.pageIndex,
      required this.updateData,
      required this.traitement});

  @override
  State<BodyInfoModal> createState() => _BodyInfoModalState();
}

class _BodyInfoModalState extends State<BodyInfoModal> {
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
      Logger().e("Error fetching data: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isHealth =
        ValueNotifier(widget.traitement['still_relevant']);

    Logger().d(widget.traitement);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              color: AppColors.blue50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.blue200,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/utils/Union.svg',
                  width: 16,
                  height: 16,
                  // ignore: deprecated_member_use
                  color: widget.traitement['treatments'].isEmpty
                      ? AppColors.grey300
                      : AppColors.blue700,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.traitement['name'],
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )),
        const SizedBox(height: 12),
        const Text(
          'Le sujet de santé est toujours en cours ?',
          style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
        ),
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
        const SizedBox(height: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.55,
          child: FutureBuilder<bool>(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
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

WoltModalSheetPage addTraitement(
  BuildContext context,
  ValueNotifier<int> pageIndex,
  Function(int) updateData,
  Function addNewTraitement,
) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: BodyAddTraitement(
          pageIndex: pageIndex,
          updateData: updateData,
          addNewTraitement: addNewTraitement,
          screenSize: MediaQuery.of(context).size,
        ),
      ),
    ),
  );
}

class BodyAddTraitement extends StatefulWidget {
  final ValueNotifier<int> pageIndex;
  final Function(int) updateData;
  final Function addNewTraitement;
  final Size screenSize;
  const BodyAddTraitement(
      {super.key,
      required this.pageIndex,
      required this.updateData,
      required this.addNewTraitement,
      required this.screenSize});

  @override
  State<BodyAddTraitement> createState() => _BodyAddTraitementState();
}

class _BodyAddTraitementState extends State<BodyAddTraitement> {
  String name = "";
  bool stillRelevant = false;

  Map<String, dynamic> medicines = {"treatments": [], "name": "Parasetamole"};

  @override
  void initState() {
    super.initState();
    setState(() {
      medicines = {"treatments": [], "name": name};
    });
  }

  List<Map<String, dynamic>> medicaments = [];
  List<String> medNames = [];

  void updateMedicament(Map<String, dynamic> medicament) async {
    setState(() {
      medicines['treatments'].add(medicament);
    });
    fetchData();
  }

  Future<bool> fetchData() async {
    medicaments = await getMedecines();
    medNames.clear(); // Effacer la liste existante pour éviter les doublons

    for (var treatment in medicines['treatments']) {
      var medId = treatment['medicine_id'];
      var med = medicaments.firstWhere((med) => med['id'] == medId,
          orElse: () => {'name': ''});
      var medName = med['name'];
      medNames.add(medName);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.green200,
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.all(16),
          child: SvgPicture.asset(
            'assets/images/utils/Subtract.svg',
            // ignore: deprecated_member_use
            color: AppColors.green700,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Ajoutez un sujet de santé',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 32),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              startUppercase: false,
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
                        color: value == true
                            ? AppColors.blue700
                            : Colors.transparent),
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
                WoltModalSheet.show<void>(
                    context: context,
                    pageIndexNotifier: widget.pageIndex,
                    pageListBuilder: (modalSheetContext) {
                      return [
                        addMedicament(
                          context,
                          widget.pageIndex,
                          widget.updateData,
                          widget.addNewTraitement,
                          updateMedicament,
                        ),
                      ];
                    });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
            SizedBox(
              height: widget.screenSize.height * 0.36,
              width: widget.screenSize.width,
              child: FutureBuilder(
                future: fetchData(), // Simulate some async operation
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: medicines['treatments'].length,
                      itemBuilder: (context, index) {
                        if (medicines['treatments'].isEmpty) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: CardTraitementDay(
                            isClickable: true,
                            data: medicines['treatments'][index],
                            name: medNames[index],
                            onTap: () {
                              setState(() {
                                medicines['treatments'].removeAt(index);
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
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Buttons(
                  variant: Variante.secondary,
                  size: SizeButton.sm,
                  msg: const Text("Annuler"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Buttons(
                  variant: Variante.validate,
                  size: SizeButton.sm,
                  msg: const Text("Ajouter"),
                  onPressed: () {
                    if (name == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          ErrorLoginSnackBar(
                              message: "Ajoutez un nom", context: context));
                      return;
                    }
                    widget.addNewTraitement(name, medicines, stillRelevant);
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      ],
    );
  }
}

WoltModalSheetPage addMedicament(
  BuildContext context,
  ValueNotifier<int> pageIndex,
  Function(int) updateData,
  Function addNewTraitement,
  Function(Map<String, dynamic>) updateMedicaments,
) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: BodyAddMedic(
            updateData: updateData, updateMedicament: updateMedicaments),
      ),
    ),
  );
}

// ignore: must_be_immutable
class BodyAddMedic extends StatefulWidget {
  Function(int) updateData;
  Function(Map<String, dynamic>) updateMedicament;

  BodyAddMedic(
      {super.key, required this.updateData, required this.updateMedicament});

  @override
  State<BodyAddMedic> createState() => _BodyAddMedicState();
}

class _BodyAddMedicState extends State<BodyAddMedic> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.green200,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(16),
              child: SvgPicture.asset(
                'assets/images/utils/Union-lg.svg',
                // ignore: deprecated_member_use
                color: AppColors.green700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ajouter un médicament',
              style: TextStyle(
                color: AppColors.black,
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
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
                startUppercase: false,
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
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Buttons(
                  variant: Variante.secondary,
                  size: SizeButton.sm,
                  msg: const Text("Annuler"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Buttons(
                  variant: Variante.validate,
                  size: SizeButton.sm,
                  msg: const Text("Ajouter"),
                  onPressed: () {
                    if (medicament['medicine_id'].isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
                          message:
                              "Veuillez choisir un médicament ou entrer un medicament valide",
                          context: context));
                      return;
                    }
                    if (medicament['quantity'] == 0 ||
                        medicament['day'].isEmpty ||
                        medicament['period'].isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          ErrorLoginSnackBar(
                              message: "Veuillez remplir tous les champs",
                              context: context));
                      return;
                    }
                    setState(() {
                      widget.updateMedicament(medicament);
                    });
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      ],
    );
  }
}
