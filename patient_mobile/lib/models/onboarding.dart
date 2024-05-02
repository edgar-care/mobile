import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/services/auth.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/AddPatient/add_button.dart';
import 'package:edgar/widget/buttons.dart';
import 'package:edgar/widget/card_traitement_day.dart';
import 'package:edgar/widget/card_traitement_small.dart';
import 'package:edgar/widget/custom_date_picker.dart';
import 'package:edgar/widget/field_custom.dart';
import 'package:flutter/material.dart';
import 'package:edgar/widget/card_docteur.dart';
import 'package:flutter_svg/svg.dart';
import 'package:confetti/confetti.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:edgar/widget/snackbar.dart';

String name = "";
String lastname = "";
String birthdate = "";
String sexe = "";
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
  final List<Map<String, dynamic>> docteurs = [
    {'name': 'Dr. Edgar', 'address': '1 rue de la paix, 75000 Paris'},
    {'name': 'Dr. Edgar', 'address': '1 rue de la paix, 75000 Paris'},
    {'name': 'Dr. Edgar', 'address': '1 rue de la paix, 75000 Paris'},
  ];

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
        docteurs: docteurs,
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

  ValueNotifier<bool> isHealth = ValueNotifier(false);

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
              onChanged: (value) => name = value,
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
              onChanged: (value) => lastname = value,
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
              value: birthdate != "" ? birthdate : null,
              placeHolder: "26/09/2022",
              lastDate: today,
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
                        onTap: () => updateSelection('Masculin'),
                        label: "Masculin",
                        background: value == 'Masculin'
                            ? AppColors.blue700
                            : AppColors.white,
                        color: value == "Masculin"
                            ? AppColors.white
                            : AppColors.grey400),
                    const SizedBox(
                      width: 16,
                    ),
                    AddButtonSpe(
                        onTap: () => updateSelection('Féminin'),
                        label: "Féminin",
                        background: value == 'Féminin'
                            ? AppColors.blue700
                            : AppColors.white,
                        color: value == "Féminin"
                            ? AppColors.white
                            : AppColors.grey400),
                    const SizedBox(
                      width: 16,
                    ),
                    AddButtonSpe(
                        onTap: () => updateSelection('Autre'),
                        label: "Autre",
                        background: value == 'Autre'
                            ? AppColors.blue700
                            : AppColors.white,
                        color: value == "Autre"
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
                        onChanged: (value) => height = value,
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
                        onChanged: (value) => weight = value,
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
                    AddButton(
                        onTap: (() {
                          setState(() {
                            isHealth.value = true;
                          });
                        }),
                        label: "Oui",
                        color: value == true
                            ? AppColors.blue700
                            : AppColors.white),
                    const SizedBox(width: 16),
                    AddButton(
                        onTap: (() {
                          setState(() {
                            isHealth.value = false;
                          });
                        }),
                        label: "Non",
                        color: value == false
                            ? AppColors.blue700
                            : AppColors.white),
                  ],
                );
              },
            ),
            Expanded(child: Container()),
            Buttons(
              variant: Variante.primary,
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
                  ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
                      message: "Completer tout les champs", context: context));
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
  int selectedDoctor = -1;

  final List<Map<String, dynamic>> docteurs = [
    {'name': 'Dr. Edgar', 'address': '1 rue de la paix, 75000 Paris'},
    {'name': 'Dr. Edgar', 'address': '1 rue de la paix, 75000 Paris'},
    {'name': 'Dr. Edgar', 'address': '1 rue de la paix, 75000 Paris'},
  ];

  @override
  Widget build(BuildContext context) {
    String nameFilter = "";
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
            CustomFieldSearch(
              label: 'Docteur Edgar',
              icon: Icons.search,
              keyboardType: TextInputType.name,
              onValidate: (value) {
                setState(() {
                  nameFilter = value;
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: docteurs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return CardDoctor(
                          name: docteurs[index]['name'],
                          address: docteurs[index]['address'],
                          selected: index == selectedDoctor ? true : false,
                          onclick: () {
                            setState(() {
                              selectedDoctor = index;
                            });
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Buttons(
                variant: Variante.primary,
                size: SizeButton.md,
                msg: const Text("Continuer"),
                onPressed: () async {
                  if (selectedDoctor != -1) {
                    int age = DateTime.now().year -
                        int.parse(birthdate.split('/')[2]);
                    int currentMonth = DateTime.now().month;
                    int currentDay = DateTime.now().day;

                    if (currentMonth < int.parse(birthdate.split('/')[1]) ||
                        (currentMonth == int.parse(birthdate.split('/')[1]) &&
                            currentDay < int.parse(birthdate.split('/')[0]))) {
                      age--;
                    }

                    // ignore: unused_local_variable
                    var response = await Register(name, lastname, age, sexe,
                        int.parse(height), int.parse(weight));
                    if (response) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SuccessLoginSnackBar(
                              message: "Création de l'espace patient réussie",
                              // ignore: use_build_context_synchronously
                              context: context));
                    }
                    if (isHealths == true) {
                      widget.updateSelectedIndex(2);
                    } else {
                      List<String> parts = birthdate.split('/');
                      String americanDate = '${parts[2]}${parts[1]}${parts[0]}';
                      final birth = DateTime.parse(americanDate);
                      final integerDate = birth.millisecondsSinceEpoch;
                      final Map<String, Object> body = {
                        "Name": name,
                        "FirstName": lastname,
                        "Birthday": integerDate,
                        "Sex": sexe,
                        "Weight": int.parse(weight),
                        "Height": int.parse(height),
                        "Primary_doctor_id": "edgar",
                        "Medical_antecedents": [],
                      };

                      // ignore: unused_local_variable
                      bool medicalinfo = await postMedicalInfo(body);
                      if (!medicalinfo) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                            ErrorLoginSnackBar(
                                message:
                                    "Erreur lors de l'ajout des informations",
                                // ignore: use_build_context_synchronously
                                context: context));
                      }
                      widget.updateSelectedIndex(3);
                    }
                  }
                }),
            const SizedBox(height: 8),
            Buttons(
                variant: Variante.secondary,
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

  List<Map<String, dynamic>> traitments = [];

  void addNewTraitement(
      String name, Map<String, dynamic> medicines, bool stillRelevant) async {
    setState(() {
      traitments.add({
        "Name": name,
        "treatments": medicines["treatments"],
        "Still_relevant": stillRelevant,
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
              CustomFieldSearch(
                label: 'Renseigner vos informations',
                icon: BootstrapIcons.plus,
                keyboardType: TextInputType.name,
                onValidate: (value) {
                  setState(() {
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
                        });
                  });
                },
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
              Expanded(
                child: Padding(
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
                                    },
                                    child: CardTraitementSmall(
                                      name: traitments[i]['Name'],
                                      isEnCours: traitments[i]
                                          ['Still_relevant'],
                                      onTap: () {
                                        setState(() {
                                          traitments[i]['Still_relevant'] =
                                              traitments[i]['Still_relevant'];
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Buttons(
                  variant: Variante.validate,
                  size: SizeButton.md,
                  msg: const Text("Valider"),
                  onPressed: () async {
                    List<String> parts = birthdate.split('/');
                    String americanDate = '${parts[2]}${parts[1]}${parts[0]}';
                    final birth = DateTime.parse(americanDate);
                    final integerDate = birth.millisecondsSinceEpoch;

                    // ignore: unused_local_variable
                    final Map<String, Object> body = {
                      "Name": name,
                      "FirstName": lastname,
                      "Birthday": integerDate,
                      "Sex": sexe,
                      "Weight": int.parse(weight),
                      "Height": int.parse(height),
                      "Primary_doctor_id": "edgar",
                      "Medical_antecedents": traitments,
                    };

                    widget.updateSelectedIndex(3);
                  }),
              const SizedBox(height: 8),
              Buttons(
                  variant: Variante.secondary,
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
                        variant: Variante.primary,
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
  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isHealth =
        ValueNotifier(widget.traitement['Still_relevant']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              color: AppColors.blue50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.blue200,
                width: 2,
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
                  color: widget.traitement['Still_relevant']
                      ? AppColors.blue700
                      : AppColors.grey300,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.traitement['Name'],
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
              fontWeight: FontWeight.w500,
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
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: widget.traitement['treatments'].length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return CardTraitementDay(
                      isClickable: false,
                      data: widget.traitement['treatments'][index],
                      name: "Doliprane 500 mg",
                      onTap: () {},
                    );
                  },
                ),
              );
            },
          ),
        ),
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
      height: MediaQuery.of(context).size.height * 0.8,
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

  void updateMedicament(Map<String, dynamic> medicament) {
    setState(() {
      medicines['treatments'].add(medicament);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: Column(
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
            'Ajouter un sujet de santé',
            style: TextStyle(
              color: AppColors.black,
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nom du votre sujet de santé',
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomField(
                label: 'Rhume ',
                action: TextInputAction.next,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              const Text(
                'Le sujet de santé est-il toujours en cours ?',
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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
                              : AppColors.white),
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
                              : AppColors.white),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomFieldSearch(
                label: 'Ajouter un médicament',
                icon: BootstrapIcons.plus,
                keyboardType: TextInputType.name,
                onValidate: (value) {
                  setState(() {
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
                  });
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: widget.screenSize.height - 650,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: medicines['treatments'].length,
                    itemBuilder: (context, index) {
                      if (medicines['treatments'].isEmpty) {
                        return const SizedBox();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CardTraitementDay(
                          isClickable: false,
                          data: medicines['treatments'][index],
                          name: "Doliprane 500 mg",
                          onTap: () {
                            setState(() {
                              medicines['treatments'] = medicines['treatments'];
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                      widget.addNewTraitement(name, medicines, stillRelevant);
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ],
      ),
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
    "medicine_id": "66116f1a5ee223d8f1b39c00"
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
                'assets/images/utils/Subtract.svg',
                // ignore: deprecated_member_use
                color: AppColors.green700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ajouter un sujet de santé',
              style: TextStyle(
                color: AppColors.black,
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              'Nom du votre médicament',
              style: TextStyle(
                color: AppColors.black,
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            CustomAutoComplete(
                label: 'Rechercher le nom du médicament ',
                icon: BootstrapIcons.search,
                keyboardType: TextInputType.name,
                onValidate: (value) {
                  setState(() {});
                },
                suggestions: nameMedic),
            const SizedBox(height: 16),
            const Text(
              'Quantité de comprimés',
              style: TextStyle(
                color: AppColors.black,
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
                    medicament['quantity'] = int.parse(value);
                  });
                },
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Jour des prises des médicaments',
              style: TextStyle(
                color: AppColors.black,
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
                fontWeight: FontWeight.bold,
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
