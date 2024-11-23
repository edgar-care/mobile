import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_app/services/auth.dart';
import 'package:edgar_app/services/doctor.dart';
import 'package:edgar_app/utils/treatement_utils.dart';
import 'package:edgar_app/widget/AddPatient/add_button.dart';
import 'package:edgar_app/widget/card_traitement_small.dart';
import 'package:edgar_app/widget/modal_treatment.dart';
import 'package:edgar_app/widget/navbarplus.dart';
import 'package:flutter/material.dart';
import 'package:edgar_app/widget/card_docteur.dart';
import 'package:flutter_svg/svg.dart';
import 'package:confetti/confetti.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:provider/provider.dart';

String name = "";
String lastname = "";
String birthdate = "";
String sexe = "MALE";
String height = "";
String weight = "";
String primaryDoctorId = "";
bool isHealths = false;

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late final List<Widget> pages;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    name = "";
    lastname = "";
    birthdate = "";
    sexe = "";
    height = "";
    weight = "";
    primaryDoctorId = "";
    isHealths = false;
  }

  _OnboardingState() {
    pages = [
      Onboarding1(
        updateSelectedIndex: updateSelectedIndex,
      ),
      Onboarding2(
        updateSelectedIndex: updateSelectedIndex,
        docteurs: const [],
      ),
      Onboarding3(
        updateSelectedIndex: updateSelectedIndex,
      ),
      const OnboardingFinish(),
    ];
  }

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            decoration: const BoxDecoration(
              color: AppColors.blue700,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(48),
                bottomRight: Radius.circular(48),
              ),
            ),
            child: IntrinsicWidth(
              child: Row(
                children: [
                  SvgPicture.asset("assets/images/logo/edgar_staying.svg"),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'J’ai besoin de vos informations personnelles afin de remplir votre espace patient',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Onboarding1 extends StatefulWidget {
  final Function(int) updateSelectedIndex;
  const Onboarding1({required this.updateSelectedIndex, super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  ValueNotifier<String> selected = ValueNotifier('Masculin');

  ValueNotifier<bool> isHealth = ValueNotifier(isHealths);

  void updateSelection(
    String value,
  ) {
    setState(() {
      selected.value = value;
      birthdate = birthdate;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr', null);
  }

  final DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 172,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: 24,
          top: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                children: [
                  Flexible(
                      child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.blue700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )),
                  const SizedBox(width: 8),
                  Flexible(
                      child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.blue200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )),
                  const SizedBox(width: 8),
                  Flexible(
                      child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.blue200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Votre prénom',
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            CustomField(
              label: 'Edgar',
              value: name,
              action: TextInputAction.next,
              onChanged: (value) => name = value.trim(),
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            const Text(
              'Votre nom',
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            CustomField(
              label: "L'assistant numerique",
              value: lastname,
              action: TextInputAction.next,
              onChanged: (value) {
                lastname = value.trim();
              },
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            const Text(
              'Votre date de naissance',
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            CustomDatePiker(
              onChanged: (value) => birthdate = value,
              placeholder: "26/09/2022",
              endDate: today,
            ),
            const SizedBox(height: 16),
            const Text(
              'Votre sexe',
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<String>(
              valueListenable: selected,
              builder: (context, value, child) {
                return Row(
                  children: [
                    AddButtonSpe(
                        onTap: () {
                          updateSelection('MALE');
                          setState(() {
                            sexe = "MALE";
                          });
                        },
                        label: "Masculin",
                        background: value == 'MALE'
                            ? AppColors.blue700
                            : AppColors.white,
                        color: value == "MALE"
                            ? AppColors.white
                            : AppColors.grey400),
                    const SizedBox(
                      width: 16,
                    ),
                    AddButtonSpe(
                        onTap: () {
                          updateSelection('FEMALE');
                          setState(() {
                            sexe = "FEMALE";
                          });
                        },
                        label: "Féminin",
                        background: value == 'FEMALE'
                            ? AppColors.blue700
                            : AppColors.white,
                        color: value == "FEMALE"
                            ? AppColors.white
                            : AppColors.grey400),
                    const SizedBox(
                      width: 16,
                    ),
                    AddButtonSpe(
                        onTap: () {
                          updateSelection('OTHER');
                          setState(() {
                            sexe = "OTHER";
                          });
                        },
                        label: "Autre",
                        background: value == 'OTHER'
                            ? AppColors.blue700
                            : AppColors.white,
                        color: value == "OTHER"
                            ? AppColors.white
                            : AppColors.grey400),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Votre taille',
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      CustomField(
                        label: '183cm',
                        action: TextInputAction.next,
                        value: height,
                        onChanged: (value) => height = value.trim(),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Votre poids',
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      CustomField(
                        label: '75kg',
                        value: weight,
                        action: TextInputAction.next,
                        onChanged: (value) => weight = value.trim(),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Avez-vous des antécédents médicaux ou sujets de santé ?',
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<bool>(
              valueListenable: isHealth,
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AddButtonSpeHealth(
                        onTap: (() {
                          setState(() {
                            isHealth.value = true;
                          });
                        }),
                        label: "Oui",
                        color:
                            value == true ? AppColors.white : AppColors.blue700,
                        background: value == true
                            ? AppColors.blue700
                            : AppColors.white),
                    const SizedBox(width: 16),
                    AddButtonSpeHealth(
                        onTap: (() {
                          setState(() {
                            isHealth.value = false;
                          });
                        }),
                        label: "Non",
                        color:
                            value == false ? Colors.white : AppColors.blue700,
                        background: value == false
                            ? AppColors.blue700
                            : AppColors.white),
                  ],
                );
              },
            ),
            Expanded(child: Container()),
            const SizedBox(height: 8),
            Buttons(
              variant: Variant.primary,
              size: SizeButton.md,
              msg: const Text("Continuer"),
              onPressed: () async {
                if (name != "" &&
                    lastname != "" &&
                    birthdate != "" &&
                    height != "" &&
                    weight != "") {
                  isHealths = isHealth.value;
                  widget.updateSelectedIndex(1);
                } else {
                  TopErrorSnackBar(
                    message: "Compléter tous les champs",
                  ).show(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class Onboarding2 extends StatefulWidget {
  final Function(int) updateSelectedIndex;
  final List<Map<String, dynamic>> docteurs;
  const Onboarding2(
      {required this.updateSelectedIndex, required this.docteurs, super.key});

  @override
  State<Onboarding2> createState() => _onboarding2State();
}

// ignore: camel_case_types
class _onboarding2State extends State<Onboarding2> {
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
      selectedDoctor = docs.indexWhere((doc) => doc['id'] == primaryDoctorId);
    }
    return docs;
  }

  int selectedDoctor = -1;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 172,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: 24,
          top: 16,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                children: [
                  Flexible(
                      child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.blue700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )),
                  const SizedBox(width: 8),
                  Flexible(
                      child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.blue700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
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
                                    index == selectedDoctor ? true : false,
                                onclick: () {
                                  setState(() {
                                    if (selectedDoctor == index) {
                                      selectedDoctor = -1;
                                      primaryDoctorId = "";
                                    } else {
                                      selectedDoctor = index;
                                    }
                                    if (selectedDoctor != -1) {
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
                    return const Center(
                        child: Text("Aucune donnée disponible"));
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Buttons(
                variant: Variant.primary,
                size: SizeButton.md,
                msg: const Text("Continuer"),
                onPressed: () async {
                  if (selectedDoctor != -1) {
                    if (isHealths == true) {
                      widget.updateSelectedIndex(2);
                    } else {
                      List<String> parts = birthdate.split('/');
                      String americanDate =
                          '${parts[2]}-${parts[1]}-${parts[0]}';
                      final birth = DateTime.parse(americanDate);
                      final integerDate =
                          (birth.millisecondsSinceEpoch / 1000).round();
                      final Map<String, Object> body = {
                        "name": lastname,
                        "firstName": name,
                        "birthdate": integerDate,
                        "sex": sexe,
                        "weight": int.parse(weight) * 100,
                        "height": int.parse(height),
                        "primary_doctor_id": primaryDoctorId,
                        "family_members_med_info_id": [],
                        "medical_antecedents": [],
                      };

                      // ignore: unused_local_variable
                      bool medicalinfo = await postMedicalInfo(body, context);
                      if (!medicalinfo) {
                        // ignore: use_build_context_synchronously
                        TopErrorSnackBar(
                          message: "Erreur lors de l'ajout des informations",
                          // ignore: use_build_context_synchronously
                        ).show(context);
                      }
                      widget.updateSelectedIndex(3);
                    }
                  } else {
                    TopErrorSnackBar(
                      message: "Selectionner un docteur",
                    ).show(context);
                  }
                }),
            const SizedBox(height: 8),
            Buttons(
                variant: Variant.secondary,
                size: SizeButton.md,
                msg: const Text("Précédent"),
                onPressed: () {
                  widget.updateSelectedIndex(0);
                }),
          ],
        ),
      ),
    );
  }
}

class Onboarding3 extends StatefulWidget {
  final Function(int) updateSelectedIndex;

  const Onboarding3({
    super.key,
    required this.updateSelectedIndex,
  });

  @override
  State<Onboarding3> createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3> {
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 172,
      child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 12,
            top: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Row(
                  children: [
                    Flexible(
                        child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )),
                    const SizedBox(width: 8),
                    Flexible(
                        child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.blue700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
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
                              ModalTreamentInfo(addMedicalAntecedents: addMedicalAntecedents),
                            ],
                          );
                        },
                      );
                    },
                  );
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
                height: MediaQuery.of(context).size.height * 0.429,
                child: FutureBuilder(
                  future: Future.delayed(const Duration(seconds: 0), () {
                    return true;
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Expanded(
                          child: CircularProgressIndicator(
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
                            if (medicalAntecedents.isNotEmpty)
                              for (var i = 0; i < medicalAntecedents.length; i++)
                                if (i < 3)
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return IntrinsicWidth(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (medicalAntecedents.isNotEmpty) {
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
                                                          SubMenu(medicalAntecedent: medicalAntecedents[i],
                                                            deleteAntecedent: (){
                                                              setState(() {
                                                                medicalAntecedents.removeAt(i);
                                                              });
                                                            },
                                                            refresh: (){
                                                              setState(() {
                                                                medicalAntecedents = medicalAntecedents;
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
                                            name: medicalAntecedents[i]['name'],
                                            isEnCours: medicalAntecedents[i]
                                                        ['treatments']
                                                    .isEmpty
                                                ? false
                                                : true,
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
              Buttons(
                variant: Variant.primary,
                size: SizeButton.md,
                msg: const Text("Valider"),
                onPressed: () async {
                  if (medicalAntecedents.isEmpty) {
                    TopErrorSnackBar(
                      message: "Ajouter des informations",
                    ).show(context);
                    return;
                  }
                  List<String> parts = birthdate.split('/');
                  String americanDate = '${parts[2]}-${parts[1]}-${parts[0]}';
                  final birth = DateTime.parse(americanDate);
                  final integerDate =
                      (birth.millisecondsSinceEpoch / 1000).round();
                  List<Map<String, dynamic>>medicaljson = [];
                  for (var element in medicalAntecedents) {
                    medicaljson.add({
                       "name" : element['name'],
                      "symptoms" : element['symptoms'],
                      "treatments" : element['treatments'].map((treatment) => treatment.toJson()).toList()
                    });
                  }

                  final Map<String, Object> body = {
                    "name": lastname,
                    "firstName": name,
                    "birthdate": integerDate,
                    "sex": sexe,
                    "weight": int.parse(weight) * 100,
                    "height": int.parse(height),
                    "primary_doctor_id": primaryDoctorId,
                    "family_members_med_info_id": [],
                    "medical_antecedents": medicaljson,
                  };

                  var reponse = await postMedicalInfo(body, context);
                  if (reponse == true) {
                    widget.updateSelectedIndex(3);
                    TopSuccessSnackBar(
                      message: "Informations ajoutées avec succès",
                    // ignore: use_build_context_synchronously
                    ).show(context);
                  } else {
                    TopErrorSnackBar(
                      message: "Erreur lors de l'ajout des informations",
                    // ignore: use_build_context_synchronously
                    ).show(context);
                  }

                  widget.updateSelectedIndex(3);
                },
              ),
              const SizedBox(height: 8),
              Buttons(
                  variant: Variant.secondary,
                  size: SizeButton.md,
                  msg: const Text("Précédent"),
                  onPressed: () {
                    widget.updateSelectedIndex(1);
                  }),
            ],
          )),
    );
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

class OnboardingFinish extends StatefulWidget {
  const OnboardingFinish({super.key});

  @override
  State<OnboardingFinish> createState() => _OnboardingFinishState();
}

class _OnboardingFinishState extends State<OnboardingFinish> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));

    _controllerCenter.play();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 172,
      child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 24,
            top: 16,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _controllerCenter,
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  shouldLoop:
                      true, // start again as soon as the animation is finished
                  colors: const [
                    AppColors.blue400,
                    AppColors.blue500,
                    AppColors.blue600,
                    AppColors.blue700,
                    AppColors.blue800,
                    AppColors.blue900,
                    AppColors.green400,
                    AppColors.green500,
                    AppColors.green600,
                    AppColors.green700,
                    AppColors.green800,
                    AppColors.green900,
                  ], // manually specify the colors to be used
                  gravity: 0.8,
                  numberOfParticles: 16,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo/edgar-high-five.png',
                      width: 240,
                      height: 257,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Félicitations !',
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Votre espace patient est maintenant créé',
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    Buttons(
                        variant: Variant.primary,
                        size: SizeButton.md,
                        msg: const Text("Commencer"),
                        onPressed: () {
                          Navigator.pushNamed(context, '/dashboard');
                        }),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}