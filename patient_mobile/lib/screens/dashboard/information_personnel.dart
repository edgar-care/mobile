// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'package:edgar/services/get_information_patient.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/AddPatient/add_button.dart';
import 'package:edgar/widget/AddPatient/add_patient_field.dart';
import 'package:edgar/widget/buttons.dart';
import 'package:edgar/widget/custom_patient_card_info.dart';
import 'package:edgar/widget/field_custom.dart';
import 'package:edgar/widget/plain_button.dart';

class InformationPersonnel extends StatefulWidget {
  const InformationPersonnel({super.key});

  @override
  State<InformationPersonnel> createState() => _InformationPersonnelState();
}

class _InformationPersonnelState extends State<InformationPersonnel>
    with SingleTickerProviderStateMixin {
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    fetchData(context);
  }

  Map<String, Object>? infoMedical = {};

  Future<void> fetchData(BuildContext context) async {
    infoMedical = await getInformationPersonnel(context);
  }

  Widget cardInformation(BuildContext context) {
    return isSelected[1]
        ? Card(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: AppColors.blue700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                ...infoMedical!.entries.map((entry) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Row(
                      children: <Widget>[
                        Text(
                          entry.key.replaceAll('_', ' '),
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                        ),
                        const Text(
                          ' :',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                        ),
                        const Spacer(),
                        if (entry.value is List &&
                            (entry.value as List).isNotEmpty)
                          for (var i = 0; i < (entry.value as List).length; i++)
                            Padding(
                              padding: (entry.value as List).length == 1
                                  ? const EdgeInsets.only(right: 0)
                                  : const EdgeInsets.only(right: 4),
                              child: Text(
                                (entry.value as List<dynamic>)[i].toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontFamily: 'Poppins'),
                              ),
                            )
                        else if (entry.value is List &&
                            (entry.value as List).isEmpty)
                          const Text(
                            'Aucun',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Poppins'),
                          )
                        else
                          Text(
                            '${entry.value}',
                            style: const TextStyle(
                                color: Colors.white, fontFamily: 'Poppins'),
                          ),
                      ],
                    ),
                  );
                  // ignore: unnecessary_to_list_in_spreads
                }).toList(),
                const SizedBox(height: 20),
                GreenPlainButtonWithIcon(
                  text: 'Modifier',
                  icon: BootstrapIcons.pencil,
                  onPressed: () {
                    info = infoMedical;
                    WoltModalSheet.show<void>(
                      context: context,
                      pageIndexNotifier: pageIndex,
                      pageListBuilder: (BuildContext context) {
                        return [
                          addPatient(context, pageIndex),
                          addPatient2(context, pageIndex),
                        ];
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.only(top: 50),
        width: 120,
        child:
            Image.asset('assets/images/logo/full-width-colored-edgar-logo.png'),
      ),
      const SizedBox(height: 20),
      ToggleButtons(
        constraints: BoxConstraints.tightFor(
            width: MediaQuery.of(context).size.width * 0.40),
        borderRadius: BorderRadius.circular(50),
        borderWidth: 1,
        borderColor: AppColors.blue700,
        color: AppColors.blue700,
        selectedColor: AppColors.blue700,
        hoverColor: AppColors.blue700,
        fillColor: AppColors.blue700,
        onPressed: (int index) {
          setState(() {
            for (int buttonIndex = 0;
                buttonIndex < isSelected.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                isSelected[buttonIndex] = true;
              } else {
                isSelected[buttonIndex] = false;
              }
            }
          });
        },
        isSelected: isSelected,
        children: <Widget>[
          Text(
            'Information\nPersonnelle',
            style: TextStyle(
                color: isSelected[0] ? Colors.white : AppColors.blue900,
                fontFamily: 'Poppins'),
          ),
          Text('Information\nMedicale',
              style: TextStyle(
                  color: isSelected[1] ? Colors.white : AppColors.blue900,
                  fontFamily: 'Poppins')),
        ],
      ),
      const SizedBox(height: 20),
      cardInformation(context),
    ]);
  }
}

Map<String, Object>? info = {};

final pageIndex = ValueNotifier(0);
ValueNotifier<int> selected = ValueNotifier(0);
ValueNotifier<Map<String, Object>?> infoNotifier = ValueNotifier(info);

class InfoModel extends ChangeNotifier {
  Map<String, Object> _info = {};

  Map<String, Object> get info => _info;

  void setInfo(Map<String, Object> newInfo) {
    _info = newInfo;
    notifyListeners();
  }
}

void updateSelection(int newSelection) {
  selected.value = newSelection;
  if (newSelection == 0) {
    info?['sexe'] = 'Masculin';
  } else if (newSelection == 1) {
    info?['sexe'] = 'Feminin';
  } else {
    info?['sexe'] = 'Autre';
  }
}

WoltModalSheetPage addPatient(
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
                pageIndexNotifier.value = pageIndexNotifier.value + 1;
              },
            ),
          ),
        ],
      ),
    ),
    child: const Bodymodify1(),
  );
}

// ignore: must_be_immutable
class Bodymodify1 extends StatefulWidget {
  const Bodymodify1({
    super.key,
  });

  @override
  State<Bodymodify1> createState() => _Bodymodify1State();
}

class _Bodymodify1State extends State<Bodymodify1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
          "Mettez à jour vos informations personelles",
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
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
              width: MediaQuery.of(context).size.width * 0.35,
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
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Votre Prénom",
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
            ),
            CustomField(
              label: "Prénom",
              onChanged: (value) {
                setState(() {
                  info?['Prenom'] = value;
                  Logger().i(info);
                });
                Logger().i(info);
              },
              isPassword: false,
              value: info!['Prenom'].toString(),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Votre Nom",
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
            ),
            CustomField(
              label: "Nom",
              onChanged: (value) => setState(() {
                info?['Nom'] = value;
              }),
              isPassword: false,
              value: info!['Nom'].toString(),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Date de naissance",
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
            ),
            AddCustomField(
                label: "10 / 09 / 2023",
                onChanged: (value) => setState(() {
                      info?['Anniversaire'] = value;
                      Logger().i(info);
                    }),
                add: false,
                value: info!['Anniversaire'].toString()),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Sexe",
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
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
                        label: "Feminin",
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Taille",
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                      ),
                      CustomField(
                        label: "1,52m",
                        onChanged: (value) => setState(() {
                          info?['Taille'] = value;
                        }),
                        isPassword: false,
                        value: info!['Taille'].toString(),
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
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                      ),
                      CustomField(
                        label: "45kg",
                        onChanged: (value) => setState(() {
                          info?['Poids'] = value;
                        }),
                        isPassword: false,
                        value: info!['Poids'].toString(),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ]),
    );
  }
}

WoltModalSheetPage addPatient2(
    BuildContext context, ValueNotifier<int> pageIndexNotifier) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    stickyActionBar: Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
      child: ButtonModal(
        pageIndexNotifier: pageIndexNotifier,
      ),
    ),
    child: const BodyModify2(),
  );
}

// ignore: must_be_immutable
class ButtonModal extends StatefulWidget {
  ValueNotifier<int> pageIndexNotifier;
  ButtonModal({
    super.key,
    required this.pageIndexNotifier,
  });

  @override
  State<ButtonModal> createState() => _ButtonModalState();
}

class _ButtonModalState extends State<ButtonModal> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      spacing: 12,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.43,
          child: Buttons(
            variant: Variante.secondary,
            size: SizeButton.sm,
            msg: const Text(
              'Revenir en arrière',
            ),
            onPressed: () {
              widget.pageIndexNotifier.value =
                  widget.pageIndexNotifier.value - 1;
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.43,
          child: Buttons(
            variant: Variante.validate,
            size: SizeButton.sm,
            msg: const Text('Confirmer'),
            onPressed: () async {
              putInformationPatient(context, info);
              setState(() {
                infoMedical = info!;
              });
              widget.pageIndexNotifier.value = 0;
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

class BodyModify2 extends StatefulWidget {
  const BodyModify2({super.key});

  @override
  State<BodyModify2> createState() => _BodyModify2State();
}

class _BodyModify2State extends State<BodyModify2> {
  String alergie = "";
  String maladie = "";
  String traitement = "";
  final infoModel = InfoModel();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            "Mettez à jour vos informations personelles",
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
                width: MediaQuery.of(context).size.width * 0.35,
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
                width: MediaQuery.of(context).size.width * 0.35,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Votre médecin traitant",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              CustomField(
                label: "Dr. Edgar",
                onChanged: (value) => setState(() {
                  info?['Medecin_traitant'] = value;
                }),
                isPassword: false,
                value: info!['Medecin_traitant'].toString(),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Vos allergies",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              AddCustomField(
                label: "Renseignez vos allergies ici",
                add: true,
                onChanged: (value) {
                  alergie = value;
                },
                onTap: () {
                  setState(() {
                    if (info!['Allergies'] is List) {
                      (info!['Allergies'] as List).add(alergie);
                    } else {
                      info!['Allergies'] = [alergie];
                    }
                    infoModel.setInfo(info!);
                  });
                },
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Vos allergies renseignée",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              ValueListenableBuilder(
                valueListenable: infoNotifier,
                builder: (context, value, child) {
                  return PatientInfoCard(
                      context: context,
                      patient: value as Map<String, Object>,
                      champ: 'allergies',
                      isDeletable: true);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Vos maladies",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              AddCustomField(
                label: "Renseignez vos maladies ici",
                add: true,
                onChanged: (value) {
                  setState(() {
                    maladie = value;
                  });
                },
                onTap: () {
                  setState(() {
                    if (info!['maladies'] is List) {
                      (info!['maladies'] as List).add(maladie);
                    } else {
                      info!['maladies'] = [maladie];
                    }
                    infoModel.setInfo(info!);
                  });
                },
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Vos maladies renseignée",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              ValueListenableBuilder(
                valueListenable: infoNotifier,
                builder: (context, value, child) {
                  return PatientInfoCard(
                      context: context,
                      patient: value as Map<String, Object>,
                      champ: 'maladies',
                      isDeletable: true);
                },
              ),
              // PatientInfoCard(context: context, patient: info.value, champ: 'maladies', isDeletable: true),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Vos traitements en cours",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              AddCustomField(
                  label: "Renseignez vos traitements ici",
                  add: true,
                  onChanged: (value) {
                    setState(() {
                      traitement = value;
                    });
                  },
                  onTap: () {
                    setState(() {
                      if (info!['traitements'] is List) {
                        (info!['traitements'] as List).add(traitement);
                      } else {
                        info!['traitements'] = [traitement];
                      }
                      infoModel.setInfo(info!);
                    });
                  }),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Vos traitements renseignée",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
              ),
              ValueListenableBuilder(
                valueListenable: infoNotifier,
                builder: (context, value, child) {
                  return PatientInfoCard(
                      context: context,
                      patient: value as Map<String, Object>,
                      champ: 'traitements',
                      isDeletable: true);
                },
              ),
              // PatientInfoCard(context: context, patient: info.value, champ: 'traitements', isDeletable: true),
            ],
          ),
        ]),
      ),
    );
  }
}
