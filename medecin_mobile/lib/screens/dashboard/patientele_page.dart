// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/doctor_services.dart';
import 'package:edgar_pro/services/medecines_services.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/utils/medecines_utils.dart';
import 'package:edgar_pro/widgets/card_doctor.dart';
import 'package:edgar_pro/widgets/card_traitement_day.dart';
import 'package:edgar_pro/widgets/card_traitement_small.dart';
import 'package:flutter/material.dart';
import 'package:edgar/colors.dart';
import 'package:edgar_pro/widgets/AddPatient/add_button.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_pro/widgets/custom_patient_list.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

String email = "";
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
  ValueNotifier<int> selected = ValueNotifier(0);

  void updateSelection(int newSelection) {
    setState(() {
      selected.value = newSelection;
    });
  }

  List<Map<String, dynamic>> patients = [];

  Future<void> _loadInfo() async {
    patients = await getAllPatientId(context);
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
                    fontWeight: FontWeight.w600,
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
                    variant: Variant.primary,
                    size: SizeButton.md,
                    msg: const Text('Ajouter un patient +'),
                    onPressed: () {
                      email = "";
                      name = "";
                      lastname = "";
                      birthdate = "";
                      sexe = "MALE";
                      height = "";
                      weight = "";
                      primaryDoctorId = "";
                      isHealths = false;
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
                                  addPatients(model),
                                  AddPatient2(model: model),
                                  AddPatient3(refresh: refresh, model: model)
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
  }

  Widget addPatients(BottomSheetModel model) {
    return ModalContainer(
      title: "Ajouter un patient",
      subtitle: "Compléter les informations du patient",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.postcard_heart_fill,
          color: AppColors.green700,
          size: 18,
        ),
        type: ModalType.success,
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
                if (email != "" &&
                    name != "" &&
                    lastname != "" &&
                    birthdate != "" &&
                    sexe != "" &&
                    height != "" &&
                    weight != "") {
                  switch (selected.value) {
                    case 0:
                      sexe = "MALE";
                      break;
                    case 1:
                      sexe = "FEMALE";
                      break;
                    case 2:
                      sexe = "OTHER";
                      break;
                    default:
                  }
                  model.changePage(1);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    ErrorSnackBar(
                      message: "Veuillez remplir tous les champs",
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
                  color: AppColors.blue200,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Adresse mail",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomField(
              action: TextInputAction.next,
              label: "prenom.nom@gmail.com",
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
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
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomField(
              action: TextInputAction.next,
              label: "Prénom",
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
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
            CustomField(
              action: TextInputAction.next,
              label: "Nom",
              onChanged: (value) {
                setState(() {
                  lastname = value;
                });
              },
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
              label: birthdate == ""
                  ? "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}"
                  : birthdate,
              onChanged: (value) {
                setState(() {
                  birthdate = value;
                });
              },
              endDate: DateTime.now(),
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
                      CustomField(
                        action: TextInputAction.next,
                        label: "1,52m",
                        onChanged: (value) => {
                          height =
                              (double.parse(value.replaceAll(',', '.')) * 100)
                                  .round()
                                  .toString()
                        },
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
                      CustomField(
                        action: TextInputAction.next,
                        label: "45kg",
                        onChanged: (value) => weight =
                            (double.parse(value.replaceAll(',', '.')) * 100)
                                .round()
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

// ignore: must_be_immutable
class AddPatient2 extends StatefulWidget {
  BottomSheetModel model;
  AddPatient2({super.key, required this.model});

  @override
  State<AddPatient2> createState() => _AddPatient2State();
}

class _AddPatient2State extends State<AddPatient2> {
  int selectedDoctor = -1;

  void updateSelectedDoctor(int index) {
    selectedDoctor = index;
  }

  int getDoctor() {
    return selectedDoctor;
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Ajouter un patient",
      subtitle: "Compléter les informations du patient",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.postcard_heart_fill,
          color: AppColors.green700,
          size: 18,
        ),
        type: ModalType.success,
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
          getDoctor: getDoctor,
          setDoctor: updateSelectedDoctor,
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class AddPatient3 extends StatefulWidget {
  BottomSheetModel model;
  Function refresh;
  AddPatient3({super.key, required this.refresh, required this.model});

  @override
  State<AddPatient3> createState() => _AddPatient3State();
}

class _AddPatient3State extends State<AddPatient3> {
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
    return ModalContainer(
      title: "Ajouter un patient",
      subtitle: "Compléter les informations du patient",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.postcard_heart_fill,
          color: AppColors.green700,
          size: 18,
        ),
        type: ModalType.success,
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
        Body3(refresh: widget.refresh),
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
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(InfoSnackBar(
                    message: "Envoi en cours...", context: context));
                List<String> parts = birthdate.split('/');
                String americanDate = '${parts[2]}-${parts[1]}-${parts[0]}';
                final birth = DateTime.parse(americanDate);
                final integerDate =
                    (birth.millisecondsSinceEpoch / 1000).round();
                final Map<String, Object> body = {
                  "email": email,
                  "medical_info": {
                    "name": name,
                    "firstname": lastname,
                    "birthdate": integerDate,
                    "sex": sexe,
                    "weight": int.parse(weight),
                    "height": int.parse(height),
                    "primary_doctor_id": primaryDoctorId,
                    "medical_antecedents": traitments,
                    "onboarding_status": "DONE",
                  },
                };
                var reponse = await addPatientService(context, body);
                if (reponse == true) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SuccessSnackBar(
                      message: "Patient ajouté avec succès", context: context));
                  widget.refresh();
                } else {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                      message: "Erreur lors de l'ajout des informations",
                      context: context));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Body2 extends StatefulWidget {
  final Function getDoctor;
  final Function setDoctor;
  const Body2({
    super.key,
    required this.getDoctor,
    required this.setDoctor,
  });

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
    var tmp = await getAllDoctor(context);
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
    return Expanded(
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height - 290,
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
          const SizedBox(height: 8),
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

// ignore: must_be_immutable
class Body3 extends StatefulWidget {
  final Function refresh;
  const Body3({
    super.key,
    required this.refresh,
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
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return Consumer<BottomSheetModel>(
                builder: (context, model, child) {
                  return ListModal(
                    model: model,
                    children: [
                      AddTreatment(
                          addNewTraitement: addNewTraitement,
                          updateData: updateData)
                    ],
                  );
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
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
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
                                      final model =
                                          Provider.of<BottomSheetModel>(context,
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
                                                  InfoTreatment(
                                                      traitement: traitments[i],
                                                      updateData: updateData)
                                                ],
                                              );
                                            },
                                          );
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
    ]);
  }
}

// ignore: must_be_immutable
class InfoTreatment extends StatefulWidget {
  Function(int) updateData;
  Map<String, dynamic> traitement;
  InfoTreatment(
      {super.key, required this.traitement, required this.updateData});

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
      medicaments = await getMedecines(context);

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
      subtitle: "Voici le traitement",
      icon: IconModal(
        icon: SvgPicture.asset(
          'assets/images/utils/Union.svg',
          width: 18,
          height: 18,
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
        Expanded(
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

// ignore: must_be_immutable
class AddTreatment extends StatefulWidget {
  Function(int) updateData;
  Function addNewTraitement;
  AddTreatment(
      {super.key, required this.addNewTraitement, required this.updateData});

  @override
  State<AddTreatment> createState() => _AddTreatmentState();
}

class _AddTreatmentState extends State<AddTreatment> {
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
    medicaments = await getMedecines(context);
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
    return ModalContainer(
      title: "Ajouter un traitement",
      subtitle: "Séléctionner un médicament",
      icon: IconModal(
        icon: SvgPicture.asset(
          'assets/images/utils/Subtract.svg',
          // ignore: deprecated_member_use
          color: AppColors.green700,
          width: 18,
        ),
        type: ModalType.success,
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
                          updateData: widget.updateData,
                          updateMedicament: updateMedicament)
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
                  widget.addNewTraitement(name, medicines, stillRelevant);
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class AddMedicament extends StatefulWidget {
  Function(int) updateData;
  Function(Map<String, dynamic>) updateMedicament;
  AddMedicament(
      {super.key, required this.updateData, required this.updateMedicament});

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
    medicaments = await getMedecines(context);
    for (var medicament in medicaments) {
      nameMedic.add(
          "${medicament['name']} - ${displayMedicineUnit(medicament['dosage_form'])}");
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
            action: TextInputAction.next,
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
      footer: Row(
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
                    widget.updateMedicament(medicament);
                  });
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
    );
  }
}
