// ignore_for_file: must_be_immutable

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_patient_card_info.dart';
import 'package:edgar_pro/widgets/rdv/modif_list.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class CustomListRdvCard extends StatefulWidget {
  int id;
  CustomListRdvCard({super.key, required this.id});

  @override
  State<CustomListRdvCard> createState() => _CustomListRdvCardState();
}

class _CustomListRdvCardState extends State<CustomListRdvCard> {

//get patient avec l'id qu'on va avoir en parametre


  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.white,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.blue200, width: 2.0),
        ),
        child: InkWell(
          onTap: () {
            Logger().d('oui');
            // WoltModalSheet.show<void>(
            //     context: context,
            //     pageListBuilder: (modalSheetContext) {
            //       return [                  
            //         patientInfo(context, patients, modalSheetContext,),
            //       ];
            //     },);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Patient XX", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8,),
                const Row(
                  children: [
                    Text("18/07/2023", style: TextStyle(fontSize: 12)),
                    SizedBox(width: 4,),
                    Text("-", style: TextStyle(fontSize: 12)),
                    SizedBox(width: 4,),
                    Text("15h00 --> 16h00", style: TextStyle(fontSize: 12)),
                  ]
                ),
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
                        Logger().d('Annuler');
                //         WoltModalSheet.show<void>(
                // context: context,
                // pageListBuilder: (modalSheetContext) {
                //   return [                  
                //     deleteAppointment(context),
                //   ];
                // },);
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
                        Logger().d('Modifier');
                        // WoltModalSheet.show<void>(
                        //   context: context,
                        //   pageListBuilder: (modalSheetContext) {
                        //     return [                  
                        //       updateAppointment(context),
                        //     ];
                        //   },);
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
}


class PatienInfo extends StatefulWidget {
  Map<String, dynamic> patient;
  PatienInfo({super.key, required this.patient});

  @override
  State<PatienInfo> createState() => _PatienInfoState();
}

class _PatienInfoState extends State<PatienInfo> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 62),
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
                                widget.patient['prenom'],
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
                                widget.patient['nom'],
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
                                widget.patient['date'],
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
                                widget.patient['taille'],
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
                                widget.patient['poids'],
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
                                widget.patient['medecin'],
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
                              const Text(
                                "Allergies:",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              PatientInfoCard(
                                  context: context,
                                  patient: widget.patient,
                                  champ: 'allergies',
                                  isDeletable: false),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Maladies:",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              PatientInfoCard(
                                context: context,
                                patient: widget.patient,
                                champ: 'maladies',
                                isDeletable: false,
                              ),
                            ]),
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Traitements:",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              PatientInfoCard(
                                context: context,
                                patient: widget.patient,
                                champ: 'traitements',
                                isDeletable: false,
                              ),
                            ]),
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

  WoltModalSheetPage patientInfo(
      BuildContext context,
      Map<String, dynamic> patient,
      BuildContext modalSheetContext,) {
    return WoltModalSheetPage.withSingleChild(
      child: PatienInfo(patient: patient,),
      backgroundColor: AppColors.white,
      enableDrag: true,
      hasSabGradient: true,
      hasTopBarLayer: false,
    );
  }

  WoltModalSheetPage deleteAppointment(BuildContext context) {
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

   WoltModalSheetPage updateAppointment(BuildContext context) {
    return WoltModalSheetPage.withSingleChild(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: 
              Column(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: AppColors.grey200,
                    ),
                    child : const Icon(BootstrapIcons.calendar2_week_fill, size: 16, color: AppColors.grey700,)),
                  const SizedBox(height: 8,),
                  const Text("Modification du rendez-vous", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),),
                  const Text("Date rdv", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: AppColors.green500),),
                  const SizedBox(height: 16,),
                  const Expanded(
                    child: ModifList()),
                  const SizedBox(height: 16,),
                  Buttons(variant: Variante.primary, size: SizeButton.sm, msg: const Text("Valider le changement")),
                ],)
        ),
      )
    );
  }