import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/AddPatient/add_button.dart';
import 'package:edgar/widget/buttons.dart';
import 'package:edgar/widget/card_traitement_day.dart';
import 'package:edgar/widget/card_traitement_info.dart';
import 'package:edgar/widget/field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:edgar/services/auth.dart';

class TraitmentPage extends StatefulWidget {
  const TraitmentPage({super.key});

  @override
  State<TraitmentPage> createState() => _TraitmentPageState();
}

class _TraitmentPageState extends State<TraitmentPage> {
  // ignore: non_constant_identifier_names
  final ValueNotifier<String> _encour_ornot = ValueNotifier<String>('encours');

  List<Map<String, Object>> traitement = [
    {
      "id": "",
      "name": "Parasetamole",
      "treatments": [
        {
          "period": ["MORNING"],
          "day": ["TUESDAY"],
          "quantity": 2
        },
        {
          "period": ["MORNING"],
          "day": ["TUESDAY"],
          "quantity": 2
        },
        {
          "period": ["MORNING"],
          "day": ["TUESDAY"],
          "quantity": 2
        },
        {
          "period": ["MORNING"],
          "day": ["TUESDAY"],
          "quantity": 2
        }
      ],
      "still_relevant": true
    },
    {
      "id": "",
      "name": "Chose",
      "treatments": [
        {
          "period": ["MORNING"],
          "day": ["TUESDAY"],
          "quantity": 2
        }
      ],
      "still_relevant": false
    },
  ];

  ValueNotifier<int> pageIndex = ValueNotifier(0);

  @override
  void initState()   {
    super.initState();
    getData();
  }
   Future<void> getData() async {
    final trait = await getTraitement();
    Logger().i(trait);
   }

  void updateData(int index) {
    setState(() {
      pageIndex.value = index;
    });
  }

  void addNewTraitement(
      String name, Map<String, dynamic> medicines, bool stillRelevant) {
    setState(() {
      traitement.add({
        "id": "",
        "name": name,
        "treatments": medicines['treatments'],
        "still_relevant": stillRelevant
      });
    });
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
              'Mes Traitement',
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
        Buttons(
          variant: Variante.secondary,
          size: SizeButton.sm,
          msg: const Text(
            "Calendrier des prises",
            style: TextStyle(color: AppColors.blue700),
            textAlign: TextAlign.center,
          ),
          onPressed: () {},
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder(
          valueListenable: _encour_ornot,
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Buttons(
                    variant: value == 'encours'
                        ? Variante.primary
                        : Variante.secondary,
                    size: SizeButton.sm,
                    msg: const Text(
                      'Traitement en cours',
                    ),
                    onPressed: () {
                      setState(() {
                        _encour_ornot.value = 'encours';
                      });
                    },
                    widthBtn:
                        (MediaQuery.of(context).size.width / 2 - 20).toInt(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Buttons(
                    variant: value == 'terminer'
                        ? Variante.primary
                        : Variante.secondary,
                    size: SizeButton.sm,
                    msg: const Text(
                      'Traitement terminé',
                    ),
                    onPressed: () {
                      setState(() {
                        _encour_ornot.value = 'terminer';
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
        Expanded(
          child: ListView.builder(
            itemCount: traitement.length,
            itemBuilder: (context, index) {
              if (_encour_ornot.value == 'encours' &&
                  traitement[index]['still_relevant'] == true) {
                return GestureDetector(
                  onTap: () {
                    WoltModalSheet.show<void>(
                        context: context,
                        pageIndexNotifier: pageIndex,
                        pageListBuilder: (modalSheetContext) {
                          return [
                            subMenu(
                              modalSheetContext,
                              pageIndex,
                              updateData,
                              traitement[index],
                            ),
                            infoTraitement(
                              context,
                              pageIndex,
                              updateData,
                              traitement[index],
                            ),
                            deleteTraitement(
                              context,
                              pageIndex,
                              updateData,
                              traitement[index],
                            ),
                            modifyTraitement(context, pageIndex, updateData,
                                  traitement[index])
                          ];
                        });
                  },
                  child: Padding(padding: const EdgeInsets.only(bottom: 8), child: CardTraitementSimplify(traitement: traitement[index]),)
                );
              } else if (_encour_ornot.value == 'terminer' &&
                  traitement[index]['still_relevant'] == false) {
                return GestureDetector(
                  onTap: () {
                    WoltModalSheet.show<void>(
                        context: context,
                        pageIndexNotifier: pageIndex,
                        pageListBuilder: (modalSheetContext) {
                          return [
                            subMenu(
                              modalSheetContext,
                              pageIndex,
                              updateData,
                              traitement[index],
                            ),
                            infoTraitement(
                              context,
                              pageIndex,
                              updateData,
                              traitement[index],
                            ),
                            deleteTraitement(
                              context,
                              pageIndex,
                              updateData,
                              traitement[index],
                            ),
                            modifyTraitement(context, pageIndex, updateData, traitement[index])
                          ];
                        });
                  },
                  child: Padding(padding: const EdgeInsets.only(bottom: 8), child: CardTraitementSimplify(traitement: traitement[index]),),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        Buttons(
          variant: Variante.primary,
          size: SizeButton.md,
          msg: const Text(
            "Ajouter un traitement",
            style: TextStyle(color: AppColors.white),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
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
          },
        ),
      ],
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

    Logger().i(widget.traitement);
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
                    onPressed: () async {
                      widget.addNewTraitement(name, medicines, stillRelevant);
                      var post = await
                      postTraitement(
                        {
                          "name": name,
                          "still_relevant": stillRelevant,
                          "treatments": medicines["treatments"]
                        }
                      );
                      Logger().i(post);
                      // ignore: use_build_context_synchronously
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

WoltModalSheetPage subMenu(
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
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            traitement['name'],
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              updateData(1);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.blue50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.blue200,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/utils/Union.svg',
                        width: 16,
                        height: 16,
                        // ignore: deprecated_member_use
                        color: AppColors.blue950,
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Traitements',
                        style: TextStyle(
                          color: AppColors.blue950,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    BootstrapIcons.chevron_right,
                    color: AppColors.blue950,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Divider(
            color: AppColors.blue200,
            thickness: 2,
          ),
          const SizedBox(height: 4),
          Buttons(
            variant: Variante.primary,
            size: SizeButton.sm,
            msg: const Text(
              "Modifier le traitement",
              style: TextStyle(color: AppColors.white),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              updateData(3);
            },
          ),
          const SizedBox(height: 4),
          Buttons(
            variant: Variante.delete,
            size: SizeButton.sm,
            msg: const Text(
              "Supprimer le traitement",
              style: TextStyle(color: AppColors.blue700),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              updateData(2);
            },
          ),
        ],
      ),
    ),
  );
}

WoltModalSheetPage deleteTraitement(
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
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.red200,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              BootstrapIcons.x,
              color: AppColors.red700,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Êtes-vous sûr ?',
            style: TextStyle(
              color: AppColors.grey950,
              fontFamily: 'Poppins',
              fontSize: 20,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              height: null,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Si vous supprimez ce traitement, ni vous ni votre médecin ne pourrez plus le consultez.',
            style: TextStyle(
              color: AppColors.grey500,
              fontFamily: 'Poppins',
              fontSize: 14,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              height: null,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Buttons(
                  variant: Variante.secondary,
                  size: SizeButton.sm,
                  msg: const Text('Annuler'),
                  onPressed: () {
                    updateData(0);
                    Navigator.pop(context);
                  },
                  widthBtn: 140),
              Buttons(
                variant: Variante.delete,
                size: SizeButton.sm,
                msg: const Text('Supprimer'),
                onPressed: () async {
                  updateData(0);
                  Navigator.pop(context);
                },
                widthBtn: 140,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

WoltModalSheetPage modifyTraitement(
  BuildContext context,
  ValueNotifier<int> pageIndex,
  Function(int) updateData,
  Map<String, dynamic> treatment
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
        child: BodyModifyTraitement(
          pageIndex: pageIndex,
          updateData: updateData,
          treatments: treatment,
          screenSize: MediaQuery.of(context).size,
        ),
      ),
    ),
  );
}

// ignore: must_be_immutable
class BodyModifyTraitement extends StatefulWidget {
  final ValueNotifier<int> pageIndex;
  final Function(int) updateData;
  final Size screenSize;
  Map<String, dynamic> treatments;
  BodyModifyTraitement(
      {super.key,
      required this.pageIndex,
      required this.updateData,
      required this.screenSize,
      required this.treatments});

  @override
  State<BodyModifyTraitement> createState() => _BodyModifyTraitementState();
}

class _BodyModifyTraitementState extends State<BodyModifyTraitement> {



  void updateMedicament(Map<String, dynamic> medicament) {
    setState(() {
      widget.treatments['treatments'].add(medicament);
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
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              'assets/images/utils/Subtract.svg',
              // ignore: deprecated_member_use
              color: AppColors.grey700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Modifier un sujet de santé',
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
                valueListenable: ValueNotifier(widget.treatments["still_relevant"]),
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AddButton(
                          onTap: (() {
                            setState(() {
                              widget.treatments["still_relevant"] = true;
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
                              widget.treatments["still_relevant"] = false;
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
                              updateMedicament,
                            ),
                          ];
                        });
                  });
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: widget.screenSize.height - 552,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: widget.treatments['treatments'].length,
                    itemBuilder: (context, index) {
                      if (widget.treatments['treatments'].isEmpty) {
                        return const SizedBox();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CardTraitementDay(
                          isClickable: true,
                          data: widget.treatments['treatments'][index],
                          name: "Doliprane 500 mg",
                          onTap: () {
                            setState(() {
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
                    onPressed: () async {
                      /*
                      var post = await postTraitement({
                        "name": name,
                        "still_relevant": stillRelevant,
                        "treatments": medicines["treatments"]
                      });
                      */
                      // ignore: use_build_context_synchronously
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
