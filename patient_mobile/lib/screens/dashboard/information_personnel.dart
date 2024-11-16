// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_app/services/doctor.dart';
import 'package:edgar_app/services/get_information_patient.dart';
import 'package:edgar_app/services/medecine.dart';
import 'package:edgar_app/widget/AddPatient/add_button.dart';
import 'package:edgar_app/widget/card_docteur.dart';
import 'package:edgar_app/widget/card_traitement_day.dart';
import 'package:edgar_app/widget/card_traitement_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class InformationPersonnel extends StatefulWidget {
  const InformationPersonnel({super.key});

  @override
  State<InformationPersonnel> createState() => _InformationPersonnelState();
}

class _InformationPersonnelState extends State<InformationPersonnel>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> infoMedical = {};
  Map<String, dynamic> tmpInfo = {};
  List<Map<String, dynamic>> tmpTraitments = [];
  String birthdate = '';
  String doctorName = '';
  var pageIndex = ValueNotifier(0);
  ValueNotifier<int> selected = ValueNotifier(0);

  void updateSelection(int newSelection) {
    selected.value = newSelection;
  }

  Future<void> fetchData() async {
    await getMedicalFolder(context).then((value) {
      if (value.isNotEmpty) {
        infoMedical = {
          ...value,
          "medical_antecedents": value['medical_antecedents'] ?? []
        };

        birthdate = DateFormat('dd/MM/yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
                infoMedical['birthdate'] * 1000));
      } else {
        TopErrorSnackBar(message: "Error on fetching name").show(context);
      }
    });
    doctorName = await getNameDoctor();
  }

  Future<String> getNameDoctor() async {
    try {
      final value = await getAllDoctor(context);
      if (value.isNotEmpty) {
        for (var doctor in value) {
          if (doctor['id'] == infoMedical['primary_doctor_id']) {
            if (doctor['name'] != null) {
              return 'Dr. ${doctor['firstname']} ${doctor['name'].toUpperCase()}';
            } else {
              return 'Dr.Edgar';
            }
          }
        }
      } else {
        TopErrorSnackBar(message: "Error on fetching doctor").show(context);
        return 'test';
      }
    } catch (e) {
      TopErrorSnackBar(message: "Error on fetching doctor").show(context);
      return 'test';
    }
    return 'Dr.Edgar'; // default return value if no doctor matches
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.blue700,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Image.asset(
                'assets/images/logo/edgar-high-five.png',
                width: 40,
              ),
              const SizedBox(width: 16),
              const Text(
                'Dossier Médical',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blue700,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Erreur lors du chargement des données'),
              );
            } else {
              return Expanded(
                child: CardInformationPersonnel(
                    infoMedical: infoMedical,
                    birthdate: birthdate,
                    doctorName: doctorName),
              );
            }
          },
        ),
        const SizedBox(height: 16),
        Buttons(
          variant: Variant.primary,
          size: SizeButton.md,
          msg: const Text('Modifier les informations'),
          onPressed: () {
            pageIndex.value = 0;
            final model = Provider.of<BottomSheetModel>(context, listen: false);
            model.resetCurrentIndex();
            tmpInfo = Map.of(infoMedical);
            tmpTraitments = [];
            for (var i = 0; i < tmpInfo['medical_antecedents'].length; i++) {
              tmpInfo['medical_antecedents'][i]['treatments'] =
                  tmpInfo['medical_antecedents'][i]['medicines'];

              tmpInfo['medical_antecedents'][i].remove('medicines');
            }
            // selected.value = infoMedical["sex"];

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
                            model: model, context: context, tmpInfo: tmpInfo),
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
                tmpInfo = Map.of(infoMedical);
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
                if (info['name'] == "" ||
                    info['firstname'] == "" ||
                    info['birthdate'] == "" ||
                    info['weight'] == "" ||
                    info['height'] == "") {
                  TopErrorSnackBar(
                    message: "Veuillez remplir tous les champs",
                  ).show(context);
                } else {
                  switch (selected.value) {
                    case 0:
                      info['sex'] = "MALE";
                      break;
                    case 1:
                      info['sex'] = "FEMALE";
                      break;
                    case 2:
                      info['sex'] = "OTHER";
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
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
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
            CustomField(
              label: "Prénom",
              value: info['firstname'],
              onChanged: (value) => info['firstname'] = value,
              isPassword: false,
              keyboardType: TextInputType.text,
              action: TextInputAction.next,
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
              label: "Nom",
              value: info['name'],
              onChanged: (value) => info['name'] = value,
              isPassword: false,
              keyboardType: TextInputType.text,
              action: TextInputAction.next,
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
              onChanged: (value) {
                String day = value.substring(0, 2);
                String month = value.substring(3, 5);
                String year = value.substring(6, 10);
                int date = DateTime.parse('$year-$month-$day')
                        .millisecondsSinceEpoch ~/
                    1000;
                info['birthdate'] = date;
              },
              endDate: DateTime.now(),
              initialValue: DateFormat('dd/MM/yyyy')
                  .format(
                    DateTime.fromMillisecondsSinceEpoch(
                        info['birthdate'] * 1000),
                  )
                  .toString(),
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
                      width: 8,
                    ),
                    AddButton(
                        onTap: () => updateSelection(1),
                        label: "Féminin",
                        color:
                            value == 1 ? AppColors.blue700 : AppColors.white),
                    const SizedBox(
                      width: 8,
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
                        label: "1,52m",
                        value: (info['height'] / 100).toString(),
                        onChanged: (value) => info['height'] =
                            (int.parse(value.replaceAll(',', '.')) * 100),
                        keyboardType: TextInputType.number,
                        isPassword: false,
                        action: TextInputAction.next,
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
                        label: "45kg",
                        value: info['weight'].toString(),
                        onChanged: (value) => info['weight'] =
                            int.parse(value.replaceAll(',', '.')) * 100,
                        keyboardType: TextInputType.number,
                        isPassword: false,
                        action: TextInputAction.done,
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

class CardInformationPersonnel extends StatefulWidget {
  final String birthdate;
  final Map<String, dynamic> infoMedical;
  final String doctorName;
  const CardInformationPersonnel(
      {super.key,
      required this.infoMedical,
      required this.birthdate,
      required this.doctorName});

  @override
  State<CardInformationPersonnel> createState() =>
      _CardInformationPersonnelState();
}

class _CardInformationPersonnelState extends State<CardInformationPersonnel> {
  @override
  Widget build(BuildContext context) {
    int x = 0;
    for (var treatment in widget.infoMedical['medical_antecedents']) {
      if (treatment.containsKey("treatments")) {
        widget.infoMedical['medical_antecedents'][x]["medicines"] =
            treatment["treatments"];
        x++;
      }
    }
    Logger().i(widget.infoMedical);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.blue200,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElementInfo(
              title: 'Prénom: ',
              value: widget.infoMedical['firstname'],
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Nom: ',
              value: widget.infoMedical['name'],
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Date de naissance: ',
              value: widget.birthdate,
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Sexe: ',
              value: widget.infoMedical['sex'] == 'MALE'
                  ? 'Homme'
                  : widget.infoMedical['sex'] == 'FEMALE'
                      ? 'Femme'
                      : 'Autres',
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Taille: ',
              value: '${widget.infoMedical['height'] / 100} m',
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Poids: ',
              value: '${widget.infoMedical['weight'] / 100} kg',
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Médecin traitant: ',
              value: widget.doctorName,
            ),
            const SizedBox(height: 8),
            const Text(
              'Antécédants médicaux et sujets de santé:',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                for (var treatment in widget.infoMedical['medical_antecedents'])
                  IntrinsicWidth(
                    child: GestureDetector(
                      onTap: () {
                        if (treatment['medicines'] != null) {
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
                                      InfoTreatment(
                                        traitement: treatment,
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                      child: CardTraitementSmall(
                        name: treatment['name'],
                        isEnCours:
                            treatment['medicines'] == null ? false : true,
                        onTap: () {},
                        withDelete: false,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class InfoTreatment extends StatefulWidget {
  Map<String, dynamic> traitement;
  InfoTreatment({super.key, required this.traitement});

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

      for (var i = 0; i < widget.traitement['medicines'].length; i++) {
        var medname = medicaments.firstWhere(
            (med) =>
                med['id'] == widget.traitement['medicines'][i]['medicine_id'],
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
    if (widget.traitement.containsKey("treatments")) {
      widget.traitement["medicines"] = widget.traitement["treatments"];
    }
    return ModalContainer(
      title: widget.traitement['name'],
      subtitle: "Voici les informations du traitement",
      icon: IconModal(
        icon: SvgPicture.asset(
          'assets/images/utils/Union.svg',
          width: 16,
          height: 16,
          // ignore: deprecated_member_use
          color: widget.traitement['medicines'].isEmpty
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
                  strokeWidth: 2,
                ));
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else {
                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: widget.traitement['medicines'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return CardTraitementDay(
                              isClickable: false,
                              data: widget.traitement['medicines'][index],
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

class ElementInfo extends StatelessWidget {
  final String title;
  final String value;
  const ElementInfo({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
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
    var tmp = await getAllDoctor(context);
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
                  TopErrorSnackBar(
                    message: "Veuillez selectionner un médecin traitant",
                  ).show(context);
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
                                  widget.tmpInfo['primary_doctor_id'] = "";
                                } else {
                                  updateSelectedDoctor(index);
                                }
                                if (getDoctor() != -1) {
                                  widget.tmpInfo['primary_doctor_id'] =
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
    Logger().i(widget.tmpInfo);
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
                final Map<String, Object> body = {
                  "name": widget.tmpInfo['name'],
                  "firstname": widget.tmpInfo['firstname'],
                  "birthdate": widget.tmpInfo['birthdate'],
                  "sex": widget.tmpInfo['sex'],
                  "weight": widget.tmpInfo['weight'],
                  "height": widget.tmpInfo['height'],
                  "primary_doctor_id": widget.tmpInfo['primary_doctor_id'],
                  "family_members_med_info_id":
                      widget.tmpInfo['family_members_med_info_id'],
                  "medical_antecedents": widget.tmpInfo['medical_antecedents'],
                  "onboarding_status": "DONE",
                };
                putInformationPatient(context, body, widget.tmpInfo['id']).then(
                  (value) => {
                    Navigator.pop(context),
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
    medicaments = await getMedecines(context);
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
                  TopErrorSnackBar(
                    message: "Veuillez renseigner le nom du traitement",
                  ).show(context);
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
    medicaments = await getMedecines(context);
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
                    TopErrorSnackBar(
                      message: "Veuillez selectionner un médicament",
                    ).show(context);
                    return;
                  }
                  if (medicament['quantity'] == 0 ||
                      medicament['day'].isEmpty ||
                      medicament['period'].isEmpty) {
                    TopErrorSnackBar(
                      message: "Veuillez renseigner tout les champs",
                    ).show(context);
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
