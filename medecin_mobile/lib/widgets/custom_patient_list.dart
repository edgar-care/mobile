import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:medecin_mobile/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:medecin_mobile/styles/colors.dart';
import 'package:medecin_mobile/widgets/field_custom.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:medecin_mobile/widgets/custom_patient_card_info.dart';


class CustomList extends StatelessWidget {
  const CustomList({Key? key}) : super(key: key);

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
        'Allergies': ['pollen', 'pollen', 'pollen', 'pollen','pollen','pollen', 'pollen', 'pollen', 'pollen','pollen'],
        'maladies': ['maladies', 'maladies', 'maladies'],
        'traitement': ['traitement', 'traitement', 'traitement'],
      },
      {
        'prenom': 'Edgar',
        'nom': 'L\'assistant',
        'date': '26/09/2021',
        'sexe': 'autre',
        'taille': '1,52m',
        'poids': '45kg',
        'medecin': 'Docteur Edgar',
        'Allergies': ['pollen', 'pollen', 'pollen', 'pollen'],
        'maladies': 'maladies, maladies, maladies',
        'traitement': 'traitement, traitement, traitement',
      },
    ];


    List<Widget> patientCards = patients.map((patients) {
      return Card(
        color: AppColors.blue100,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.blue200, width: 1),
        ),
        
        child: InkWell (
          onTap: () {
            WoltModalSheet.show<void>(context: context, pageListBuilder: (modalSheetContext){
              return [patientInfo(context, patients, modalSheetContext)];
            }, pageIndexNotifier: ValueNotifier(0));
          },
          child : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
          child : Row(
            children: [
            Container(
              height: 19,
              width: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: AppColors.black,
              ),
              ),
            const SizedBox(width: 8,),
            Text(patients['prenom'], style: const TextStyle(fontSize: 16, fontFamily: 'Poppins', color: AppColors.black), textAlign: TextAlign.left,),
            const SizedBox(width: 4,),
            Text(patients['nom'], style: const TextStyle(fontSize: 16, fontFamily: 'Poppins', color: AppColors.black), textAlign: TextAlign.left,),
          ],
        ),
        ),
        ),
      );
    }).toList();


      return Expanded(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: patientCards,
          )
        );
  }

  WoltModalSheetPage patientInfo(BuildContext context, Map<String, dynamic> patient, BuildContext modalSheetContext) {
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
                              PatientInfoCard(context: context, patient: patient, champ: 'Allergies'),
                            ],
                          ),
                          const Text(
                            "Maladies:",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
                          PatientInfoCard(context: context, patient: patient, champ: 'maladies'),
                          const Text(
                            "Traitements:",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
                          PatientInfoCard(context: context, patient: patient, champ: 'traitement'),
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
                  Navigator.pop(modalSheetContext);
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
                  Navigator.pop(modalSheetContext);
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.white,
      enableDrag: true,
      hasSabGradient: true,
      hasTopBarLayer: false,
    );
  }
  WoltModalSheetPage addPatient(BuildContext context) {
    final Map<String, String> info = {
      'email': '',
      'prenom': '',
      'nom': '',
      'date': '',
      'sexe': '',
      'taille': '',
      'poids': '',
      'medecin': '',
      'Allergies': '',
      'maladies': '',
      'traitement': '',
    };
    return WoltModalSheetPage.withSingleChild(
      hasTopBarLayer: false,
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: 
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: 
              Column(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: AppColors.grey200,
                  ),
                  child:
                    const Icon(BootstrapIcons.postcard_heart_fill, color: AppColors.grey700)
                ),
                const SizedBox(height: 8,),
                const Text("Mettez à jour vos informations personelles", style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700),),
                const SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.blue700,
                      ),
                    ),
                    const SizedBox(width: 16,),
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
                const SizedBox(height: 32,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Adresse email", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                    CustomField(label: "prenom.nom@gmail.com", onChanged: (value) => info['email'] = value, isPassword: false,),
                    const SizedBox(height: 16,),
                    const Text("Votre Prénom", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                    CustomField(label: "Prénom", onChanged: (value) => info['prenom'] = value, isPassword: false,),
                    const SizedBox(height: 16,),
                    const Text("Votre Nom", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                    CustomField(label: "Nom", onChanged: (value) => info['nom'] = value, isPassword: false,),
                  ]
                )
              ])
            ),
      ),
    );
  }
}