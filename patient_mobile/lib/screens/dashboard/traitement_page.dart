import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/services/medecine.dart';
import 'package:edgar/services/traitement.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/AddPatient/add_button.dart';
import 'package:edgar/widget/buttons.dart';
import 'package:edgar/widget/card_traitement_day.dart';
import 'package:edgar/widget/card_traitement_info.dart';
import 'package:edgar/widget/field_custom.dart';
import 'package:edgar/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

double height = 0.0;
Size screenSize = const Size(0, 0);

class TraitmentPage extends StatefulWidget {
  const TraitmentPage({super.key});

  @override
  State<TraitmentPage> createState() => _TraitmentPageState();
}

class _TraitmentPageState extends State<TraitmentPage> {
  // ignore: non_constant_identifier_names
  final ValueNotifier<String> _encour_ornot = ValueNotifier<String>('encours');

  ValueNotifier<int> pageIndex = ValueNotifier(0);

  List<dynamic> traitement = [];
  List<Map<String, dynamic>> medicaments = [];
  List<String> medNames = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<bool> getData() async {
    var tmp2 = await getMedecines();
    setState(() {
      medicaments = tmp2;
      screenSize = MediaQuery.of(context).size;
      height = MediaQuery.of(context).size.height;
    });
    return true;
  }

  void updateData(int index) {
    setState(() {
      pageIndex.value = index;
    });
  }

  void getListName(Map<String, dynamic> traitement) async {
    medNames.clear();
    if (traitement['treatments'] == null || traitement['treatments'].isEmpty) {
      return;
    }
    for (var treatment in traitement['treatments']) {
      var medId = treatment['medicine_id'];
      var med = medicaments.firstWhere((med) => med['id'] == medId,
          orElse: () => {'name': ''});
      var medName = med['name'];
      medNames.add(medName);
    }
  }

  Future<void> getFilterTraitement() async {
    var traitements = await getTraitement();
    if (_encour_ornot.value == 'encours') {
      traitement = traitements.where((element) {
        return element['antedisease']['still_relevant'] == true &&
            element['treatments'] != null;
      }).toList();
    } else {
      traitement = traitements.where((element) {
        return element['antedisease']['still_relevant'] == false &&
            element['treatments'] != null;
      }).toList();
    }
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
          onPressed: () {
            WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [
                    calendarTraitement(context),
                  ];
                });
          },
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
        const SizedBox(height: 16),
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
                    ),
                  ];
                });
          },
        ),
        Expanded(
          child: FutureBuilder(
            future: getFilterTraitement(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blue700,
                    strokeCap: StrokeCap.round,
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text('Erreur de chargement des données');
              } else {
                return ListView.builder(
                  itemCount: traitement.length,
                  itemBuilder: (context, index) {
                    getListName(traitement[index]);
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
                                  modifyTraitement(context, pageIndex,
                                      updateData, traitement[index])
                                ];
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: CardTraitementSimplify(
                              traitement: traitement[index],
                              medNames: medNames),
                        ));
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
            traitement['antedisease']['name'],
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
          if (traitement['antedisease']["still_relevant"] == true) ...[
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
          ],
          Buttons(
            variant: Variante.delete,
            size: SizeButton.sm,
            msg: const Text(
              "Supprimer les traitements",
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
            'Si vous supprimez ces traitements, ni vous ni votre médecin ne pourrez plus les consultez.',
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
                  for (var traitment in traitement['treatments']) {
                    await deleteTraitementRequest(traitment['id'])
                        .then((value) => {
                              if (value == true)
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SuccessLoginSnackBar(
                                          message:
                                              "Traitement supprimé avec succès",
                                          context: context)),
                                  updateData(0),
                                  Navigator.pop(context),
                                }
                              else
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      ErrorLoginSnackBar(
                                          message:
                                              "Erreur lors de la suppression du traitement",
                                          context: context)),
                                  updateData(0),
                                  Navigator.pop(context),
                                }
                            });
                  }
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

WoltModalSheetPage addTraitement(
  BuildContext context,
  ValueNotifier<int> pageIndex,
  Function(int) updateData,
) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: SizedBox(
      height: height * 0.90,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: BodyAddTraitement(
          pageIndex: pageIndex,
          updateData: updateData,
          screenSize: screenSize,
        ),
      ),
    ),
  );
}

class BodyAddTraitement extends StatefulWidget {
  final ValueNotifier<int> pageIndex;
  final Function(int) updateData;
  final Size screenSize;
  const BodyAddTraitement(
      {super.key,
      required this.pageIndex,
      required this.updateData,
      required this.screenSize});

  @override
  State<BodyAddTraitement> createState() => _BodyAddTraitementState();
}

class _BodyAddTraitementState extends State<BodyAddTraitement> {
  String name = "";
  String traitementName = "";
  bool stillRelevant = false;
  bool alreadyExist = false;
  String idTraitement = "";
  List<dynamic> traitement = [];
  List<String> nameTraitement = [];

  Map<String, dynamic> medicines = {"treatments": [], "name": "Parasetamole"};

  @override
  void initState() {
    super.initState();
    setState(() {
      medicines = {"treatments": [], "name": name};
    });
    fetchTraitement();
  }

  Future<void> fetchTraitement() async {
    traitement = await getTraitement();
    nameTraitement.clear();
    for (var trait in traitement) {
      nameTraitement.add(trait['antedisease']['name']);
    }
    traitementName = nameTraitement[0];
    idTraitement = traitement[0]['antedisease']['id'];
    return;
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
    return SizedBox(
      height: height * 0.9,
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
                'Avez-vous déjà ajouté votre sujet de santé ?',
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<bool>(
                valueListenable: ValueNotifier(alreadyExist),
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AddButton(
                          onTap: (() {
                            setState(() {
                              alreadyExist = true;
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
                              alreadyExist = false;
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
              if (alreadyExist == false) ...[
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
                  action: TextInputAction.next,
                  onChanged: (value) {
                    setState(() {
                      name = value.trim();
                    });
                  },
                  keyboardType: TextInputType.name,
                ),
              ] else ...[
                const Text(
                  'Sélectionnez votre sujet de santé',
                  style: TextStyle(
                    color: AppColors.black,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.blue500, width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: DropdownButton<String>(
                    value: traitementName,
                    icon: const Icon(BootstrapIcons.chevron_down),
                    iconSize: 16,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(12),
                    underline: Container(
                      height: 0,
                    ),
                    style: const TextStyle(color: AppColors.black),
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue != null) {
                          traitementName = newValue;
                          idTraitement = traitement.firstWhere((element) =>
                              element['antedisease']['name'] ==
                              newValue)['antedisease']['id'];
                          name = newValue;
                        }
                      });
                    },
                    items: nameTraitement
                        .toSet() // Convert to Set to remove duplicates
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                )
              ],
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
                height: widget.screenSize.height - 608,
                width: widget.screenSize.width,
                child: FutureBuilder(
                  future: fetchData(), // Simulate some async operation
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: AppColors.blue700,
                        strokeCap: StrokeCap.round,
                      ));
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
          const Spacer(),
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
                      if (name == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                            ErrorLoginSnackBar(
                                message: "Ajoutez un nom", context: context));
                        return;
                      }
                      if (medicines['treatments'].isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            ErrorLoginSnackBar(
                                message: "Ajoutez un médicament",
                                context: context));
                        return;
                      }
                      Map<String, dynamic> tmp = {};
                      if (alreadyExist == false) {
                        tmp = {
                          "name": name,
                          "still_relevant": stillRelevant,
                          "treatments": medicines['treatments']
                        };
                      }
                      if (alreadyExist == true) {
                        tmp = {
                          "name": traitementName,
                          "disease_id": idTraitement,
                          "still_relevant": stillRelevant,
                          "treatments": medicines['treatments']
                        };
                      }
                      Logger().i(tmp);
                      await postTraitement(tmp).then((value) => {
                            if (value == true)
                              {
                                widget.updateData(0),
                                Navigator.pop(context),
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SuccessLoginSnackBar(
                                        message:
                                            "Traitement modifié avec succès",
                                        context: context)),
                                widget.updateData(0),
                              }
                            else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    ErrorLoginSnackBar(
                                        message:
                                            "Erreur lors de la modification du traitement",
                                        context: context)),
                                widget.updateData(0),
                              }
                          });
                    }),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
      height: height * 0.80,
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
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isHealth =
        ValueNotifier(widget.traitement['antedisease']['still_relevant']);

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
                  widget.traitement['antedisease']['name'],
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
          height: height * 0.49,
          child: FutureBuilder<bool>(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.blue700,
                  strokeCap: StrokeCap.round,
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
        ),
        const SizedBox(height: 16),
        Flexible(
          child: Buttons(
              variant: Variante.secondary,
              size: SizeButton.md,
              msg: const Text("Fermer"),
              onPressed: () {
                widget.updateData(0);
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }
}

WoltModalSheetPage modifyTraitement(
    BuildContext context,
    ValueNotifier<int> pageIndex,
    Function(int) updateData,
    Map<String, dynamic> treatment) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: SizedBox(
      height: height * 0.80,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: BodyModifyTraitement(
          pageIndex: pageIndex,
          updateData: updateData,
          treatments: treatment,
          screenSize: screenSize,
          updateMedicament: (medicament) {},
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
  Function(Map<String, dynamic>) updateMedicament;
  BodyModifyTraitement(
      {super.key,
      required this.pageIndex,
      required this.updateData,
      required this.screenSize,
      required this.treatments,
      required this.updateMedicament});

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
  void initState() {
    super.initState();
    setState(() {
      widget.treatments = widget.treatments;
    });
  }

  List<Map<String, dynamic>> medicaments = [];
  List<String> medNames = [];

  Future<bool> fetchData() async {
    medicaments = await getMedecines();
    medNames.clear(); // Effacer la liste existante pour éviter les doublons

    for (var treatment in widget.treatments['treatments']) {
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
    return SizedBox(
      height: height * 0.8,
      width: MediaQuery.of(context).size.width - 48,
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
              fontSize: 14,
              fontWeight: FontWeight.w700,
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
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<bool>(
                valueListenable: ValueNotifier(
                    widget.treatments['antedisease']["still_relevant"]),
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AddButton(
                          onTap: (() {
                            setState(() {
                              widget.treatments['antedisease']
                                  ["still_relevant"] = true;
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
                              widget.treatments['antedisease']
                                  ["still_relevant"] = false;
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
              GestureDetector(
                onTap: () {
                  WoltModalSheet.show<void>(
                      context: context,
                      pageListBuilder: (modalSheetContext) {
                        return [
                          addMedicamentModify(
                            context,
                            widget.pageIndex,
                            widget.updateData,
                            widget.updateMedicament,
                            widget.treatments,
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
                          fontFamily: 'Poppins',
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
              const SizedBox(height: 16),
              SizedBox(
                height: widget.screenSize.height - 552,
                child: Expanded(
                  child: FutureBuilder(
                    future: fetchData(), // Simulate some async operation
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: AppColors.blue700,
                          strokeCap: StrokeCap.round,
                        ));
                      } else {
                        return ListView.builder(
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
                                name: medNames[index],
                                onTap: () async {
                                  await deleteTraitementRequest(
                                          widget.treatments['treatments'][index]
                                              ['id'])
                                      .then(
                                    (value) => {
                                      if (value == true)
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SuccessLoginSnackBar(
                                              message:
                                                  "Traitement supprimé avec succès",
                                              context: context,
                                            ),
                                          ),
                                          setState(
                                            () {
                                              widget.treatments['treatments'].removeAt(widget
                                                  .treatments['treatments']
                                                  .indexOf(widget
                                                      .treatments['treatments']
                                                      .firstWhere((element) =>
                                                          element[
                                                              'medicine_id'] ==
                                                          widget.treatments[
                                                                      'treatments']
                                                                  [index][
                                                              'medicine_id'])));
                                              medNames.removeAt(index);
                                            },
                                          ),
                                        },
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
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
                      widget.updateData(0);
                    }),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Buttons(
                  variant: Variante.validate,
                  size: SizeButton.sm,
                  msg: const Text("Ajouter"),
                  onPressed: () async {
                    widget.updateData(0);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

WoltModalSheetPage addMedicamentModify(
  BuildContext context,
  ValueNotifier<int> pageIndex,
  Function(int) updateData,
  Function(Map<String, dynamic>) updateMedicaments,
  Map<String, dynamic> traitement,
) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: BodyAddMedicModify(
            updateData: updateData,
            traitement: traitement,
            updateMedicaments: updateMedicaments),
      ),
    ),
  );
}

// ignore: must_be_immutable
class BodyAddMedicModify extends StatefulWidget {
  Function(int) updateData;
  Map<String, dynamic> traitement;
  Function(Map<String, dynamic>) updateMedicaments;

  BodyAddMedicModify(
      {super.key,
      required this.updateData,
      required this.traitement,
      required this.updateMedicaments});

  @override
  State<BodyAddMedicModify> createState() => _BodyAddMedicModifyState();
}

class _BodyAddMedicModifyState extends State<BodyAddMedicModify> {
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
                    await postTraitement({
                      "name": widget.traitement['antedisease']['name'],
                      "disease_id": widget.traitement['antedisease']['id'],
                      "still_relevant": widget.traitement['antedisease']
                          ['still_relevant'],
                      "treatments": [
                        {
                          "quantity": medicament['quantity'],
                          "period": medicament['period'],
                          "day": medicament['day'],
                          "medicine_id": medicament['medicine_id']
                        }
                      ],
                    }).then((value) => {
                          if (value == true)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SuccessLoginSnackBar(
                                      message: "Traitement ajouté avec succès",
                                      context: context)),
                              setState(() {
                                widget.updateMedicaments(medicament);
                              }),
                              Navigator.pop(context),
                            }
                          else
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  ErrorLoginSnackBar(
                                      message:
                                          "Erreur lors de l'ajout du traitement",
                                      context: context)),
                            }
                        });
                  }),
            ),
          ],
        ),
      ],
    );
  }
}

WoltModalSheetPage calendarTraitement(
  BuildContext context,
) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: SizedBox(
      height: height * 0.80,
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: BodyCalendarTraitement(),
      ),
    ),
  );
}

class BodyCalendarTraitement extends StatefulWidget {
  const BodyCalendarTraitement({super.key});

  @override
  State<BodyCalendarTraitement> createState() => _BodyCalendarTraitementState();
}

class _BodyCalendarTraitementState extends State<BodyCalendarTraitement> {
  @override
  initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await getFollowUp();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.6,
      width: MediaQuery.of(context).size.width - 48,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.blue200,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              'assets/images/utils/Calendar.svg',
              // ignore: deprecated_member_use
              color: AppColors.blue700,
              width: 24,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Calendrier des prises',
            style: TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Aujourd’hui',
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      BootstrapIcons.chevron_left,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      BootstrapIcons.chevron_right,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          PeriodeMedicCheckList(
            periode: "Matin",
            medicaments: const [
              {"name": "Médicament A", "checked": false, "quantity": 2},
              {"name": "Médicament B", "checked": true, "quantity": 1},
            ],
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class PeriodeMedicCheckList extends StatefulWidget {
  final String periode;
  List<Map<String, dynamic>> medicaments;

  PeriodeMedicCheckList(
      {super.key, required this.periode, required this.medicaments});

  @override
  PeriodeMedicCheckListState createState() => PeriodeMedicCheckListState();
}

class PeriodeMedicCheckListState extends State<PeriodeMedicCheckList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.periode,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const Divider(
          color: AppColors.blue200,
          thickness: 2,
        ),
        for (int index = 0; index < widget.medicaments.length; index++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.medicaments[index]['quantity']} x ${widget.medicaments[index]["name"]}',
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              Checkbox(
                value: widget.medicaments[index]['checked'],
                onChanged: (value) {
                  setState(() {
                    widget.medicaments[index]['quantity'] = value!;
                  });
                },
                activeColor: AppColors.blue700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: const BorderSide(color: AppColors.blue200, width: 2),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
