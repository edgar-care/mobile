// ignore_for_file: use_build_context_synchronously

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/diagnostic_services.dart';
import 'package:edgar_pro/services/doctor_services.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar/colors.dart';
import 'package:edgar_pro/widgets/Diagnostic/chat_widget.dart';
import 'package:edgar_pro/widgets/Diagnostic/progress_bar_disease.dart';
import 'package:edgar_pro/widgets/Diagnostic/symptoms_list.dart';
import 'package:edgar_pro/widgets/Diagnostic/custom_modal_card.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_pro/widgets/custom_patient_card_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DiagnosticCard extends StatefulWidget {
  Map<String, dynamic> rdvInfo;
  int type;
  Function refresh;
  DiagnosticCard(
      {super.key,
      required this.rdvInfo,
      required this.type,
      required this.refresh});

  @override
  State<DiagnosticCard> createState() => _DiagnosticCardState();
}

class _DiagnosticCardState extends State<DiagnosticCard> {
  ValueNotifier<int> pageIndexNotifier = ValueNotifier<int>(0);
  Map<String, dynamic> patientInfo = {};

  Future<void> _loadAppointment() async {
    getPatientById(widget.rdvInfo['id_patient']).then((value) => setState(() {
          patientInfo = value;
        }));
  }

  @override
  void initState() {
    super.initState();
    Logger().d(widget.rdvInfo);
    _loadAppointment();
  }

  @override
  Widget build(BuildContext context) {
    DateTime start = DateTime.fromMillisecondsSinceEpoch(
        widget.rdvInfo['start_date'] * 1000);
    DateTime end =
        DateTime.fromMillisecondsSinceEpoch(widget.rdvInfo['end_date'] * 1000);

    Color color = AppColors.blue200;
    switch (widget.type) {
      case 0:
        color = AppColors.blue200;
      case 1:
        color = AppColors.green500;
      case 2:
        color = AppColors.red500;
    }

    return Skeletonizer(
        enabled: patientInfo.isEmpty,
        child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppColors.blue200, width: 2.0),
            ),
            child: InkWell(
                onTap: () {
                  final model =
                      Provider.of<BottomSheetModel>(context, listen: false);
                  model.resetCurrentIndex();

                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) {
                      return Consumer<BottomSheetModel>(
                        builder: (context, model, child) {
                          return ListModal(model: model, children: [
                            modalNav(context, patientInfo["Nom"],
                                patientInfo["Prenom"], widget.rdvInfo, model),
                            modalCancel(model, widget.rdvInfo),
                            modalValidate(model, widget.rdvInfo)
                          ]);
                        },
                      );
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
                                    fontSize: 16, fontWeight: FontWeight.bold)),
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
                        size: 16,
                      ),
                    ])))));
  }

  Widget modalNav(BuildContext context, String name, String firstname,
      Map<String, dynamic> rdvInfo, BottomSheetModel model) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(rdvInfo['start_date'] * 1000);
    String dateString = DateFormat('yMMMd', 'fr').format(date).toString();
    String timeStringStart = DateFormat('HH:mm', 'fr').format(date).toString();
    String timeStringEnd = DateFormat('HH:mm', 'fr')
        .format(date.add(const Duration(minutes: 30)))
        .toString();
    Map<String, dynamic> diagnostic = {};
    List<dynamic> docs = [];
    int doctorindex = -1;

    Future<bool> loadInfo() async {
      diagnostic = await getSummary(rdvInfo["session_id"]);
      return true;
    }

    Future<bool> loadDoctor() async {
      docs = await getAllDoctor();
      doctorindex = docs
          .indexWhere((doc) => doc['id'] == patientInfo['medecin_traitant']);
      return true;
    }

    return ModalContainer(
      title: 'Rendez-vous de $firstname $name',
      subtitle: '$dateString de $timeStringStart à $timeStringEnd',
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.person,
          color: AppColors.grey700,
          size: 18,
        ),
        type: ModalType.info,
      ),
      body: [
        CustomModalCard(
            text: 'Dossier médical',
            icon: BootstrapIcons.postcard_heart_fill,
            ontap: () {
              final model =
                  Provider.of<BottomSheetModel>(context, listen: false);
              model.resetCurrentIndex();
              loadDoctor().then(
                (value) => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) {
                    return Consumer<BottomSheetModel>(
                      builder: (context, model, child) {
                        return ListModal(model: model, children: [
                          ModalMedicFolder(
                              docs: docs,
                              doctorindex: doctorindex,
                              patientInfo: patientInfo)
                        ]);
                      },
                    );
                  },
                ),
              );
            }),
        const SizedBox(height: 4),
        CustomModalCard(
          text: 'Diagnostic',
          icon: BootstrapIcons.heart_pulse_fill,
          ontap: () {
            final model = Provider.of<BottomSheetModel>(context, listen: false);
            model.resetCurrentIndex();
            loadInfo().then(
              (value) => showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) {
                  return Consumer<BottomSheetModel>(
                    builder: (context, model, child) {
                      return ListModal(
                          model: model,
                          children: [ModalDiagnostic(summary: diagnostic)]);
                    },
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        CustomModalCard(
          text: 'Retranscription du chat',
          icon: BootstrapIcons.file_text_fill,
          ontap: () {
            final model = Provider.of<BottomSheetModel>(context, listen: false);
            model.resetCurrentIndex();
            loadInfo().then(
              (value) => showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) {
                  return Consumer<BottomSheetModel>(
                    builder: (context, model, child) {
                      return ListModal(
                          model: model, children: [modalChat(diagnostic)]);
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
      footer: rdvInfo['appointment_status'] == 'WAITING_FOR_REVIEW'
          ? Column(children: [
              const SizedBox(height: 12),
              Container(height: 2, color: AppColors.blue200),
              const SizedBox(height: 12),
              Buttons(
                variant: Variant.validate,
                size: SizeButton.sm,
                msg: const Text(
                  'Valider le rendez-vous',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  model.changePage(2);
                },
              ),
              const SizedBox(height: 4),
              Buttons(
                variant: Variant.delete,
                size: SizeButton.sm,
                msg: const Text(
                  'Annuler le rendez-vous',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  model.changePage(1);
                },
              )
            ])
          : Container(),
    );
  }

  Widget modalValidate(BottomSheetModel model, Map<String, dynamic> rdvInfo) {
    return ModalContainer(
      title: "Êtes-vous sûr ?",
      subtitle:
          "En acceptant ce rendez-vous, vous assurez l'utilité de celui-ci auprès de votre patient.",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.check,
          color: AppColors.green700,
          size: 18,
        ),
        type: ModalType.success,
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Buttons(
              variant: Variant.secondary,
              size: SizeButton.sm,
              msg: const Text('Annuler'),
              onPressed: () {
                model.changePage(0);
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
              msg: const Text('Oui, je suis sûr'),
              onPressed: () {
                postDiagValidation(context, rdvInfo['id'], true, '', '');
                Navigator.pop(context);
                widget.refresh();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget modalCancel(BottomSheetModel model, Map<String, dynamic> rdvInfo) {
    String cancelreason = '';
    String healthmethod = '';
    return ModalContainer(
      title: "Êtes-vous sûr ?",
      subtitle:
          "Si vous supprimer ce rendez-vous, vous ne pourrez plus revenir en arrière.",
      icon: const IconModal(
        type: ModalType.error,
        icon: Icon(
          BootstrapIcons.x,
          color: AppColors.red700,
          size: 18,
        ),
      ),
      body: [
        const Text(
          "La raison de l'annulation",
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
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
          child: TextFormField(
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
              alignLabelWithHint: true,
            ),
            onChanged: (value) => cancelreason = value,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          "Méthode de soins",
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
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
          child: TextFormField(
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
              hintText:
                  'Renseigner les méthodes de soins pour diminuer les symptômes',
              alignLabelWithHint: true,
            ),
            onChanged: (value) => cancelreason = value,
          ),
        ),
      ],
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Buttons(
              variant: Variant.secondary,
              size: SizeButton.sm,
              msg: const Text('Annuler'),
              onPressed: () {
                model.changePage(0);
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: Buttons(
              variant: Variant.delete,
              size: SizeButton.sm,
              msg: const Text('Oui, je suis sûr'),
              onPressed: () {
                if (cancelreason == '') {
                  ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                      context: context,
                      message:
                          'Veuillez renseigner la raison de l\'annulation'));
                } else {
                  postDiagValidation(context, rdvInfo['id'], false,
                      cancelreason, healthmethod);
                  Navigator.pop(context);
                  widget.refresh();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget modalChat(Map<String, dynamic> summary) {
    return ModalContainer(
      title: "Retranscription du chat",
      subtitle: "Voici la retrencription du chat",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.file_text_fill,
          color: AppColors.grey700,
          size: 18,
        ),
        type: ModalType.info,
      ),
      body: [
        ChatList(summary: summary),
      ],
      footer: Buttons(
        variant: Variant.secondary,
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
    );
  }
}

class ModalDiagnostic extends StatefulWidget {
  final Map<String, dynamic> summary;
  const ModalDiagnostic({super.key, required this.summary});

  @override
  State<ModalDiagnostic> createState() => ModalDiagnosticState();
}

class ModalDiagnosticState extends State<ModalDiagnostic> {
  @override
  Widget build(BuildContext context) {
    Color circleColor;
    List<Map<String, dynamic>> disease = [];
    List<String> symptoms = [];
    List<String> mbSymptoms = [];
    List<String> notSymptoms = [];
    int value = (widget.summary['fiability'] * 100).round();
    switch (value) {
      case < 30:
        circleColor = AppColors.red600;
      case < 60:
        circleColor = AppColors.orange600;
      default:
        circleColor = AppColors.green600;
    }
    for (int i = 0; i < widget.summary['diseases'].length; i++) {
      disease.add(widget.summary['diseases'][i]);
    }
    for (int i = 0; i < widget.summary['symptoms'].length; i++) {
      if (widget.summary['symptoms'][i]['presence'] == true) {
        symptoms.add(widget.summary['symptoms'][i]['name']);
      } else if (widget.summary['symptoms'][i]['presence'] == null) {
        mbSymptoms.add(widget.summary['symptoms'][i]['name']);
      } else {
        notSymptoms.add(widget.summary['symptoms'][i]['name']);
      }
    }
    return ModalContainer(
      title: "Diagnostic",
      subtitle: "Voici le diagnotic",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.heart_pulse_fill,
          color: AppColors.grey700,
          size: 18,
        ),
        type: ModalType.info,
      ),
      body: [
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
      ],
      footer: Buttons(
        variant: Variant.secondary,
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
    );
  }
}

// ignore: must_be_immutable
class ModalMedicFolder extends StatefulWidget {
  Map<String, dynamic> patientInfo;
  List<dynamic> docs;
  int doctorindex;
  ModalMedicFolder(
      {super.key,
      required this.docs,
      required this.doctorindex,
      required this.patientInfo});

  @override
  State<ModalMedicFolder> createState() => _ModalMedicFolderState();
}

class _ModalMedicFolderState extends State<ModalMedicFolder> {
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
    return ModalContainer(
      title: "Dossier médical",
      subtitle: "Dossier médical de ${widget.patientInfo['Prenom']}",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.postcard_heart_fill,
          color: AppColors.grey700,
          size: 18,
        ),
        type: ModalType.info,
      ),
      body: [
        Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.vertical,
          spacing: 12,
          children: [
            Text('Prénom: ${widget.patientInfo['Prenom']}',
                style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500)),
            Text('Nom: ${widget.patientInfo['Nom']}',
                style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500)),
            Text(
                'Date de naissance: ${widget.patientInfo['date_de_naissance']}',
                style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500)),
            Text('Sexe: ${sexe(widget.patientInfo['sexe'])}',
                style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500)),
            Text('Taille: ${taille(widget.patientInfo['taille'])} m',
                style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500)),
            Text('Poids: ${taille(widget.patientInfo['poids'])} kg',
                style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500)),
            if (widget.doctorindex != -1)
              Text(
                  'Médecin traitant: ${widget.docs[widget.doctorindex]['firstname']} ${widget.docs[widget.doctorindex]['name']}',
                  style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500)),
            if (widget.doctorindex == -1)
              const Text('Médecin traitant: Non indiqué',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500)),
            if (widget.patientInfo['medical_antecedents'].isNotEmpty)
              const Text('Antécédants médicaux et sujets de santé: ',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500)),
            if (widget.patientInfo['medical_antecedents'].isNotEmpty)
              SizedBox(
                width: MediaQuery.of(context).size.width - 32,
                child: PatientInfoCard(
                    context: context,
                    tmpTraitments: widget.patientInfo['medical_antecedents']),
              )
          ],
        ),
      ],
      footer: Buttons(
        variant: Variant.secondary,
        size: SizeButton.sm,
        msg: const Text(
          "Revenir en arrière",
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ignore: must_be_immutable