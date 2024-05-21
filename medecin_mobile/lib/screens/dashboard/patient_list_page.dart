import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/doctor_services.dart';
import 'package:edgar_pro/services/medecines_services.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/AddPatient/add_button.dart';
import 'package:edgar_pro/widgets/AddPatient/custom_preload_field.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/card_doctor.dart';
import 'package:edgar_pro/widgets/card_traitement_day.dart';
import 'package:edgar_pro/widgets/card_traitement_small.dart';
import 'package:edgar_pro/widgets/custom_date_picker.dart';
import 'package:edgar_pro/widgets/custom_nav_patient_card.dart';
import 'package:edgar_pro/widgets/custom_patient_card_info.dart';
import 'package:edgar_pro/widgets/field_custom.dart';
import 'package:edgar_pro/widgets/login_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// ignore: must_be_immutable
class PatientPage extends StatefulWidget {
  String id;
  final Function setPages;
  final Function setId;
  PatientPage(
      {super.key,
      required this.id,
      required this.setPages,
      required this.setId});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  Map<String, dynamic> patientInfo = {};
  Map<String, dynamic> tmpInfo = {};
  List<Map<String, dynamic>> tmpTraitments = [];
  List<dynamic> docs = [];
  int doctorindex = -1;
  ValueNotifier<int> selected = ValueNotifier(0);
  var pageIndex = ValueNotifier(0);

  void updateModalIndex(int index) {
    pageIndex.value = index;
  }

  void updateSelection(int newSelection) {
    selected.value = newSelection;
  }

  Future<void> _loadInfo() async {
    patientInfo = await getPatientById(widget.id);
    docs = await getAllDoctor();
    tmpInfo = Map.of(patientInfo);
    doctorindex =
        docs.indexWhere((doc) => doc['id'] == patientInfo['medecin_traitant']);
    switch (patientInfo['sexe']) {
      case 'MALE':
        selected.value = 0;
        break;
      case 'FEMALE':
        selected.value = 1;
        break;
      case 'OTHER':
        selected.value = 2;
        break;
    }
  }

  void updateData() async {
    setState(() {
      _loadInfo();
    });
    tmpInfo = Map.of(patientInfo);
    tmpTraitments = [];
  }

  String sexe(String sexe) {
    switch (sexe) {
      case 'MALE':
        return 'Masculin';
      case 'FEMALE':
        return 'Feminin';
      default:
        return 'Autre';
    }
  }

  String taille(String taille) {
    int tailleInt = int.parse(taille);
    return (tailleInt / 100).toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.blue100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.blue200,
                      width: 2,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      WoltModalSheet.show<void>(
                          context: context,
                          pageListBuilder: (modalSheetContext) {
                            return [
                              patientNavigation(context, patientInfo,
                                  widget.setPages, widget.setId),
                            ];
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 3,
                            decoration: BoxDecoration(
                              color: AppColors.green500,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            '${patientInfo['Nom']} ${patientInfo['Prenom']}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins'),
                          ),
                          const Spacer(),
                          const Text(
                            'Voir Plus',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins'),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Icon(
                            BootstrapIcons.chevron_right,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
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
                          Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.vertical,
                            spacing: 12,
                            children: [
                              Text('Prénom: ${patientInfo['Prenom']}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500)),
                              Text('Nom: ${patientInfo['Nom']}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  'Date de naissance: ${patientInfo['date_de_naissance']}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500)),
                              Text('Sexe: ${sexe(patientInfo['sexe'])}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500)),
                              Text('Taille: ${taille(patientInfo['taille'])} m',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500)),
                              Text('Poids: ${taille(patientInfo['poids'])} kg',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500)),
                              if (doctorindex != -1)
                                Text(
                                    'Médecin traitant: ${docs[doctorindex]['firstname']} ${docs[doctorindex]['name']}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500)),
                              if (doctorindex == -1)
                                const Text('Médecin traitant: Non indiqué',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500)),
                              if (patientInfo['medical_antecedents'].isNotEmpty)
                                const Text(
                                    'Antécédants médicaux et sujets de santé: ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (patientInfo['medical_antecedents'].isNotEmpty)
                            Expanded(
                              child: PatientInfoCard(
                                  context: context,
                                  tmpTraitments:
                                      patientInfo['medical_antecedents']),
                            ),
                          const SizedBox(
                            height: 16,
                          ),
                          Buttons(
                            variant: Variante.primary,
                            size: SizeButton.md,
                            msg: const Text('Modifier le dossier médical'),
                            onPressed: () {
                              pageIndex.value = 0;
                              WoltModalSheet.show<void>(
                                  onModalDismissedWithDrag: () {
                                    Navigator.pop(context);
                                    tmpInfo = Map.of(patientInfo);
                                    tmpTraitments = [];
                                    pageIndex.value = 0;
                                  },
                                  onModalDismissedWithBarrierTap: () {
                                    Navigator.pop(context);
                                    tmpInfo = Map.of(patientInfo);
                                    tmpTraitments = [];
                                    pageIndex.value = 0;
                                  },
                                  context: context,
                                  pageIndexNotifier: pageIndex,
                                  pageListBuilder: (modalSheetContext) {
                                    return [
                                      addPatient(context, pageIndex, tmpInfo),
                                      addPatient2(
                                          updateModalIndex, context, tmpInfo),
                                      addPatient3(updateModalIndex, context,
                                          tmpTraitments),
                                    ];
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue700),
                strokeWidth: 2.0,
              ),
            );
          }
        });
  }

  SliverWoltModalSheetPage patientNavigation(BuildContext context,
      Map<String, dynamic> patient, Function setPages, Function setId) {
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(children: [
            Text(
              '${patient['Nom']} ${patient['Prenom']}',
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomNavPatientCard(
                text: 'Dossier médical',
                icon: BootstrapIcons.postcard_heart_fill,
                setPages: setPages,
                pageTo: 6,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 4),
            CustomNavPatientCard(
                text: 'Rendez-vous',
                icon: BootstrapIcons.calendar2_week_fill,
                setPages: setPages,
                pageTo: 7,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 4),
            CustomNavPatientCard(
                text: 'Documents',
                icon: BootstrapIcons.file_earmark_text_fill,
                setPages: setPages,
                pageTo: 8,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 4),
            CustomNavPatientCard(
                text: 'Messagerie',
                icon: BootstrapIcons.chat_dots_fill,
                setPages: setPages,
                pageTo: 9,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 12),
            Container(height: 2, color: AppColors.blue200),
            const SizedBox(height: 12),
            Buttons(
                variant: Variante.primary,
                size: SizeButton.sm,
                msg: const Text(
                  'Revenir à la patientèle',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                onPressed: () {
                  setPages(1);
                  Navigator.pop(context);
                }),
          ]),
        ),
      ),
    );
  }

  SliverWoltModalSheetPage addPatient(BuildContext context,
      ValueNotifier<int> pageIndexNotifier, Map<String, dynamic> info) {
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
                  tmpInfo = Map.of(patientInfo);
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
                  if (info['Prenom'] == "" ||
                      info['Nom'] == "" ||
                      info['date_de_naissance'] == "" ||
                      info['sexe'] == "" ||
                      info['taille'] == "" ||
                      info['poids'] == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      ErrorLoginSnackBar(
                        message: "Veuillez remplir tous les champs",
                        context: context,
                      ),
                    );
                  } else {
                    switch (selected.value) {
                      case 0:
                        info['sexe'] = "MALE";
                        break;
                      case 1:
                        info['sexe'] = "FEMALE";
                        break;
                      case 2:
                        info['sexe'] = "OTHER";
                        break;
                      default:
                    }
                    pageIndexNotifier.value = pageIndexNotifier.value + 1;
                  }
                },
              ),
            ),
          ],
        ),
      ),
      child: SizedBox(
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
              "Mettez à jour les informations du patient",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8,
            ),
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
                    color: AppColors.blue200,
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
                CustomPreloadField(
                  startUppercase: true,
                  label: "Prénom",
                  text: info['Prenom'],
                  onChanged: (value) => info['Prenom'] = value,
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
                CustomPreloadField(
                  startUppercase: true,
                  label: "Nom",
                  text: info['Nom'],
                  onChanged: (value) => info['Nom'] = value,
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
                  onChanged: (value) => info['date_de_naissance'] = value,
                  endDate: DateTime.now(),
                  value: info['date_de_naissance'],
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
                            color: value == 0
                                ? AppColors.blue700
                                : AppColors.white),
                        const SizedBox(
                          width: 16,
                        ),
                        AddButton(
                            onTap: () => updateSelection(1),
                            label: "Féminin",
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
                            "Taille",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomPreloadField(
                            startUppercase: false,
                            text:
                                (double.parse(info['taille']) / 100).toString(),
                            label: "1,52m",
                            onChanged: (value) => info['taille'] =
                                (double.parse(value.replaceAll(',', '.')) * 100)
                                    .toString(),
                            keyboardType: TextInputType.number,
                            isPassword: false,
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
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomPreloadField(
                            startUppercase: false,
                            label: "45kg",
                            text:
                                (double.parse(info['poids']) / 100).toString(),
                            onChanged: (value) => info['poids'] =
                                (double.parse(value.replaceAll(',', '.')) * 100)
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
          ]),
        ),
      ),
    );
  }

  SliverWoltModalSheetPage addPatient2(final Function(int) updateSelectedIndex,
      BuildContext context, Map<String, dynamic> tmpInfo) {
    int selectedDoctor = -1;

    void updateSelectedDoctor(int index) {
      selectedDoctor = index;
    }

    int getDoctor() {
      return selectedDoctor;
    }

    return WoltModalSheetPage(
      hasTopBarLayer: false,
      backgroundColor: AppColors.white,
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
                msg: const Text('Précedent'),
                onPressed: () {
                  updateSelectedIndex(0);
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
                  if (getDoctor() != -1) {
                    updateSelectedIndex(2);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      ErrorLoginSnackBar(
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
      ),
      child: SizedBox(
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
              "Mettez à jour les informations du patient",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8,
            ),
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
              updateSelectedIndex: updateSelectedIndex,
              getDoctor: getDoctor,
              setDoctor: updateSelectedDoctor,
              tmpInfo: tmpInfo,
            ),
          ]),
        ),
      ),
    );
  }

  SliverWoltModalSheetPage addPatient3(final Function(int) updateSelectedIndex,
      BuildContext context, List<Map<String, dynamic>> traitments) {
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
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
              "Modifiez les informations du patient",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8,
            ),
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
            Body3(
                updateSelectedIndex: updateSelectedIndex,
                tmpInfo: tmpInfo,
                tmpTraitments: traitments,
                refresh: updateData),
          ]),
        ),
      ),
    );
  }
}

WoltModalSheetPage infoTraitement(
  BuildContext context,
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
          traitement: traitement,
        ),
      ),
    ),
  );
}

// ignore: must_be_immutable
class BodyInfoModal extends StatefulWidget {
  Map<String, dynamic> traitement;
  BodyInfoModal({super.key, required this.traitement});

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
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 4),
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
        const SizedBox(height: 4),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.55,
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
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class Body2 extends StatefulWidget {
  final Function(int) updateSelectedIndex;
  final Function getDoctor;
  final Function setDoctor;
  Map<String, dynamic> tmpInfo;
  Body2(
      {required this.updateSelectedIndex,
      super.key,
      required this.getDoctor,
      required this.setDoctor,
      required this.tmpInfo});

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
    var tmp = await getAllDoctor();
    setState(() {
      docs = tmp;
    });
    if (widget.tmpInfo['medecin_traitant'] != "") {
      widget.setDoctor(docs.indexWhere(
          (doc) => doc['id'] == widget.tmpInfo['medecin_traitant']));
    }
    return docs;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 204,
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
                              selected:
                                  index == widget.getDoctor() ? true : false,
                              onclick: () {
                                setState(() {
                                  if (widget.getDoctor() == index) {
                                    widget.setDoctor(-1);
                                    widget.tmpInfo['medecin_traitant'] = "";
                                  } else {
                                    widget.setDoctor(index);
                                  }
                                  if (widget.getDoctor() != -1) {
                                    widget.tmpInfo['medecin_traitant'] =
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
      ),
    );
  }
}

// ignore: must_be_immutable
class Body3 extends StatefulWidget {
  final Function(int) updateSelectedIndex;
  Map<String, dynamic> tmpInfo;
  List<Map<String, dynamic>> tmpTraitments;
  final Function refresh;
  Body3({
    super.key,
    required this.updateSelectedIndex,
    required this.tmpInfo,
    required this.refresh,
    required this.tmpTraitments,
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

  void addNewTraitement(
      String name, Map<String, dynamic> treatments, bool stillRelevant) {
    setState(() {
      widget.tmpInfo['medical_antecedents'].add({
        "name": name,
        "treatments": treatments["treatments"],
        "still_relevant": stillRelevant,
      });
      widget.tmpTraitments.add({
        "name": name,
        "treatments": treatments["treatments"],
        "still_relevant": stillRelevant,
      });
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
                                      if (widget
                                          .tmpInfo['medical_antecedents'][i]
                                              ['treatments']
                                          .isEmpty) {
                                        return;
                                      }
                                      WoltModalSheet.show<void>(
                                        context: context,
                                        pageIndexNotifier: pageIndex,
                                        pageListBuilder: (modalSheetContext) {
                                          return [
                                            infoTraitement(
                                              context,
                                              widget.tmpInfo[
                                                  'medical_antecedents'][i],
                                            ),
                                          ];
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
                                        setState(() {
                                          widget.tmpInfo['medical_antecedents']
                                              .removeAt(i);
                                          widget.tmpTraitments.removeAt(i);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                      ],
                    ),
                  ));
            }
          },
        ),
      ),
      const SizedBox(height: 16),
      Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        spacing: 12,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.42,
            child: Buttons(
              variant: Variante.secondary,
              size: SizeButton.sm,
              msg: const Text('Revenir en arrière'),
              onPressed: () {
                widget.updateSelectedIndex(1);
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.42,
            child: Buttons(
              variant: Variante.validate,
              size: SizeButton.sm,
              msg: const Text('Confirmer'),
              onPressed: () {
                int poids = int.parse(widget.tmpInfo['poids']);
                int taille = int.parse(widget.tmpInfo['taille']);

                String day =
                    widget.tmpInfo['date_de_naissance']?.substring(0, 2) ??
                        '00';
                String month =
                    widget.tmpInfo['date_de_naissance']?.substring(3, 5) ??
                        '00';
                String year =
                    widget.tmpInfo['date_de_naissance']?.substring(6, 10) ??
                        '0000';
                int date = DateTime.parse('$year-$month-$day')
                        .millisecondsSinceEpoch ~/
                    1000;

                final Map<String, Object> body = {
                  "name": widget.tmpInfo['Nom'],
                  "firstname": widget.tmpInfo['Prenom'],
                  "birthdate": date,
                  "sex": widget.tmpInfo['sexe'],
                  "weight": poids,
                  "height": taille,
                  "primary_doctor_id": widget.tmpInfo['medecin_traitant'],
                  "medical_antecedents": widget.tmpTraitments,
                };
                putInformationPatient(context, body, widget.tmpInfo['id'])
                    .then((value) => {
                          if (value == true)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SuccessLoginSnackBar(
                                      message:
                                          "Informations mises à jour avec succès",
                                      context: context)),
                              Navigator.pop(context),
                              widget.refresh()
                            }
                          else
                            {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  ErrorLoginSnackBar(
                                      message:
                                          "Erreur lors de la mises à jour des informations",
                                      // ignore: use_build_context_synchronously
                                      context: context))
                            }
                        });
              },
            ),
          ),
        ],
      ),
    ]);
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
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: BodyAddTraitement(
        pageIndex: pageIndex,
        updateData: updateData,
        addNewTraitement: addNewTraitement,
      ),
    ),
  );
}

class BodyAddTraitement extends StatefulWidget {
  final ValueNotifier<int> pageIndex;
  final Function(int) updateData;
  final Function addNewTraitement;
  const BodyAddTraitement(
      {super.key,
      required this.pageIndex,
      required this.updateData,
      required this.addNewTraitement});

  @override
  State<BodyAddTraitement> createState() => _BodyAddTraitementState();
}

class _BodyAddTraitementState extends State<BodyAddTraitement> {
  String name = "";
  bool stillRelevant = false;

  Map<String, dynamic> treatments = {"treatments": [], "name": "Parasetamole"};

  @override
  void initState() {
    super.initState();
    setState(() {
      treatments = {"treatments": [], "name": name};
    });
  }

  List<Map<String, dynamic>> medicaments = [];
  List<String> medNames = [];

  void updateMedicament(Map<String, dynamic> medicament) async {
    setState(() {
      treatments['treatments'].add(medicament);
    });
    fetchData();
  }

  Future<bool> fetchData() async {
    medicaments = await getMedecines();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
                  startUppercase: false,
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
                              widget.addNewTraitement,
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
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
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
                    if (name == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          ErrorLoginSnackBar(
                              message: "Ajoutez un nom", context: context));
                      return;
                    }
                    widget.addNewTraitement(name, treatments, stillRelevant);
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      ],
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
                startUppercase: false,
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
