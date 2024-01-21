
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_patient_card_info.dart';
import 'package:edgar_pro/widgets/rdv/modif_list.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';


// ignore: must_be_immutable
class CustomListRdv extends StatelessWidget {
  int pressed;
  CustomListRdv({super.key, required this.pressed});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> patients = [
      {
        'prenom': 'Edgar',
        'nom': 'L\'assistant numérique',
        'date': '26/09/2022',
        'sexe': 'Autre',
        'taille': '1,52m',
        'poids': '45kg',
        'medecin': 'Docteur Edgar',
        'allergies': [
          'pollen',
          'pollen',
          'pollen',
          'pollen',
          'pollen',
          'pollen',
          'pollen',
          'pollen',
          'pollen',
          'pollen'
        ],
        'maladies': ['maladies', 'maladies', 'maladies'],
        'traitements': ['traitement', 'traitement', 'traitement'],
      },
      {
        'prenom': 'Edgar',
        'nom': 'L\'assistant',
        'date': '26/09/2021',
        'sexe': 'autre',
        'taille': '1,52m',
        'poids': '45kg',
        'medecin': 'Docteur Edgar',
        'allergies': ['pollen', 'pollen', 'pollen', 'pollen'],
        'maladies': ['maladies', 'maladies', 'maladies'],
        'traitements': ['traitement', 'traitement', 'traitement'],
      },
    ];

    List<Widget> patientRdv = patients.map((patients) {
      return Card(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: AppColors.blue200, width: 2.0),
        ),
        child: InkWell(
          onTap: () {
            WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [                  
                    patientInfo(context, patients, modalSheetContext,),
                  ];
                },);
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
                        WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [                  
                    deletePatient(context),
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
                              updatePatient(context),
                            ];
                          },);
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
    }).toList();


    List<Widget> patientRdv2 = patients.map((patients) {
      return Card(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: AppColors.blue200, width: 2.0),
        ),
        child: InkWell(
          onTap: () {
            WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [                  
                    patientInfo(context, patients, modalSheetContext,),
                  ];
                },);
          },
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Patient XX", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8,),
                Row(
                  children: [
                    Text("18/07/2023", style: TextStyle(fontSize: 12)),
                    SizedBox(width: 4,),
                    Text("-", style: TextStyle(fontSize: 12)),
                    SizedBox(width: 4,),
                    Text("15h00 --> 16h00", style: TextStyle(fontSize: 12)),
                  ]
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();


    return Expanded(
        child: ListView(
      physics: const BouncingScrollPhysics(),
      children: pressed == 0 ? patientRdv : patientRdv2,
    ));

  }

  WoltModalSheetPage patientInfo(
      BuildContext context,
      Map<String, dynamic> patient,
      BuildContext modalSheetContext,) {
    return WoltModalSheetPage.withSingleChild(
      child: SizedBox(
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
                                patient['prenom'],
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
                                patient['nom'],
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
                                patient['date'],
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
                                patient['sexe'],
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
                                patient['taille'],
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
                                patient['poids'],
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
                                patient['medecin'],
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
                                  patient: patient,
                                  champ: 'allergies',
                                  isDeletable: false),
                            ],
                          ),
                          const Text(
                            "Maladies:",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
                          PatientInfoCard(
                            context: context,
                            patient: patient,
                            champ: 'maladies',
                            isDeletable: false,
                          ),
                          const Text(
                            "Traitements:",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
                          PatientInfoCard(
                            context: context,
                            patient: patient,
                            champ: 'traitements',
                            isDeletable: false,
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
      ),
      backgroundColor: AppColors.white,
      enableDrag: true,
      hasSabGradient: true,
      hasTopBarLayer: false,
    );
  }

  WoltModalSheetPage deletePatient(BuildContext context) {
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

   WoltModalSheetPage updatePatient(BuildContext context) {
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
                  Expanded(
                    child: const ModifList()),
                  const SizedBox(height: 16,),
                  Buttons(variant: Variante.primary, size: SizeButton.sm, msg: const Text("Valider le changement")),
                ],)
        ),
      )
    );
  }

}