// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/doctor_services.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/utils/treatment_utils.dart';
import 'package:edgar_pro/widgets/card_doctor.dart';
import 'package:edgar_pro/widgets/card_traitement_small.dart';
import 'package:edgar_pro/widgets/navbarplus.dart';
import 'package:edgar_pro/widgets/treatment_modal.dart';
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
              placeholder: birthdate == ""
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

  List<Map<String, dynamic>> medicalAntecedents = [];
  void addMedicalAntecedents(String name, List<Treatment> treatments) {
    setState(() {
      medicalAntecedents.add({
        "name": name,
        "symptoms": [],
        "treatments": treatments,
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
        Body3(refresh: widget.refresh,
            medicalAntecedents: medicalAntecedents,
            addMedicalAntecedents: addMedicalAntecedents,
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
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(InfoSnackBar(
                    message: "Envoi en cours...", context: context));
                List<String> parts = birthdate.split('/');
                String americanDate = '${parts[2]}-${parts[1]}-${parts[0]}';
                final birth = DateTime.parse(americanDate);
                final integerDate =
                    (birth.millisecondsSinceEpoch / 1000).round();
                  List<Map<String, dynamic>> medicaljson = [];
                for (var element in medicalAntecedents){
                  medicaljson.add({
                    "name": element['name'],
                    "symptoms": element['symptoms'],
                    "treatments": element['treatments'].map((e) => e.toJson()).toList(),
                  });
                }
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
                    "medical_antecedents": medicaljson,
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
  List<Map<String, dynamic>> medicalAntecedents;
  final Function addMedicalAntecedents;
  Body3({
    super.key,
    required this.refresh,
    required this.medicalAntecedents,
    required this.addMedicalAntecedents,
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
                      ModalTreamentInfo(addMedicalAntecedents: widget.addMedicalAntecedents),
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
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            if (widget.medicalAntecedents.isNotEmpty)
                              for (var i = 0; i < widget.medicalAntecedents.length; i++)
                                if (i < 3)
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return IntrinsicWidth(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (widget.medicalAntecedents.isNotEmpty) {
                                              final model =
                                                  Provider.of<BottomSheetModel>(
                                                      context,
                                                      listen: false);
                                              model.resetCurrentIndex();
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) {
                                                  return Consumer<
                                                      BottomSheetModel>(
                                                    builder: (context, model,
                                                        child) {
                                                      return ListModal(
                                                        model: model,
                                                        children: [
                                                          SubMenu(medicalAntecedent: widget.medicalAntecedents[i],
                                                            deleteAntecedent: (){
                                                              setState(() {
                                                                widget.medicalAntecedents.removeAt(i);
                                                              });
                                                            },
                                                            refresh: (){
                                                              setState(() {
                                                                widget.medicalAntecedents = widget.medicalAntecedents;
                                                              });
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
                                            name: widget.medicalAntecedents[i]['name'],
                                            isEnCours: widget.medicalAntecedents[i]
                                                        ['treatments']
                                                    .isEmpty
                                                ? false
                                                : true,
                                            onTap: () {
                                              widget.medicalAntecedents.remove(widget.medicalAntecedents[i]);
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
class SubMenu extends StatelessWidget {
  Map<String, dynamic> medicalAntecedent;
  final Function deleteAntecedent;
  final Function refresh;
  SubMenu({super.key, required this.medicalAntecedent, required this.deleteAntecedent, required this.refresh});

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
            final model =
              Provider.of<BottomSheetModel>(
                  context,
                  listen: false);
            model.resetCurrentIndex();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor:
                  Colors.transparent,
              builder: (context) {
                return Consumer<
                    BottomSheetModel>(
                  builder: (context, model,
                      child) {
                    return ListModal(
                      model: model,
                      children: [
                        ModalInfoAntecedent(medicalAntecedent: medicalAntecedent)                                       
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
        Container(
          color: AppColors.blue100,
          height: 1,
        ),
        NavbarPLusTab(
          title: 'Supprimer mon sujet de santé',
          color: AppColors.red700,
          onTap: () {
            deleteAntecedent();
            refresh();
            Navigator.pop(context);
          },
          type: 'Only',
          icon: const Icon(
            BootstrapIcons.trash_fill,
            color: AppColors.red700,
            size: 16,
          ),
        ),
      ],
    );
  }
}