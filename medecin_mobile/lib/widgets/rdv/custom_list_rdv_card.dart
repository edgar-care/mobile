// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/diagnostic_services.dart';
import 'package:edgar_pro/services/doctor_services.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/services/rdv_service.dart';
import 'package:edgar/colors.dart';
import 'package:edgar_pro/widgets/Diagnostic/chat_widget.dart';
import 'package:edgar_pro/widgets/Diagnostic/custom_modal_card.dart';
import 'package:edgar_pro/widgets/Diagnostic/progress_bar_disease.dart';
import 'package:edgar_pro/widgets/Diagnostic/symptoms_list.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_pro/widgets/rdv/modif_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:provider/provider.dart';

class CustomListRdvCard extends StatefulWidget {
  CustomListRdvCard(
      {super.key,
      required this.rdvInfo,
      required this.delete,
      required this.old});
  bool old;
  Function delete;
  Map<String, dynamic> rdvInfo;

  @override
  State<CustomListRdvCard> createState() => _CustomListRdvCardState();
}

class _CustomListRdvCardState extends State<CustomListRdvCard> {
  Map<String, dynamic> patientInfo = {};

  @override
  initState() {
    super.initState();
    _loadAppointment();
  }

  void updateAppointment(DateTime start) {
    setState(() {
      widget.rdvInfo['start_date'] = (start.millisecondsSinceEpoch ~/ 1000);
      widget.rdvInfo['end_date'] =
          (start.add(const Duration(minutes: 30)).millisecondsSinceEpoch ~/
              1000);
    });
  }

  Widget deleteAppointment(String id) {
    String cancelreason = '';
    return ModalContainer(
      title: "Êtes-vous sûr ?",
      subtitle:
          "Si vous supprimer ce rendez-vous, vous ne pourrez plus revenir en arrière",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.x,
          color: AppColors.red700,
          size: 18,
        ),
        type: ModalType.error,
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
        CustomField(
          label: "Renseigner la raison de l'annulation",
          onChanged: (value) => cancelreason = value,
          keyboardType: TextInputType.text,
          action: TextInputAction.next,
        ),
      ],
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child:
             Buttons(
              variant: Variant.secondary,
              size: SizeButton.sm,
              msg: const Text('Annuler'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child:
            Buttons(
              variant: Variant.delete,
              size: SizeButton.sm,
              msg: const Text('Oui, je suis sûr'),
              onPressed: () {
                if (cancelreason.isEmpty) {
                  TopErrorSnackBar(message: "Veuillez renseigner une raison d'annulation").show(context);
                  return;
                }
                cancelAppointments(id, context, cancelreason);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget updateAppointmentModal(BuildContext context,
      Map<String, dynamic> rdvInfo, Function updateAppointment) {
    return ModalContainer(
      title: "Modifier le rendez-vous",
      subtitle: "Modifier les informations du rendez-vous",
      icon: const IconModal(
        type: ModalType.info,
        icon: Icon(
          BootstrapIcons.pen_fill,
          color: AppColors.blue700,
          size: 18,
        ),
      ),
      body: [
        ModifList(rdvInfo: rdvInfo, updateFunc: updateAppointment),
      ],
    );
  }

  Future<void> _loadAppointment() async {
    getPatientById(widget.rdvInfo['id_patient'], context).then((value) {
      setState(() {
        patientInfo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime start = DateTime.fromMillisecondsSinceEpoch(
        widget.rdvInfo['start_date'] * 1000);
    DateTime end =
        DateTime.fromMillisecondsSinceEpoch(widget.rdvInfo['end_date'] * 1000);
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
                      navmodal(patientInfo["Nom"], patientInfo["Prenom"],
                          widget.rdvInfo)
                    ]);
                  },
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("${patientInfo["Nom"]} ${patientInfo["Prenom"]}",
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
              ]),
              if (!widget.old)
                Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: Buttons(
                            variant: Variant.delete,
                            size: SizeButton.sm,
                            msg: const Text('Annuler'),
                            onPressed: () {
                              final model = Provider.of<BottomSheetModel>(
                                  context,
                                  listen: false);
                              model.resetCurrentIndex();

                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) {
                                  return Consumer<BottomSheetModel>(
                                    builder: (context, model, child) {
                                      return ListModal(model: model, children: [
                                        deleteAppointment(widget.rdvInfo['id'])
                                      ]);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: Buttons(
                            variant: Variant.secondary,
                            size: SizeButton.sm,
                            msg: const Text('Modifier'),
                            onPressed: () {
                              final model = Provider.of<BottomSheetModel>(
                                  context,
                                  listen: false);
                              model.resetCurrentIndex();

                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) {
                                  return Consumer<BottomSheetModel>(
                                    builder: (context, model, child) {
                                      return ListModal(model: model, children: [
                                        updateAppointmentModal(context,
                                            widget.rdvInfo, updateAppointment)
                                      ]);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget navmodal(String name, String firstname, Map<String, dynamic> rdvInfo) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(rdvInfo['start_date'] * 1000);
    String dateString = DateFormat('yMMMd', 'fr').format(date).toString();
    String timeStringStart = DateFormat('HH:mm', 'fr').format(date).toString();
    String timeStringEnd = DateFormat('HH:mm', 'fr')
        .format(date.add(const Duration(minutes: 30)))
        .toString();
    Map<String, dynamic> diagnostic = {};
    // ignore: unused_local_variable
    List<dynamic> docs = [];
    // ignore: unused_local_variable
    int doctorindex = -1;

    Future<bool> loadInfo() async {
      diagnostic = await getSummary(rdvInfo["session_id"], context);
      return true;
    }

    // ignore: unused_element
    Future<bool> loadDoctor() async {
      docs = await getAllDoctor(context);
      doctorindex = docs
          .indexWhere((doc) => doc['id'] == patientInfo['medecin_traitant']);
      return true;
    }

    return ModalContainer(
      title: 'Rendez-vous de $firstname $name',
      subtitle: '$dateString de $timeStringStart à $timeStringEnd',
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.alarm,
          color: AppColors.grey600,
          size: 18,
        ),
        type: ModalType.info,
      ),
      body: [
        CustomModalCard(
            text: 'Dossier médical',
            icon: BootstrapIcons.postcard_heart_fill,
            ontap: () {}),
        const SizedBox(height: 4),
        CustomModalCard(
          text: 'Diagnostic',
          icon: BootstrapIcons.heart_pulse_fill,
          ontap: () {
            loadInfo().then(
              (value) {
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
                          DiagnosticModal(
                            summary: diagnostic,
                          ),
                        ]);
                      },
                    );
                  },
                );
              },
            );
          },
        ),
        const SizedBox(height: 4),
        CustomModalCard(
          text: 'Retranscription du chat',
          icon: BootstrapIcons.file_text_fill,
          ontap: () {
            loadInfo().then(
              (value) {
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
                          chatModal(diagnostic),
                        ]);
                      },
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

  Widget chatModal(Map<String, dynamic> summary) {
    return ModalContainer(
      title: "Retranscription du chat",
      subtitle: "Voici l'échange entre notre assistant et le patient",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.file_text_fill,
          color: AppColors.grey600,
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

  // SliverWoltModalSheetPage medicalFolderModal(
  //     BuildContext context, List<dynamic> docs, int doctorindex) {
  //   return WoltModalSheetPage(
  //       backgroundColor: AppColors.white,
  //       hasTopBarLayer: false,
  //       child: MedicalFolderBody(
  //         patientInfo: patientInfo,
  //         docs: docs,
  //         doctorindex: doctorindex,
  //       ));
  // }
}

class DiagnosticModal extends StatefulWidget {
  final Map<String, dynamic> summary;
  const DiagnosticModal({super.key, required this.summary});

  @override
  State<DiagnosticModal> createState() => _DiagnosticModalState();
}

class _DiagnosticModalState extends State<DiagnosticModal> {
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
      subtitle: "Diagnostic du patient",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.heart_pulse_fill,
          color: AppColors.grey600,
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
