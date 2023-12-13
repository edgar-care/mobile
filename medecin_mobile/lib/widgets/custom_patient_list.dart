import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:medecin_mobile/widgets/AddPatient/add_button.dart';
import 'package:medecin_mobile/widgets/AddPatient/add_patient_field.dart';
import 'package:medecin_mobile/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:medecin_mobile/styles/colors.dart';
import 'package:medecin_mobile/widgets/field_custom.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:medecin_mobile/widgets/custom_patient_card_info.dart';


class CustomList extends StatelessWidget {
  int selected = 0;
  get isSelected => selected;
  set setSelected(int value) => selected = value;
  CustomList({Key? key}) : super(key: key);


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
        'allergies': ['pollen', 'pollen', 'pollen', 'pollen','pollen','pollen', 'pollen', 'pollen', 'pollen','pollen'],
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


    List<Widget> patientCards = patients.map((patients) {
      final pageIndexNotifier = ValueNotifier(2);
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
              return [fixPatient(context, pageIndexNotifier, patients),fixPatient2(context, pageIndexNotifier, patients),patientInfo(context, patients, modalSheetContext, pageIndexNotifier), deletePatient(context, pageIndexNotifier, patients)];
            }, pageIndexNotifier: pageIndexNotifier);
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

  WoltModalSheetPage patientInfo(BuildContext context, Map<String, dynamic> patient, BuildContext modalSheetContext, ValueNotifier<int> pageIndexNotifier) {
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
                              PatientInfoCard(context: context, patient: patient, champ: 'allergies', isDeletable: false),
                            ],
                          ),
                          const Text(
                            "Maladies:",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
                          PatientInfoCard(context: context, patient: patient, champ: 'maladies', isDeletable: false,),
                          const Text(
                            "Traitements:",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
                          PatientInfoCard(context: context, patient: patient, champ: 'traitements', isDeletable: false,),
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
                  pageIndexNotifier.value = 0;
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
                  pageIndexNotifier.value = 3;
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

  WoltModalSheetPage fixPatient(BuildContext context, ValueNotifier<int> pageIndexNotifier, Map<String, dynamic> patient) {
    return WoltModalSheetPage.withSingleChild(
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
                  Navigator.pop(context);
                  pageIndexNotifier.value = 2;
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
                  pageIndexNotifier.value = pageIndexNotifier.value + 1;
                },
              ),
            ),
          ],
        ),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: 
            Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 86),
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
                    const Text("Votre Prénom", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                    CustomField(label: patient['prenom'], onChanged: (value) => patient['prenom'] = value, isPassword: false,),
                    const SizedBox(height: 16,),
                    const Text("Votre Nom", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                    CustomField(label: patient['nom'], onChanged: (value) => patient['nom'] = value, isPassword: false,),
                    const SizedBox(height: 16,),
                    const Text("Date de naissance", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                    // AddCustomField(label: patient['date'], onChanged: (value) => patient['date'] = value, add: false, list: const [''],),
                    const SizedBox(height: 16,),
                    const Text("Sexe", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                   Row(children: [
                      // AddButton(onTap: () => selected = 0, label: "Masculin", isSelected: isSelected == 0 ? true : false),
                      // const SizedBox(width: 16,),
                      // AddButton(onTap: () => selected = 1, label: "Feminin", isSelected: isSelected == 1 ? true : false),
                      // const SizedBox(width: 16,),
                      // AddButton(onTap: () => selected = 2, label: "Autre", isSelected: isSelected == 2 ? true : false),
                    ],),
                    const SizedBox(height: 16,),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Taille", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                              CustomField(label: patient['taille'], onChanged: (value) => patient['taille'] = value, isPassword: false,),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Poids", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                              CustomField(label: patient['poids'], onChanged: (value) => patient['poids'] = value, isPassword: false,),
                            ],
                          ),
                        ),
                    ],)                   
                    ],),
                  ]
                ),
              ),
            ),
      );
  }
  WoltModalSheetPage fixPatient2(BuildContext context, ValueNotifier<int> pageIndexNotifier, Map<String, dynamic> patient) {
    return WoltModalSheetPage.withSingleChild(
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
                msg: const Text('Revenir en arrière',),
                onPressed: () {
                  pageIndexNotifier.value = pageIndexNotifier.value - 1;
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              child: Buttons(
                variant: Variante.validate,
                size: SizeButton.sm,
                msg: const Text('Confirmer'),
                onPressed: () {
                  pageIndexNotifier.value = 2;
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: 
            Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 86),
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
                        color: AppColors.blue700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Votre médecin traitant", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                    CustomField(label: "Dr. Edgar", onChanged: (value) => patient['medecin'] = value, isPassword: false,),
                    const SizedBox(height: 16,),
                    const Text("Vos allergies", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                    // AddCustomField(label: "Renseignez vos maladies ici", add: true, list: patient['allergies'], onChanged: (value) => patient['allergies'] = value),
                    const SizedBox(height: 8,),
                    const Text("Vos allergies renseignée", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                    PatientInfoCard(context: context, patient: patient, champ: 'allergies', isDeletable: true),
                    const SizedBox(height: 16,),
                    const Text("Vos maladies", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                    // AddCustomField(label: "Renseignez vos maladies ici", add: true, list: patient['maladies'], onChanged: (value) => patient['maladies'] = value),
                    const SizedBox(height: 8,),
                    const Text("Vos maladies renseignée", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                    PatientInfoCard(context: context, patient: patient, champ: 'maladies', isDeletable: true),
                    const SizedBox(height: 16,),
                    const Text("Vos traitements en cours", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                    // AddCustomField(label: "Renseignez vos traitements ici", add: true, list: patient['traitements'], onChanged: (value) => patient['traitements'] = value),
                    const SizedBox(height: 8,),
                    const Text("Vos traitements renseignée", style: TextStyle(fontFamily: 'Poppins', fontSize: 14),),
                    PatientInfoCard(context: context, patient: patient, champ: 'traitements', isDeletable: true),
                    ],),
                  ]
                ),
              ),
            ),
      );
  }
    WoltModalSheetPage deletePatient(BuildContext context, ValueNotifier<int> pageIndexNotifier, Map<String, dynamic> patient) {
      return WoltModalSheetPage.withSingleChild(
        hasTopBarLayer: false,
        backgroundColor: AppColors.white,
        hasSabGradient: false,
        enableDrag: true,
        child: Padding(
          padding : const EdgeInsets.fromLTRB(18, 18, 18, 18), 
          child: SizedBox(
            width: MediaQuery.of(context).size.width*0.8,
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: AppColors.red200,
                  ),
                  child:
                    const Icon(BootstrapIcons.x, color: AppColors.red700, size: 40,)
                ),
                const SizedBox(height: 8,),
                const Text("Êtes-vous sûr ?", style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w500),),
                const SizedBox(height: 8,),
                const Text("Si vous supprimez ce patient, vous ne pourrez plus le consulter.", style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.grey400), textAlign: TextAlign.center,),
                const SizedBox(height: 32,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.43,
                      child: Buttons(
                        variant: Variante.secondary,
                        size: SizeButton.sm,
                        msg: const Text('Annuler'),
                        onPressed: () {
                          pageIndexNotifier.value = 2;
                        },
                      ),
                    ),
                    const SizedBox(width: 12,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.43,
                      child: Buttons(
                        variant: Variante.delete,
                        size: SizeButton.sm,
                        msg: const Text('Oui, je suis sûr'),
                        onPressed: () {
                          pageIndexNotifier.value = 2;
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
}