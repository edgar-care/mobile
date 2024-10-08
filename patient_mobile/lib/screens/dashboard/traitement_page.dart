// ignore_for_file: use_build_context_synchronously

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_app/services/medecine.dart';
import 'package:edgar_app/services/traitement.dart';
import 'package:edgar_app/utils/traitement_utils.dart';
import 'package:edgar_app/widget/AddPatient/add_button.dart';
import 'package:edgar_app/widget/card_traitement_day.dart';
import 'package:edgar_app/widget/card_traitement_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';

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

  void updateTraitement() {
    getFilterTraitement();
    setState(() {});
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
              'Mes traitements',
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
          variant: Variant.secondary,
          size: SizeButton.sm,
          msg: const Text(
            "Calendrier des prises",
            style: TextStyle(color: AppColors.blue700),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
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
                      children: const [CalendarTreatment()],
                    );
                  },
                );
              },
            );
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
                        ? Variant.primary
                        : Variant.secondary,
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
                        ? Variant.primary
                        : Variant.secondary,
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
          variant: Variant.primary,
          size: SizeButton.md,
          msg: const Text(
            "Ajouter un traitement",
            style: TextStyle(color: AppColors.white),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
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
                        AddTreatment(getFilterTraitement: getFilterTraitement)
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
        const SizedBox(height: 8),
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
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8,
                  ),
                  itemCount: traitement.length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    getListName(traitement[index]);
                    return GestureDetector(
                      onTap: () {
                        final model = Provider.of<BottomSheetModel>(context,
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
                                    SubMenu(
                                      model: model,
                                      traitement: traitement[index],
                                    ),
                                    InfoTreatment(
                                      traitement: traitement[index],
                                    ),
                                    DeleteTreatment(
                                      traitement: traitement[index],
                                    ),
                                    ModifyTreatment(
                                      model: model,
                                      treatments: traitement[index],
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: CardTraitementSimplify(
                          traitement: traitement[index], medNames: medNames),
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

class SubMenu extends StatelessWidget {
  final BottomSheetModel model;
  final Map<String, dynamic> traitement;
  const SubMenu({super.key, required this.model, required this.traitement});

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: traitement['antedisease']['name'],
      subtitle: "Voulez vos modifier ou supprimer le traitment",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.filter_square_fill,
          color: AppColors.blue700,
          size: 18,
        ),
        type: ModalType.info,
      ),
      body: [
        GestureDetector(
          onTap: () {
            model.changePage(1);
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
            variant: Variant.primary,
            size: SizeButton.sm,
            msg: const Text(
              "Modifier le traitement",
              style: TextStyle(color: AppColors.white),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              model.changePage(3);
            },
          ),
          const SizedBox(height: 4),
        ],
        Buttons(
          variant: Variant.delete,
          size: SizeButton.sm,
          msg: const Text(
            "Supprimer les traitements",
            style: TextStyle(color: AppColors.blue700),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            model.changePage(2);
          },
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class DeleteTreatment extends StatefulWidget {
  Map<String, dynamic> traitement;
  DeleteTreatment({super.key, required this.traitement});

  @override
  State<DeleteTreatment> createState() => _DeleteTreatmentState();
}

class _DeleteTreatmentState extends State<DeleteTreatment> {
  onDispose() {
    super.dispose();
    ScaffoldMessenger.of(context).showSnackBar(
      SuccessSnackBar(
        message: "Traitement supprimé avec succès",
        context: context,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Êtes-vous sûr ?",
      subtitle:
          'Si vous supprimez ces traitements, ni vous ni votre médecin ne pourrez plus les consultez.',
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.x,
          color: AppColors.red700,
          size: 18,
        ),
        type: ModalType.error,
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          Flexible(
            child: Buttons(
              variant: Variant.delete,
              size: SizeButton.sm,
              msg: const Text('Supprimer'),
              onPressed: () async {
                for (var traitment in widget.traitement['treatments']) {
                  await deleteTraitementRequest(traitment['id']);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddTreatment extends StatefulWidget {
  final Function() getFilterTraitement;
  const AddTreatment({super.key, required this.getFilterTraitement});

  @override
  State<AddTreatment> createState() => _AddTreatmentState();
}

class _AddTreatmentState extends State<AddTreatment> {
  String name = "";
  String traitementName = "";
  bool stillRelevant = false;
  bool alreadyExist = false;
  String idTraitement = "";
  List<dynamic> traitement = [];
  List<String> nameTraitement = [];

  Map<String, dynamic> medicines = {"treatments": [], "name": "Parasetamole"};

  ValueNotifier<bool> alreadyExistNotifier = ValueNotifier(false);
  ValueNotifier<bool> stillRelevantNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    fetchTraitement();
  }

  Future<void> fetchTraitement() async {
    nameTraitement.clear();
    traitement.clear();
    traitement = await getTraitement();
    medicines = {"treatments": [], "name": name};
    for (var tmp in traitement) {
      setState(() {
        nameTraitement.add(tmp['antedisease']['name']);
      });
    }
    if (traitement.isNotEmpty) {
      setState(() {
        idTraitement = traitement[0]['antedisease']['id'];
        traitementName = nameTraitement[0];
      });
    }
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
    medNames.clear();

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
      title: "Ajoutez un traitement",
      subtitle: "Remplissez tout les champs",
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
          'Ajoutez un traitement',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
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
          valueListenable: alreadyExistNotifier,
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AddButton(
                    onTap: () {
                      setState(() {
                        if (traitement.isNotEmpty) {
                          alreadyExistNotifier.value = true;
                        }
                      });
                    },
                    label: "Oui",
                    color:
                        value == true ? AppColors.blue700 : Colors.transparent),
                const SizedBox(width: 8),
                AddButton(
                    onTap: () {
                      setState(() {
                        alreadyExistNotifier.value = false;
                      });
                    },
                    label: "Non",
                    color: value == false
                        ? AppColors.blue700
                        : Colors.transparent),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        if (!alreadyExistNotifier.value) ...[
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
        ],
        if (traitement.isNotEmpty && alreadyExistNotifier.value) ...[
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
              border: Border.all(
                  color: AppColors.blue500, width: 2, style: BorderStyle.solid),
            ),
            child: DropdownButton<String>(
              value: traitementName,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              icon: const Icon(BootstrapIcons.chevron_down),
              iconSize: 16,
              isExpanded: true,
              isDense: true,
              borderRadius: BorderRadius.circular(12),
              underline: Container(
                height: 0,
              ),
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins'),
              onChanged: (String? newValue) {
                setState(() {
                  if (newValue != null) {
                    traitementName = newValue;
                    idTraitement = traitement.firstWhere((element) =>
                        element['antedisease']['name'] ==
                        newValue)['antedisease']['id'];
                  }
                });
              },
              items: nameTraitement
                  .toSet() // Convert to Set to remove duplicates
                  .map((String value) {
                return DropdownMenuItem<String>(
                  alignment: Alignment.centerLeft,
                  value: value,
                  child: Text(value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      )),
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
          valueListenable: stillRelevantNotifier,
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AddButton(
                    onTap: () {
                      setState(() {
                        stillRelevantNotifier.value = true;
                      });
                    },
                    label: "Oui",
                    color:
                        value == true ? AppColors.blue700 : Colors.transparent),
                const SizedBox(width: 8),
                AddButton(
                    onTap: () {
                      setState(() {
                        stillRelevantNotifier.value = false;
                      });
                    },
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
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return Consumer<BottomSheetModel>(
                  builder: (context, model, child) {
                    return ListModal(
                      model: model,
                      children: [
                        AddMedicament(updateMedicament: updateMedicament)
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
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.blue700,
                  strokeCap: StrokeCap.round,
                ));
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8,
                  ),
                  itemCount: medicines['treatments'].length,
                  itemBuilder: (context, index) {
                    if (medicines['treatments'].isEmpty) {
                      return const SizedBox();
                    }
                    return CardTraitementDay(
                      isClickable: true,
                      data: medicines['treatments'][index],
                      name: medNames[index],
                      onTap: () {
                        setState(() {
                          medicines['treatments'].removeAt(index);
                          medNames.removeAt(index);
                        });
                      },
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
              },
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Buttons(
              variant: Variant.validate,
              size: SizeButton.sm,
              msg: const Text("Ajouter"),
              onPressed: () async {
                if (name.isEmpty && !alreadyExistNotifier.value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    ErrorSnackBar(
                      message: "Ajoutez un nom",
                      context: context,
                    ),
                  );
                  return;
                }
                if (medicines['treatments'].isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    ErrorSnackBar(
                      message: "Ajoutez un médicament",
                      context: context,
                    ),
                  );
                  return;
                }
                Map<String, dynamic> tmp = {};
                if (!alreadyExistNotifier.value) {
                  tmp = {
                    "name": name,
                    "still_relevant":
                        stillRelevantNotifier.value == true ? true : false,
                    "treatments": medicines['treatments']
                  };
                } else {
                  tmp = {
                    "name": traitementName,
                    "disease_id": idTraitement,
                    "still_relevant":
                        stillRelevantNotifier.value == true ? true : false,
                    "treatments": medicines['treatments']
                  };
                }
                await postTraitement(tmp).then((value) => {
                      if (value == true)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SuccessSnackBar(
                              message: "Traitement modifié avec succès",
                              context: context,
                            ),
                          ),
                          Navigator.pop(context),
                        }
                      else
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            ErrorSnackBar(
                              message:
                                  "Erreur lors de la modification du traitement",
                              context: context,
                            ),
                          ),
                          Navigator.pop(context),
                        }
                    });
                widget.getFilterTraitement();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddMedicament extends StatefulWidget {
  final Function(Map<String, dynamic>) updateMedicament;
  const AddMedicament({super.key, required this.updateMedicament});

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
      title: "Ajouter un médicament à votre traitement",
      subtitle: "Compléter tout les champs",
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
                  widget.updateMedicament(medicament);
                });
                Navigator.pop(context);
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
  const InfoTreatment({
    super.key,
    required this.traitement,
  });

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
        ValueNotifier(widget.traitement['antedisease']['still_relevant']);
    return ModalContainer(
      title: widget.traitement['antedisease']['name'],
      subtitle: "Voici les information du traitement",
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
      ],
      footer: Buttons(
        variant: Variant.secondary,
        size: SizeButton.md,
        msg: const Text("Fermer"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class ModifyTreatment extends StatefulWidget {
  Map<String, dynamic> treatments;
  BottomSheetModel model;
  ModifyTreatment({super.key, required this.model, required this.treatments});

  @override
  State<ModifyTreatment> createState() => _ModifyTreatmentState();
}

class _ModifyTreatmentState extends State<ModifyTreatment> {
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

  void updateMedicaments(Map<String, dynamic> medicament) {
    setState(() {
      widget.treatments['treatments'].add(medicament);
    });
  }

  void deleteTraitement(int index) {
    deleteTraitementRequest(widget.treatments['treatments'][index]['id']).then(
      (value) => {
        if (value == true)
          {
            ScaffoldMessenger.of(context).showSnackBar(
              SuccessSnackBar(
                message: "Traitement supprimé avec succès",
                context: context,
              ),
            ),
            setState(
              () {
                widget.treatments['treatments'].removeAt(widget
                    .treatments['treatments']
                    .indexOf(widget.treatments['treatments'].firstWhere(
                        (element) =>
                            element['medicine_id'] ==
                            widget.treatments['treatments'][index]
                                ['medicine_id'])));
                medNames.removeAt(index);
              },
            ),
          },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Modifier un sujet de santé",
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
      body: [
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
          valueListenable:
              ValueNotifier(widget.treatments['antedisease']["still_relevant"]),
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AddButton(
                    onTap: (() {
                      setState(() {
                        widget.treatments['antedisease']["still_relevant"] =
                            true;
                      });
                      postTraitement({
                        "name": widget.treatments["antedisease"]["name"],
                        "disease_id": widget.treatments["antedisease"]["id"],
                        "still_relevant": true,
                        'treatments': []
                      }).then((value) => {
                            if (value == false)
                              {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(ErrorSnackBar(
                                  message:
                                      "Erreur lors de la modification du traitement",
                                  context: context,
                                )),
                              }
                          });
                    }),
                    label: "Oui",
                    color: value == true ? AppColors.blue700 : AppColors.white),
                const SizedBox(width: 8),
                AddButton(
                    onTap: (() async {
                      setState(() {
                        widget.treatments['antedisease']["still_relevant"] =
                            false;
                      });
                      postTraitement({
                        "name": widget.treatments["antedisease"]["name"],
                        "disease_id": widget.treatments["antedisease"]["id"],
                        "still_relevant": false,
                        'treatments': []
                      }).then((value) => {
                            if (value == false)
                              {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(ErrorSnackBar(
                                  message:
                                      "Erreur lors de la modification du traitement",
                                  context: context,
                                )),
                              }
                          });
                    }),
                    label: "Non",
                    color:
                        value == false ? AppColors.blue700 : AppColors.white),
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
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return Consumer<BottomSheetModel>(
                  builder: (context, model, child) {
                    return ListModal(
                      model: model,
                      children: [
                        AddMedicamentModify(
                            traitement: widget.treatments,
                            updateMedicaments: updateMedicaments)
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
        Expanded(
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
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8,
                  ),
                  itemCount: widget.treatments['treatments'].length,
                  itemBuilder: (context, index) {
                    if (widget.treatments['treatments'].isEmpty) {
                      return const SizedBox();
                    }
                    return CardTraitementDay(
                      isClickable: true,
                      data: widget.treatments['treatments'][index],
                      name: medNames[index],
                      onTap: () {
                        deleteTraitement(index);
                      },
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
              msg: const Text("Modifier"),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class AddMedicamentModify extends StatefulWidget {
  Map<String, dynamic> traitement;
  Function(Map<String, dynamic>) updateMedicaments;
  AddMedicamentModify({
    super.key,
    required this.traitement,
    required this.updateMedicaments,
  });

  @override
  State<AddMedicamentModify> createState() => _AddMedicamentModifyState();
}

class _AddMedicamentModifyState extends State<AddMedicamentModify> {
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
      subtitle: "Compléter tout les champs",
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
              onPressed: () async {
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
                await postTraitement(
                  {
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
                  },
                ).then(
                  (value) => {
                    if (value == true)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SuccessSnackBar(
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
                          ErrorSnackBar(
                              message: "Erreur lors de l'ajout du traitement",
                              context: context),
                        ),
                      }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarTreatment extends StatefulWidget {
  const CalendarTreatment({super.key});

  @override
  State<CalendarTreatment> createState() => _CalendarTreatmentState();
}

class _CalendarTreatmentState extends State<CalendarTreatment> {
  List<dynamic> allTreatments = [];
  List<dynamic> followUp = [];
  List<dynamic> medecines = [];
  // ignore: non_constant_identifier_names
  DateTime DaySelected = DateTime.now();
  List<Treatment> treatmentsMorning = [];
  List<Treatment> treatmentsAfterNoon = [];
  List<Treatment> treatmentsNight = [];
  List<Treatment> treatmentsEVENING = [];

  @override
  initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var tmp3 = await getMedecines();

    setState(() {
      medecines = tmp3;
    });
  }

  Day getDayEnum() {
    switch (DaySelected.weekday) {
      case 1:
        return Day.MONDAY;
      case 2:
        return Day.TUESDAY;
      case 3:
        return Day.WEDNESDAY;
      case 4:
        return Day.THURSDAY;
      case 5:
        return Day.FRIDAY;
      case 6:
        return Day.SATURDAY;
      case 7:
        return Day.SUNDAY;
    }
    return Day.MONDAY;
  }

  Future<void> getTraitments() async {
    followUp = await getFollowUp();
    allTreatments = await getTraitement().whenComplete(() async {
      treatmentsMorning = await getTreatmentsByDayAndPeriod(
          allTreatments, getDayEnum(), Period.MORNING);
      treatmentsAfterNoon = await getTreatmentsByDayAndPeriod(
          allTreatments, getDayEnum(), Period.NOON);
      treatmentsNight = await getTreatmentsByDayAndPeriod(
          allTreatments, getDayEnum(), Period.NIGHT);
      treatmentsEVENING = await getTreatmentsByDayAndPeriod(
          allTreatments, getDayEnum(), Period.EVENING);
    });
  }

  void updateData() {
    getFollowUp().then(
      (value) => {
        setState(() {
          followUp = value;
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Calendrier des prises",
      subtitle: "Vous retrouver ici les médicaments à prendre chaque jour",
      icon: IconModal(
        icon: SvgPicture.asset(
          'assets/images/utils/Calendar.svg',
          // ignore: deprecated_member_use
          color: AppColors.blue700,
          width: 18,
        ),
        type: ModalType.info,
      ),
      body: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DaySelected.day == DateTime.now().day
                  ? "Aujourd'hui"
                  : DateFormat('EEEE', 'Fr_fr').format(DaySelected),
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins'),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      DaySelected =
                          DaySelected.subtract(const Duration(days: 1));
                    });
                  },
                  icon: const Icon(
                    BootstrapIcons.chevron_left,
                    color: AppColors.black,
                    size: 16,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      DaySelected = DaySelected.add(const Duration(days: 1));
                    });
                  },
                  icon: const Icon(
                    BootstrapIcons.chevron_right,
                    color: AppColors.black,
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        FutureBuilder(
          future: getTraitments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: height * 0.4,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blue700,
                    strokeCap: StrokeCap.round,
                  ),
                ),
              );
            } else {
              return SizedBox(
                height: height * 0.4,
                child: ListView(
                  children: [
                    PeriodeMedicCheckList(
                      period: Period.MORNING,
                      treatments: treatmentsMorning,
                      medecines: medecines,
                      followUp: followUp,
                      updateData: updateData,
                      date: DaySelected,
                    ),
                    PeriodeMedicCheckList(
                      period: Period.NOON,
                      treatments: treatmentsAfterNoon,
                      medecines: medecines,
                      followUp: followUp,
                      updateData: updateData,
                      date: DaySelected,
                    ),
                    PeriodeMedicCheckList(
                      period: Period.EVENING,
                      treatments: treatmentsEVENING,
                      medecines: medecines,
                      followUp: followUp,
                      updateData: updateData,
                      date: DaySelected,
                    ),
                    PeriodeMedicCheckList(
                      period: Period.NIGHT,
                      treatments: treatmentsNight,
                      medecines: medecines,
                      followUp: followUp,
                      updateData: updateData,
                      date: DaySelected,
                    ),
                    if (treatmentsMorning.isEmpty &&
                        treatmentsAfterNoon.isEmpty &&
                        treatmentsNight.isEmpty &&
                        treatmentsEVENING.isEmpty)
                      const Center(
                        child: Text(
                          "Aucun traitement pour cette journée",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }
          },
        ),
      ],
      footer: Buttons(
        variant: Variant.primary,
        size: SizeButton.md,
        msg: const Text("Fermer"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class PeriodeMedicCheckList extends StatefulWidget {
  final Period period;
  final List<Treatment> treatments;
  final List<dynamic> medecines;
  final List<dynamic> followUp;
  final DateTime date;
  Function updateData;

  PeriodeMedicCheckList(
      {super.key,
      required this.period,
      required this.treatments,
      required this.medecines,
      required this.followUp,
      required this.updateData,
      required this.date});

  @override
  PeriodeMedicCheckListState createState() => PeriodeMedicCheckListState();
}

class PeriodeMedicCheckListState extends State<PeriodeMedicCheckList> {
  String getPeriodInFrench(Period period) {
    switch (period) {
      case Period.MORNING:
        return 'Matin';
      case Period.NOON:
        return 'Après-midi';
      case Period.EVENING:
        return 'Soir';
      case Period.NIGHT:
        return 'Nuit';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtrer les traitements pour la période spécifiée
    List<Treatment> filteredTreatments = widget.treatments
        .where((treatment) => treatment.periods.contains(widget.period))
        .toList();

    if (filteredTreatments.isEmpty) {
      return Container(); // Ne pas afficher si aucun traitement
    }

    String getMedicineName(String medicineId) {
      var med = widget.medecines.firstWhere(
        (med) => med['id'] == medicineId,
        orElse: () => {'name': ''},
      );
      return med['name'];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getPeriodInFrench(widget.period),
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
        for (int index = 0; index < filteredTreatments.length; index++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${filteredTreatments[index].quantity} x ${getMedicineName(filteredTreatments[index].medicineId)}',
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Checkbox(
                value: widget.followUp.any((element) =>
                    element['treatment_id'] == filteredTreatments[index].id &&
                    element['period'].contains(
                        widget.period.toString().trim().split('.').last) &&
                    DateTime.fromMillisecondsSinceEpoch(element['date'] * 1000)
                            .day ==
                        widget.date.day),
                onChanged: (value) async {
                  if (DateTime.now().year != widget.date.year ||
                      DateTime.now().day != widget.date.day ||
                      DateTime.now().month != widget.date.month) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      ErrorSnackBar(
                        message:
                            "Vous ne pouvez pas modifier un suivi pour une date passée ou future",
                        context: context,
                      ),
                    );
                    return;
                  }
                  if (value == true) {
                    await postFollowUp({
                      "treatment_id": filteredTreatments[index].id,
                      "date": DateTime.now().millisecondsSinceEpoch ~/ 1000,
                      "period": [
                        widget.period.toString().trim().split('.').last
                      ],
                    }).then(
                      (value) => {
                        widget.updateData(),
                      },
                    );
                  } else {
                    await deleteFollowUpRequest(widget.followUp.firstWhere(
                      (element) =>
                          element['treatment_id'] ==
                              filteredTreatments[index].id &&
                          element['period'].contains(
                              widget.period.toString().trim().split('.').last),
                    )['id'])
                        .then(
                      (value) => {
                        widget.updateData(),
                      },
                    );
                  }
                },
                activeColor: AppColors.blue700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
