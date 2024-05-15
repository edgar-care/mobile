// ignore_for_file: must_be_immutable

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/services/rdv_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/field_custom.dart';
import 'package:edgar_pro/widgets/rdv/modif_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  SliverWoltModalSheetPage patientInfoModal(
    BuildContext context,
    Map<String, dynamic> patient,
    BuildContext modalSheetContext,
  ) {
    return WoltModalSheetPage(
      child: PatienInfo(
        patient: patient,
      ),
      backgroundColor: AppColors.white,
      enableDrag: true,
      hasSabGradient: true,
      hasTopBarLayer: false,
    );
  }

  SliverWoltModalSheetPage deleteAppointment(BuildContext context, String id) {
    String reason = '';
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(children: [
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
              "Si vous supprimez ce rendez-vous, vous ne pourrez plus revenir en arrière",
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
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'La raison de l\'annulation',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 4,
              ),
              CustomField(
                  startUppercase: false,
                  label: 'Renseignez la raison de l\'annulation',
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    reason = value;
                  }),
            ]),
            const SizedBox(
              height: 32,
            ),
            Row(
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
                      cancelAppointments(id, context, reason);
                      widget.delete();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  SliverWoltModalSheetPage updateAppointmentModal(BuildContext context,
      Map<String, dynamic> rdvInfo, Function updateAppointment) {
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: ModifList(rdvInfo: rdvInfo, updateFunc: updateAppointment),
    );
  }

  Future<void> _loadAppointment() async {
    patientInfo = await getPatientById(widget.rdvInfo['id_patient']);
  }

  @override
  Widget build(BuildContext context) {
    DateTime start = DateTime.fromMillisecondsSinceEpoch(
        widget.rdvInfo['start_date'] * 1000);
    DateTime end =
        DateTime.fromMillisecondsSinceEpoch(widget.rdvInfo['end_date'] * 1000);
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
                  context: context,
                  pageListBuilder: (modalSheetContext) {
                    return [
                      patientInfoModal(context, patientInfo, modalSheetContext),
                    ];
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: Buttons(
                                    variant: Variante.delete,
                                    size: SizeButton.sm,
                                    msg: const Text('Annuler'),
                                    onPressed: () {
                                      WoltModalSheet.show<void>(
                                        context: context,
                                        pageListBuilder: (modalSheetContext) {
                                          return [
                                            deleteAppointment(
                                                context, widget.rdvInfo['id']),
                                          ];
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: Buttons(
                                    variant: Variante.secondary,
                                    size: SizeButton.sm,
                                    msg: const Text('Modifier'),
                                    onPressed: () {
                                      WoltModalSheet.show<void>(
                                        context: context,
                                        pageListBuilder: (modalSheetContext) {
                                          return [
                                            updateAppointmentModal(
                                                context,
                                                widget.rdvInfo,
                                                updateAppointment),
                                          ];
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
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class PatienInfo extends StatefulWidget {
  PatienInfo({super.key, required this.patient});

  Map<String, dynamic> patient;

  @override
  State<PatienInfo> createState() => _PatienInfoState();
}

class _PatienInfoState extends State<PatienInfo> {
  String sexe = '';
  @override
  Widget build(BuildContext context) {
    switch (widget.patient['sexe']) {
      case 'MALE':
        sexe = 'Masculin';
        break;
      case 'FEMALE':
        sexe = 'Feminin';
        break;
      case 'OTHER':
        sexe = 'Autre';
        break;
      default:
        sexe = 'Inconnu';
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Wrap(
          children: [
            Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.blue200, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
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
                              sexe,
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
                              "${(int.parse(widget.patient['taille']) / 100).toString()} m",
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
                              "${(int.parse(widget.patient['poids']) / 100).toString()} kg",
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
                              widget.patient['medecin_traitant'].toString(),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
