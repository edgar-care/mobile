// ignore_for_file: must_be_immutable

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/services/rdv_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/rdv/modif_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class CustomListRdvCard extends StatefulWidget {
  CustomListRdvCard({super.key, required this.rdvInfo, required this.delete, required this.old});
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
      widget.rdvInfo['end_date'] = (start.add(const Duration(minutes: 30)).millisecondsSinceEpoch ~/ 1000);
    });
  }

    SliverWoltModalSheetPage patientInfoModal(
      BuildContext context,
      Map<String, dynamic> patient,
      BuildContext modalSheetContext,) {
    return WoltModalSheetPage(
      child: PatienInfo(patient: patient,),
      backgroundColor: AppColors.white,
      enableDrag: true,
      hasSabGradient: true,
      hasTopBarLayer: false,
    );
  }

   SliverWoltModalSheetPage deleteAppointment(BuildContext context, String id) {
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
                "Si vous supprimez le rendez-vous, vous ne pourrez plus revenir en arrière.",
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
                        Navigator.pop(context);
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
                        cancelAppointments(id, context);
                        widget.delete();
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

   SliverWoltModalSheetPage updateAppointmentModal(BuildContext context, Map<String, dynamic> rdvInfo, Function updateAppointment) {
    
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: ModifList(rdvInfo: rdvInfo, updateFunc: updateAppointment),
    );
  }

  Future<void> _loadAppointment() async {
  var temp = await getPatientById(widget.rdvInfo['id_patient']);
      if (temp.isNotEmpty) {
        setState(() {
          patientInfo = temp;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    DateTime start = DateTime.fromMillisecondsSinceEpoch(widget.rdvInfo['start_date'] * 1000);
    DateTime end =  DateTime.fromMillisecondsSinceEpoch(widget.rdvInfo['end_date'] * 1000);
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
                },);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${patientInfo["Nom"]} ${patientInfo["Prenom"]}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8,),
                Row(
                  children: [
                    Text(DateFormat('yMd', 'fr').format(start), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                    const SizedBox(width: 4,),
                    const Text("-", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                    const SizedBox(width: 4,),
                    Row(children: [
                      Text(DateFormat('jm', 'fr').format(start), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                      const Text(" --> ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                      Text(DateFormat('jm', 'fr').format(end), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                    ]),
                  ]
                ),
                if (!widget.old) Column(children:[
                const SizedBox(height: 8,),
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
                        WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [                  
                    deleteAppointment(context, widget.rdvInfo['id']),
                  ];
                },);
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
                        WoltModalSheet.show<void>(
                           context: context,
                           pageListBuilder: (modalSheetContext) {
                             return [                  
                               updateAppointmentModal(context, widget.rdvInfo, updateAppointment),
                             ];
                           },);
                      },
                    ),
                  ),
                ],
              ),
              ],
            ),]),
          ),
        ),
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
  @override
  Widget build(BuildContext context) {
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
                                 DateFormat("yMd", "fr").format(DateTime.fromMillisecondsSinceEpoch(widget.patient['date_de_naissance'] * 1000)).toString(),
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
                                "${(widget.patient['taille'] / 100).toString()} m",
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
                                "${widget.patient['poids'].toString()} kg",
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