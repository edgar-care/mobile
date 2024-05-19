import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/diagnostic_services.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/Diagnostic/chat_widget.dart';
import 'package:edgar_pro/widgets/Diagnostic/progress_bar_disease.dart';
import 'package:edgar_pro/widgets/Diagnostic/symptoms_list.dart';
import 'package:edgar_pro/widgets/Diagnostic/custom_modal_card.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/login_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// ignore: must_be_immutable
class DiagnosticCard extends StatelessWidget {
  Map<String, dynamic> rdvInfo;
  int type;
  Function refresh;
  DiagnosticCard({super.key, required this.rdvInfo, required this.type, required this.refresh});

  ValueNotifier<int> pageIndexNotifier = ValueNotifier<int>(0);
  Map<String, dynamic> patientInfo = {};

  Future<void> _loadAppointment() async {
    patientInfo = await getPatientById(rdvInfo['id_patient']);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    var color;
    switch (type) {
      case 0:
        color = AppColors.blue200;
      case 1:
        color = AppColors.green500;
      case 2:
        color = AppColors.red500;
    }

    DateTime start =
        DateTime.fromMillisecondsSinceEpoch(rdvInfo['start_date'] * 1000);
    DateTime end =
        DateTime.fromMillisecondsSinceEpoch(rdvInfo['end_date'] * 1000);
    return FutureBuilder(
      future: _loadAppointment(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AppColors.blue200, width: 2.0),
              ),
              child: InkWell(
                  onTap: () {
                    WoltModalSheet.show<void>(
                       onModalDismissedWithBarrierTap: () {
                        Navigator.pop(context);
                        pageIndexNotifier.value = 0;
                      },
                      onModalDismissedWithDrag: () {
                        Navigator.pop(context);
                        pageIndexNotifier.value = 0;
                      },
                      pageIndexNotifier: pageIndexNotifier,
                      context: context,
                      pageListBuilder: (modalSheetContext) {
                        return [
                          navModal(
                              modalSheetContext,
                              patientInfo["Nom"],
                              patientInfo["Prenom"],
                              rdvInfo,
                              pageIndexNotifier),
                          validateModal(
                              modalSheetContext, pageIndexNotifier, rdvInfo),
                          cancelModal(
                              modalSheetContext, pageIndexNotifier, rdvInfo),
                        ];
                      },
                    );
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(children: [
                        Container(
                          height: 39,
                          width: 4,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${patientInfo["Nom"]} ${patientInfo["Prenom"]}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              Row(children: [
                                Text(DateFormat('yMd', 'fr').format(start),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins')),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text("-",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins')),
                                const SizedBox(
                                  width: 4,
                                ),
                                Row(children: [
                                  Text(DateFormat('jm', 'fr').format(start),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins')),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  const Icon(
                                    BootstrapIcons.arrow_right,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(DateFormat('jm', 'fr').format(end),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins')),
                                ]),
                              ])
                            ]),
                      const Spacer(),
                      const Icon(
                        BootstrapIcons.chevron_right,
                        size: 16,),
                      ]))));
        } else {
          return Skeletonizer(
              enabled: true,
              child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AppColors.blue200, width: 2.0),
              ),
              child: InkWell(
                  onTap: () {
                    WoltModalSheet.show<void>(
                      onModalDismissedWithBarrierTap: () {

                        pageIndexNotifier.value = 0;
                      },
                      onModalDismissedWithDrag: () {
                        pageIndexNotifier.value = 0;
                      },
                      pageIndexNotifier: pageIndexNotifier,
                      context: context,
                      pageListBuilder: (modalSheetContext) {
                        return [
                          navModal(
                              modalSheetContext,
                              patientInfo["Nom"],
                              patientInfo["Prenom"],
                              rdvInfo,
                              pageIndexNotifier),
                          validateModal(
                              modalSheetContext, pageIndexNotifier, rdvInfo),
                          cancelModal(
                              modalSheetContext, pageIndexNotifier, rdvInfo),
                        ];
                      },
                    );
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(children: [
                        Container(
                          height: 50,
                          width: 4,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${patientInfo["Nom"]} ${patientInfo["Prenom"]}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(children: [
                                Text(DateFormat('yMd', 'fr').format(start),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins')),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text("-",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins')),
                                const SizedBox(
                                  width: 4,
                                ),
                                Row(children: [
                                  Text(DateFormat('jm', 'fr').format(start),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins')),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  const Icon(
                                    BootstrapIcons.arrow_right,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(DateFormat('jm', 'fr').format(end),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins')),
                                ]),
                              ])
                            ]),
                      const Spacer(),
                      const Icon(
                        BootstrapIcons.chevron_right,
                        size: 16,),
                      ]))))
          );
        }
      },
    );
  }

  SliverWoltModalSheetPage navModal(BuildContext context, String name,
      String firstname, Map<String, dynamic> rdvInfo, ValueNotifier pageindex) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(rdvInfo['start_date'] * 1000);
    String dateString = DateFormat('yMMMd', 'fr').format(date).toString();
    String timeStringStart = DateFormat('HH:mm', 'fr').format(date).toString();
    String timeStringEnd = DateFormat('HH:mm', 'fr')
        .format(date.add(const Duration(minutes: 30)))
        .toString();
    Map<String, dynamic> diagnostic = {};

    Future<bool> loadInfo() async {
      diagnostic = await getSummary(rdvInfo["session_id"]);
      return true;
    }
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(children: [
            Column(children: [
              Text(
                'Rendez-vous de $firstname $name',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '$dateString de $timeStringStart à $timeStringEnd',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ]),
            const SizedBox(height: 16),
            CustomModalCard(
                text: 'Dossier médical',
                icon: BootstrapIcons.postcard_heart_fill,
                ontap: () {
                  WoltModalSheet.show(
                    context: context,
                    pageListBuilder: (BuildContext context) {
                      return [
                        medicalFolderModal(context),
                      ];
                    },
                  );
                }),
            const SizedBox(height: 4),
            CustomModalCard(
              text: 'Diagnostic',
              icon: BootstrapIcons.heart_pulse_fill,
              ontap: () {
                loadInfo().then((value) => WoltModalSheet.show(
                      context: context,
                      pageListBuilder: (BuildContext context) {
                        return [
                          diagnosticModal(context, diagnostic),
                        ];
                      },
                    ));
              },
            ),
            const SizedBox(height: 4),
            CustomModalCard(
              text: 'Retranscription du chat',
              icon: BootstrapIcons.file_text_fill,
              ontap: () {
                loadInfo().then((value) => WoltModalSheet.show(
                      context: context,
                      pageListBuilder: (BuildContext context) {
                        return [
                          chatModal(context, diagnostic),
                        ];
                      },
                    ));
              },
            ),
            if (rdvInfo['appointment_status'] == 'WAITING_FOR_REVIEW')
            Column(
              children: [
            const SizedBox(height: 12),
            Container(height: 2, color: AppColors.blue200),
            const SizedBox(height: 12),
            Buttons(
              variant: Variante.validate,
              size: SizeButton.sm,
              msg: const Text(
                'Valider le rendez-vous',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                pageIndexNotifier.value = 1;
              },
            ),
            const SizedBox(height: 4),
            Buttons(
              variant: Variante.delete,
              size: SizeButton.sm,
              msg: const Text(
                'Annuler le rendez-vous',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                pageIndexNotifier.value = 2;
              },
            )
          ]),
          ]),
        ),
      ),
    );
  }

  SliverWoltModalSheetPage validateModal(BuildContext context,
      ValueNotifier pageIndexNotifier, Map<String, dynamic> rdvInfo) {
    return WoltModalSheetPage(
      hasTopBarLayer: false,
      backgroundColor: AppColors.white,
      hasSabGradient: false,
      enableDrag: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: SizedBox(
          child: Column(
            children: [
              Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: AppColors.green200,
                  ),
                  child: const Icon(
                    BootstrapIcons.check,
                    color: AppColors.green700,
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
                "En acceptant ce rendez-vous, vous assurez l'utilité de celui-ci auprès de votre patient.",
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
                        pageIndexNotifier.value = 0;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: Buttons(
                      variant: Variante.validate,
                      size: SizeButton.sm,
                      msg: const Text('Oui, je suis sûr'),
                      onPressed: () {
                        postDiagValidation(context, rdvInfo['id'], true, '');
                        Navigator.pop(context);
                        refresh();
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

  SliverWoltModalSheetPage cancelModal(BuildContext context,
      ValueNotifier pageIndexNotifier, Map<String, dynamic> rdvInfo) {
    String cancelreason = '';
    String healthmethod = '';
    return WoltModalSheetPage(
      hasTopBarLayer: false,
      backgroundColor: AppColors.white,
      hasSabGradient: false,
      enableDrag: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: SizedBox(
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
                "Si vous supprimer ce rendez-vous, vous ne pourrez plus revenir en arrière.",
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Text(
                "La raison de l'annulation",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                    ),
              ),
              const SizedBox(
                height: 4,
              ),
              AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.blue500, width: 2),
          ),
          child:
              TextFormField(
                maxLines: 3,
                minLines: 3,
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      color: AppColors.grey400,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textBaseline: TextBaseline.ideographic,
                    ),
                    hintText: 'Renseigner la raison de l\'annulation',
                    alignLabelWithHint: true,),
                    onChanged: (value) => cancelreason = value,
              ),),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Méthode de soins",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 4,
              ),
              AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.blue500, width: 2),
          ),
          child:
              TextFormField(
                maxLines: 2,
                minLines: 2,
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      color: AppColors.grey400,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textBaseline: TextBaseline.ideographic,
                    ),
                    hintText: 'Renseigner les méthodes de soins pour diminuer les symptômes',
                    alignLabelWithHint: true,),
                    onChanged: (value) => cancelreason = value,
              ),),
                ]),
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
                        pageIndexNotifier.value = 0;
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
                        if(cancelreason == ''){
                          ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
                              context: context,
                              message: 'Veuillez renseigner la raison de l\'annulation'));
                        }
                        else {
                          healthmethod = healthmethod;
                          postDiagValidation(
                              context, rdvInfo['id'], false, cancelreason);
                          Navigator.pop(context);
                          refresh();
                        }
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

  SliverWoltModalSheetPage diagnosticModal(
      BuildContext context, Map<String, dynamic> summary) {
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: BodySummary(summary: summary),
          )),
    );
  }

  SliverWoltModalSheetPage chatModal(
      BuildContext context, Map<String, dynamic> summary) {
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                decoration: BoxDecoration(
                  color: AppColors.blue50,
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: AppColors.blue200, width: 1.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        BootstrapIcons.file_text_fill,
                        color: AppColors.blue700,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Retranscription du chat',
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                )),
            const SizedBox(
              height: 16,
            ),
            ChatList(summary: summary),
            const SizedBox(
              height: 16,
            ),
            Buttons(
              variant: Variante.secondary,
              size: SizeButton.sm,
              msg: const Text(
                "Revenir en arrière",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue700),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]),
        ),
      ),
    );
  }

  SliverWoltModalSheetPage medicalFolderModal(BuildContext context) {
    return WoltModalSheetPage(
        backgroundColor: AppColors.white,
        hasTopBarLayer: false,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  decoration: BoxDecoration(
                    color: AppColors.blue50,
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: AppColors.blue200, width: 1.0),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          BootstrapIcons.postcard_heart_fill,
                          color: AppColors.blue700,
                          size: 16,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Dossier médical',
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 16,
              ),
              const Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.vertical,
                spacing: 12,
                children: [
                  Text('Prénom: Test',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600)),
                  Text('Nom: Nom',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600)),
                  Text('Date de naissance: 22/04/2022',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600)),
                  Text('Sexe: MASCULIN',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600)),
                  Text('Taille: 0.5m',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600)),
                  Text('Poids: 10kg',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600)),
                  Text('Médecin traitant: 1234',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600)),
                  Text('Antécédants médicaux et sujets de santé:',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Buttons(
                variant: Variante.secondary,
                size: SizeButton.sm,
                msg: const Text(
                  "Revenir en arrière",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue700),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]),
          ),
        ));
  }
}

class BodySummary extends StatelessWidget {
  final Map<String, dynamic> summary;
  const BodySummary({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    Color circleColor;
    List<Map<String, dynamic>> disease = [];
    List<String> symptoms = [];
    List<String> mbSymptoms = [];
    List<String> notSymptoms = [];
    int value = (summary['fiability'] * 100).round();
    switch (value) {
      case < 30:
        circleColor = AppColors.red600;
      case < 60:
        circleColor = AppColors.orange600;
      default:
        circleColor = AppColors.green600;
    }
    for (int i = 0; i < summary['diseases'].length; i++) {
      disease.add(summary['diseases'][i]);
    }
    for (int i = 0; i < summary['symptoms'].length; i++) {
      if (summary['symptoms'][i]['presence'] == true) {
        symptoms.add(summary['symptoms'][i]['name']);
      } else if (summary['symptoms'][i]['presence'] == null) {
        mbSymptoms.add(summary['symptoms'][i]['name']);
      } else {
        notSymptoms.add(summary['symptoms'][i]['name']);
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              color: AppColors.blue50,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: AppColors.blue200, width: 1.0),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    BootstrapIcons.heart_pulse_fill,
                    color: AppColors.blue700,
                    size: 16,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Diagnostic',
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins'),
                  ),
                ],
              ),
            )),
        const SizedBox(
          height: 16,
        ),
        Wrap(
          runSpacing: 8,
          children: [
            const Text('Maladies suggérées',
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins')),
            Row(
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        width: 75,
                        height: 75,
                        child: CircularProgressIndicator(
                          strokeWidth: 7.0,
                          strokeCap: StrokeCap.round,
                          value: value / 100,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(circleColor),
                          backgroundColor: AppColors.blue100,
                        ),
                      ),
                    ),
                    Center(
                        child: Wrap(
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                          const Text('Fiabilité',
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins')),
                          Text('$value%',
                              style: TextStyle(
                                  color: circleColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins'))
                        ])),
                  ],
                ),
                const SizedBox(
                  width: 32,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < disease.length; i++)
                      ProgressBarDisease(
                          value: (disease[i]['presence'] * 100).round(),
                          disease: disease[i]['name']),
                  ],
                )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap(
          direction: Axis.vertical,
          spacing: 4,
          children: [
            if (symptoms.isNotEmpty)
              const Text('Symptômes présents',
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins')),
            SymptomsList(symptoms: symptoms),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        if (notSymptoms.isNotEmpty)
          Wrap(
            direction: Axis.vertical,
            spacing: 4,
            children: [
              const Text('Symptômes non présents',
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins')),
              SymptomsList(symptoms: notSymptoms),
            ],
          ),
        const SizedBox(
          height: 16,
        ),
        if (mbSymptoms.isNotEmpty)
          Wrap(
            direction: Axis.vertical,
            spacing: 4,
            children: [
              const Text('Symptômes potentiellement présents',
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins')),
              SymptomsList(symptoms: mbSymptoms),
            ],
          ),
        const SizedBox(
          height: 16,
        ),
        Buttons(
          variant: Variante.secondary,
          size: SizeButton.sm,
          msg: const Text(
            "Revenir en arrière",
            style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: AppColors.blue700),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
