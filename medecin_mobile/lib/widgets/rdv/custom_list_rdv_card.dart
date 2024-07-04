// ignore_for_file: must_be_immutable

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/diagnostic_services.dart';
import 'package:edgar_pro/services/doctor_services.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/services/rdv_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/Diagnostic/chat_widget.dart';
import 'package:edgar_pro/widgets/Diagnostic/custom_modal_card.dart';
import 'package:edgar_pro/widgets/Diagnostic/progress_bar_disease.dart';
import 'package:edgar_pro/widgets/Diagnostic/symptoms_list.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_modal.dart';
import 'package:edgar_pro/widgets/field_custom.dart';
import 'package:edgar_pro/widgets/rdv/modif_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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
          startUppercase: false,
        ),
      ],
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.427,
            child: Buttons(
              variant: Variante.secondary,
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
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.427,
            child: Buttons(
              variant: Variante.delete,
              size: SizeButton.sm,
              msg: const Text('Oui, je suis sûr'),
              onPressed: () {
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
      title: "",
      subtitle: "",
      icon: const IconModal(
        type: ModalType.info,
        icon: Icon(BootstrapIcons.pen_fill),
      ),
      body: [ModifList(rdvInfo: rdvInfo, updateFunc: updateAppointment)],
    );
  }

  Future<void> _loadAppointment() async {
    getPatientById(widget.rdvInfo['id_patient']).then((value) {
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
            WoltModalSheet.show<void>(
              context: context,
              pageListBuilder: (modalSheetContext) {
                return [
                  navModal(modalSheetContext, patientInfo["Nom"],
                      patientInfo["Prenom"], widget.rdvInfo),
                ];
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
                            variant: Variante.delete,
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
                            variant: Variante.secondary,
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

  SliverWoltModalSheetPage navModal(BuildContext context, String name,
      String firstname, Map<String, dynamic> rdvInfo) {
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

    Future<bool> loadInfo() async {
      diagnostic = await getSummary(rdvInfo["session_id"]);
      return true;
    }

    Future<bool> loadDoctor() async {
      docs = await getAllDoctor();
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
                  // ModalMedicFolder
                  loadDoctor().then((value) => WoltModalSheet.show(
                        context: context,
                        pageListBuilder: (BuildContext context) {
                          return [];
                        },
                      ));
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
          ]),
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
