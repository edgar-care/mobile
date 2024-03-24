// ignore_for_file: file_names

import 'package:bootstrap_icons/bootstrap_icons.dart';
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
import 'package:logger/logger.dart';
import 'package:confetti/confetti.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

String prenom = "";
String nom = "";
String birth = "";
String sexe = "";
String size = "";
String poids = "";
bool isHealth = false;

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

  List<Map<String, dynamic>> traitments = [
    {
      "name": "Parasetamole",
      "medicines": [
        {
          "period": ["MORNING"],
          "day": ["TUESDAY"],
          "quantity": 2
        },
        {
          "period": ["NIGHT"],
          "day": ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY"],
          "quantity": 2
        }
      ],
      "still_relevant": true
    },
    {
      "name": "Ibuprofène",
      "medicines": [
        {
          "period": ["MORNING"],
          "day": ["TUESDAY"],
          "quantity": 2
        }
      ],
      "still_relevant": true
    },
    {
      "name": "Aspirine",
      "medicines": [
        {
          "period": ["MORNING"],
          "day": ["TUESDAY"],
          "quantity": 2
        }
      ],
      "still_relevant": false
    },
  ];

  void addNewTraitement(
      String name, List<Map<String, dynamic>> medicines, bool stillRelevant) {
    setState(() {
      traitments.add({
        "name": name,
        "medicines": medicines,
        "still_relevant": stillRelevant,
      });
    });
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
        traitments: traitments,
        addNewTraitement: addNewTraitement,
      ),
      const OnboardingFinish(),
    ];
  }

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
      Logger().i(_selectedIndex);
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                  Image.asset('assets/images/logo/edgar_basic.png',
                      width: 64, height: 75),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
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
              label: 'Prénom',
              action: TextInputAction.next,
              onChanged: (value) => prenom = value,
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
              label: 'Nom',
              action: TextInputAction.next,
              onChanged: (value) => nom = value,
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
              onChanged: (value) => birth = value,
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
                    AddButton(
                        onTap: () => updateSelection('Masculin'),
                        label: "Masculin",
                        color: value == 'Masculin'
                            ? AppColors.blue700
                            : AppColors.white),
                    const SizedBox(
                      width: 16,
                    ),
                    AddButton(
                        onTap: () => updateSelection('Féminin'),
                        label: "Féminin",
                        color: value == "Féminin"
                            ? AppColors.blue700
                            : AppColors.white),
                    const SizedBox(
                      width: 16,
                    ),
                    AddButton(
                        onTap: () => updateSelection('Autre'),
                        label: "Autre",
                        color: value == "Autre"
                            ? AppColors.blue700
                            : AppColors.white),
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
                        label: 'Taille',
                        action: TextInputAction.next,
                        onChanged: (value) => size = value,
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
                        label: 'Poids',
                        action: TextInputAction.next,
                        onChanged: (value) => poids = value,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Votre état de santé',
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
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
                        label: "oui",
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
                        label: "non",
                        color: value == false
                            ? AppColors.blue700
                            : AppColors.white),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Buttons(
                variant: Variante.primary,
                size: SizeButton.sm,
                msg: const Text("Continuer"),
                onPressed: () {
                  widget.updateSelectedIndex(1);
                })
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
  @override
  Widget build(BuildContext context) {
    String nameFilter = "";

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 140,
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
            FutureBuilder(
              future: Future.delayed(const Duration(seconds: 0), () {
                return widget.docteurs;
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
                  ));
                } else if (snapshot.hasError) {
                  return Text('Erreur: ${snapshot.error}');
                } else {
                  var filteredDocteurs = widget.docteurs
                      .where((element) => element['name']
                          .toString()
                          .toLowerCase()
                          .contains(nameFilter.toLowerCase()))
                      .toList();

                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredDocteurs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return CardDoctor(
                                name: filteredDocteurs[index]['name'],
                                address: filteredDocteurs[index]['address'],
                                selected: false,
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
            const SizedBox(height: 16),
            Buttons(
                variant: Variante.primary,
                size: SizeButton.sm,
                msg: const Text("Continuer"),
                onPressed: () {
                  widget.updateSelectedIndex(2);
                }),
            const SizedBox(height: 8),
            Buttons(
                variant: Variante.secondary,
                size: SizeButton.sm,
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
  final List<Map<String, dynamic>> traitments;
  final Function addNewTraitement;
  const Onboarding3(
      {super.key,
      required this.updateSelectedIndex,
      required this.traitments,
      required this.addNewTraitement});

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 140,
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
                              widget.addNewTraitement,
                            ),
                            addMedicament(context, pageIndex, updateData,
                                widget.addNewTraitement),
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
                      ));
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
                            for (var i = 0; i < 3; i++)
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return IntrinsicWidth(
                                    child: GestureDetector(
                                      onTap: () {
                                        WoltModalSheet.show<void>(
                                            context: context,
                                            pageIndexNotifier: pageIndex,
                                            pageListBuilder:
                                                (modalSheetContext) {
                                              return [
                                                infoTraitement(
                                                  context,
                                                  pageIndex,
                                                  updateData,
                                                  widget.traitments[i],
                                                ),
                                              ];
                                            });
                                      },
                                      child: CardTraitementSmall(
                                        name: widget.traitments[i]['name'],
                                        isEnCours: widget.traitments[i]
                                            ['still_relevant'],
                                        onTap: () {
                                          setState(() {
                                            widget.traitments[i]
                                                    ['still_relevant'] =
                                                widget.traitments[i]
                                                    ['still_relevant'];
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
              Buttons(
                  variant: Variante.validate,
                  size: SizeButton.sm,
                  msg: const Text("Valider"),
                  onPressed: () {
                    widget.updateSelectedIndex(3);
                  }),
              const SizedBox(height: 8),
              Buttons(
                  variant: Variante.secondary,
                  size: SizeButton.sm,
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
      height: MediaQuery.of(context).size.height - 140,
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
                        size: SizeButton.sm,
                        msg: const Text("Commencer"),
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
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
        ValueNotifier(widget.traitement['still_relevant']);

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
                  color: widget.traitement['still_relevant']
                      ? AppColors.blue700
                      : AppColors.grey300,
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
                    onTap: (() {
                      // setState(() {
                      //   widget.traitement['still_relevant'] =
                      //       !widget.traitement['still_relevant'];
                      //   isHealth.value = !isHealth.value;
                      //   Logger().i(widget.traitement['still_relevant']);
                      //   Logger().i(isHealth.value);
                      // });
                    }),
                    label: "Oui",
                    color: value == true ? AppColors.blue700 : AppColors.white),
                const SizedBox(width: 8),
                AddButton(
                    onTap: (() {
                      // setState(() {
                      //   widget.traitement['still_relevant'] =
                      //       !widget.traitement['still_relevant'];
                      //   isHealth.value = !isHealth.value;
                      //   Logger().i(widget.traitement['still_relevant']);
                      //   Logger().i(isHealth.value);
                      // });
                    }),
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
            itemCount: widget.traitement['medicines'].length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return CardTraitementDay(
                      isClickable: false,
                      data: widget.traitement['medicines'][index],
                      name: widget.traitement['name'],
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

List<Map<String, dynamic>> medicines = [];

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
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
                onChanged: (value) => name = value,
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
                            ),
                          ];
                        });
                  });
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: widget.screenSize.height - 627,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      if (medicines.isEmpty) {
                        return const SizedBox();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CardTraitementDay(
                          isClickable: false,
                          data: medicines[index]['medecines'],
                          name: name,
                          onTap: () {
                            setState(() {
                              medicines.removeAt(index);
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
                    msg: const Text("Anuller"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Buttons(
                    variant: Variante.validate,
                    size: SizeButton.sm,
                    msg: const Text("Annuler"),
                    onPressed: () {
                      widget.addNewTraitement(name, medicines, stillRelevant);
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
) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: BodyAddMedic(),
      ),
    ),
  );
}

class BodyAddMedic extends StatefulWidget {
  const BodyAddMedic({super.key});

  @override
  State<BodyAddMedic> createState() => _BodyAddMedicState();
}

class _BodyAddMedicState extends State<BodyAddMedic> {
  Map<String, dynamic> medicament = {
    "name": "",
    "quantity": 0,
    "period": [],
    "day": [],
  };
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        CustomFieldSearch(
          label: 'Rechercher le nom du médicament ',
          icon: BootstrapIcons.search,
          keyboardType: TextInputType.name,
          onValidate: (value) {
            setState(() {
              medicament['name'] = value;
            });
          },
        ),
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
            label: 'Quantité',
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
          child: Row(
            children: [
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      medicament['day'].add('MONDAY');
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
                            color: AppColors.black,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      medicament['day'].add('TUESDAY');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('TUESDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Ma',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.black,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      medicament['day'].add('WEDNESDAY');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('WEDNESDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Me',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.black,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      medicament['day'].add('THURSDAY');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('THURSDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Je',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.black,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      medicament['day'].add('FRIDAY');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('FRIDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Ve',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.black,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      medicament['day'].add('SATURDAY');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('SATURDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Sa',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.black,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      medicament['day'].add('SUNDAY');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('SUNDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Di',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.black,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
            ],
          ),
        )
      ],
    );
  }
}
