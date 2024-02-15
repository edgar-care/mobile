// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/widgets/AddPatient/add_button.dart';
import 'package:edgar_pro/widgets/AddPatient/custom_preload_field.dart';
import 'package:edgar_pro/widgets/add_custom_field.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_date_picker.dart';
import 'package:edgar_pro/widgets/patient_list_card.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:logger/logger.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:edgar_pro/widgets/custom_patient_card_info.dart';

List<Map<String,dynamic>> patients = [];

class CustomList extends StatefulWidget {
  const CustomList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomListState createState() => _CustomListState();
}
// ignore: must_be_immutable
class _CustomListState extends State<CustomList> {

  ValueNotifier<int> pageIndexNotifier = ValueNotifier(2);
  ValueNotifier<int> selected = ValueNotifier(2);

  void updateSelection(int newSelection) {
    selected.value = newSelection;
  }

  @override
  initState() {
    super.initState();
    _loadInfo();
  }
  
  Future<void> _loadInfo() async {
    var temp = await getAllPatientId();
    for (var i = 0; i < temp.length; i++) {
     var patient = await getPatientById(temp[i]);
      if (patient.isNotEmpty) {
        setState(() {
          patients.add(patient);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
  Map<String, dynamic> templist;
    return Expanded(
        child: ListView.builder(
          itemCount: patients.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            Logger().d(patients);
            return PatientListCard(
            patientData: patients[index],
            onTap: () {
              templist = Map.of(patients[index]);
               WoltModalSheet.show(
                onModalDismissedWithBarrierTap: () {
                  Navigator.pop(context);
                  setState(() {
                    pageIndexNotifier.value = 2;
                  });
                },
                onModalDismissedWithDrag: () {
                  Navigator.pop(context);
                  setState(() {
                    pageIndexNotifier.value = 2;
                  });
                },
                context: context,
                pageIndexNotifier: pageIndexNotifier,
                pageListBuilder: (BuildContext context) {
                  return [
                    fixPatient(context, pageIndexNotifier, patients[index], templist),
                    fixPatient2(context, pageIndexNotifier, ValueNotifier(patients[index]), ValueNotifier(templist), patients[index]['id']),
                    patientInfo(context, patients[index], context, pageIndexNotifier),
                    deletePatient(context, pageIndexNotifier, patients[index]),
                  ];
                },
              );
            },
          );
        }
      )
    );
  }

  WoltModalSheetPage patientInfo(
      BuildContext context,
      Map<String, dynamic> patient,
      BuildContext modalSheetContext,
      ValueNotifier<int> pageIndexNotifier) {
    return WoltModalSheetPage.withSingleChild(
      
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
        child: Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          spacing: 8,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Buttons(
                variant: Variante.primary,
                size: SizeButton.sm,
                msg: const Text('Modifier'),
                onPressed: () {
                  pageIndexNotifier.value = 0;
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Buttons(
                variant: Variante.delete,
                size: SizeButton.sm,
                msg: const Text('Supprimer'),
                onPressed: () {
                  pageIndexNotifier.value = 3;
                },
              ),
            ),
          ],
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 62),
          child: Container(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.blue200, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BodyInfo(patient: patient),
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.white,
      enableDrag: true,
      hasSabGradient: true,
      hasTopBarLayer: false,
    );
}
  WoltModalSheetPage fixPatient(BuildContext context,
      ValueNotifier<int> pageIndexNotifier, Map<String, dynamic> patient, Map<String, dynamic> templist) {
    return WoltModalSheetPage.withSingleChild(
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
                  pageIndexNotifier.value = 2;
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
      child: FixPatientBody(templist: templist, selected: selected),
    );
  }
}
class FixPatientBody extends StatefulWidget {
  final Map<String, dynamic> templist;
  final ValueNotifier<int> selected;
  const FixPatientBody({super.key, required this.templist, required this.selected});

  @override
  State<FixPatientBody> createState() => _FixPatientBodyState();
}

class _FixPatientBodyState extends State<FixPatientBody> {

  void updateSelection(int newSelection) {
    widget.selected.value = newSelection;
  }

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
                const Text(
                  "Votre Prénom",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                CustomPreloadField(
                  text: widget.templist['Prenom'],
                  label: widget.templist['Prenom'],
                  onChanged: (value) => {
                    setState(() {
                        widget.templist['Prenom'] = value;
                      },
                    ),},
                  isPassword: false,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Votre Nom",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                CustomPreloadField(
                  label: widget.templist['Nom'],
                  text: widget.templist['Nom'],
                  onChanged: (value) => {
                    setState(() {
                        widget.templist['Nom'] = value;
                      },
                    ),},
                  isPassword: false,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Date de naissance",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                CustomDatePiker(
                  value: widget.templist['date_de_naissance'],
                  onChanged: (value) {
                    setState(() {
                      widget.templist['date_de_naissance'] = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Votre sexe",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                ValueListenableBuilder<int>(
                  valueListenable: widget.selected,
                  builder: (context, value, child) {
                    return Row(
                      children: [
                        AddButton(
                            onTap: () => updateSelection(0),
                            label: "Masculin",
                            color: value == 0
                                ? AppColors.blue700
                                : AppColors.white),
                        const SizedBox(
                          width: 16,
                        ),
                        AddButton(
                            onTap: () => updateSelection(1),
                            label: "Feminin",
                            color: value == 1
                                ? AppColors.blue700
                                : AppColors.white),
                        const SizedBox(
                          width: 16,
                        ),
                        AddButton(
                            onTap: () => updateSelection(2),
                            label: "Autre",
                            color: value == 2
                                ? AppColors.blue700
                                : AppColors.white),
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
                            "Votre taille",
                            style:
                                TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          CustomPreloadField(
                            text: widget.templist['taille'].toString(),
                            label: widget.templist['taille'].toString(),
                            onChanged: (value) => {
                              setState(() {
                                  widget.templist['taille'] = value;
                                },
                              ),},
                            isPassword: false,
                            keyboardType: TextInputType.number,
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
                            "Votre poids",
                            style:
                                TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          CustomPreloadField(
                            text: widget.templist['poids'].toString(),
                            label: widget.templist['poids'].toString(),
                            onChanged: (value) => {
                              setState(() {
                                  widget.templist['poids'] = value;
                                },
                              ),},
                            isPassword: false,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ]),
        ),
      );
  }
}

  WoltModalSheetPage deletePatient(BuildContext context,
      ValueNotifier<int> pageIndexNotifier, Map<String, dynamic> patient) {
    return WoltModalSheetPage.withSingleChild(
      hasTopBarLayer: false,
      backgroundColor: AppColors.white,
      hasSabGradient: false,
      enableDrag: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: AppColors.red200,
                  ),
                  child: const Icon(
                    BootstrapIcons.x,
                    color: AppColors.red700,
                    size: 40,
                  )),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Êtes-vous sûr ?",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Si vous supprimez ce patient, vous ne pourrez plus le consulter.",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: Buttons(
                      variant: Variante.secondary,
                      size: SizeButton.sm,
                      msg: const Text('Annuler'),
                      onPressed: () {
                        pageIndexNotifier.value = 2;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: Buttons(
                      variant: Variante.delete,
                      size: SizeButton.sm,
                      msg: const Text('Oui, je suis sûr'),
                      onPressed: () {
                        pageIndexNotifier.value = 2;
                        deletePatientService(patient['id'], context);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

WoltModalSheetPage fixPatient2(BuildContext context,
      ValueNotifier<int> pageIndexNotifier, ValueNotifier<Map<String, dynamic>> patient, ValueNotifier<Map<String, dynamic>> templist, String id) {

    return WoltModalSheetPage.withSingleChild(
      hasTopBarLayer: false,
      backgroundColor: AppColors.white,
      hasSabGradient: true,
      enableDrag: true,
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
        child: Fix2patientButton(pageIndexNotifier: pageIndexNotifier, patient: patient, templist: templist, id: id,),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 86),
          child: BodyFixPatient2(patient: patient, templist: templist),
      ),
    ));
  }


  // ignore: must_be_immutable
  class BodyInfo extends StatefulWidget {
    Map<String, dynamic> patient;
    BodyInfo({super.key, required this.patient});
  
    @override
    State<BodyInfo> createState() => _BodyInfoState();
  }
  
  class _BodyInfoState extends State<BodyInfo> {
    @override
    Widget build(BuildContext context) {
      return Row(
                    children: [
                      Wrap(
                        direction: Axis.vertical,
                        spacing: 12,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Prénom: ",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                widget.patient['Prenom'],
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Nom: ",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                widget.patient['Nom'],
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Date de naissance: ",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                widget.patient['date_de_naissance'],
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Sexe: ",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                widget.patient['sexe'],
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Taille: ",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                widget.patient['taille'].toString(),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Poids: ",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                widget.patient['poids'].toString(),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Médecin Traitant: ",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                widget.patient['medecin_traitant'],
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Allergies:",style: TextStyle(fontFamily: 'Poppins',fontSize: 14,),),
                              const SizedBox(height: 8),
                              PatientInfoCard(context: context,patient: widget.patient,champ: 'allergies',isDeletable: false),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Maladies:",style: TextStyle(fontFamily: 'Poppins',fontSize: 14,),),
                              const SizedBox(height: 8),
                              PatientInfoCard(context: context,patient: widget.patient,champ: 'maladies_connues',isDeletable: false,),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Traitements:",style: TextStyle(fontFamily: 'Poppins',fontSize: 14,),),
                              const SizedBox(height: 8),
                              PatientInfoCard(context: context,patient: widget.patient,champ: 'traitement_en_cours',isDeletable: false,),
                            ],
                          ),
                        ],
                      )
                    ],
                  );
    }
  }


  // ignore: must_be_immutable
  class Fix2patientButton extends StatefulWidget {
    final ValueNotifier<int> pageIndexNotifier;
    final ValueNotifier<Map<String, dynamic>> patient;
    final ValueNotifier<Map<String, dynamic>> templist;
    final String id;
    const Fix2patientButton({super.key, required this.pageIndexNotifier, required this.patient, required this.templist, required this.id});
  
    @override
    State<Fix2patientButton> createState() => _Fix2patientButtonState();
  }
  
  class _Fix2patientButtonState extends State<Fix2patientButton> {
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
                  widget.pageIndexNotifier.value = widget.pageIndexNotifier.value - 1;
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              child: Buttons(
                variant: Variante.validate,
                size: SizeButton.sm,
                msg: const Text('Confirmer'),
                onPressed: () {
                  widget.pageIndexNotifier.value = 2;
                  var patient = Map.of(widget.templist.value);
                  putInformationPatient(context, patient, widget.id);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
    }
  }


class BodyFixPatient2 extends StatefulWidget {
  final ValueNotifier<Map<String, dynamic>> patient;
  final ValueNotifier<Map<String, dynamic>> templist;
  const BodyFixPatient2({super.key, required this.patient, required this.templist});

  @override
  State<BodyFixPatient2> createState() => _BodyFixPatient2State();
}

class _BodyFixPatient2State extends State<BodyFixPatient2> {

    String alergie = "";
    String maladie = "";
    String traitement = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                CustomPreloadField(
                  text: widget.templist.value['medecin_traitant'],
                  label: "Dr. Edgar",
                  onChanged: (value) => widget.templist.value['medecin_traitant'] = value,
                  isPassword: false,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Vos allergies",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                AddCustomField(label: "Renseignez vos allergies ici", onChanged: (value) {setState(() {alergie = value;});},onTap: () {widget.templist.value['allergies'].add(alergie); widget.templist.notifyListeners();}, add: true),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Vos allergies renseignées",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                ValueListenableBuilder(
                  valueListenable: widget.templist,
                  builder: (context, value, child) {
                    return PatientInfoCard(
                        context: context,
                        patient: value,
                        champ: 'allergies',
                        isDeletable: true);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Vos maladies",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                AddCustomField(label: "Renseignez vos maladies ici", onChanged: (value) {setState(() {maladie = value;});},onTap: () {widget.templist.value['maladies_connues'].add(maladie);widget.templist.notifyListeners();}, add: true),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Vos maladies renseignées",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                ValueListenableBuilder(
                  valueListenable: widget.templist,
                  builder: (context, value, child) {
                    return PatientInfoCard(
                        context: context,
                        patient: value,
                        champ: 'maladies_connues',
                        isDeletable: true);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Vos traitements en cours",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                AddCustomField(label: "Renseignez vos traitements ici", onChanged: (value) {setState(() {traitement = value;});},onTap: () {widget.templist.value['traitement_en_cours'].add(traitement);widget.templist.notifyListeners();}, add: true),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Vos traitements renseignés",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                ValueListenableBuilder(
                  valueListenable: widget.templist,
                  builder: (context, value, child) {
                    return PatientInfoCard(
                        context: context,
                        patient: value,
                        champ: 'traitement_en_cours',
                        isDeletable: true);
                  },
                ),
              ],
            ),
          ]);
  }
}