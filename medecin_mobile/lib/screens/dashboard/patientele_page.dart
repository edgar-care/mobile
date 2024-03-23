// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/widgets/add_custom_field.dart';
import 'package:edgar_pro/widgets/custom_date_picker.dart';
import 'package:edgar_pro/widgets/custom_nav_patient_card.dart';
import 'package:edgar_pro/widgets/doctor_list.dart';
import 'package:edgar_pro/widgets/list_medical_background.dart';
import 'package:edgar_pro/widgets/login_snackbar.dart';
import 'package:edgar_pro/widgets/medical_background_card.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/AddPatient/add_button.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_patient_card_info.dart';
import 'package:edgar_pro/widgets/custom_patient_list.dart';
import 'package:edgar_pro/widgets/field_custom.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class Patient extends StatefulWidget {
  Function setPages;
  Patient({super.key, required this.setPages});

  @override
  // ignore: library_private_types_in_public_api
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  ValueNotifier<Map<String, dynamic>> info = ValueNotifier({
      'email': '',
      'prenom': '',
      'nom': '',
      'date': '',
      'sexe': '',
      'taille': '',
      'poids': '',
      'medecin': '',
      'allergies': [],
      'maladies': [],
      'traitements': [],
    });

  ValueNotifier<int> selected = ValueNotifier(0);

  void updateSelection(int newSelection) {
    selected.value = newSelection;
  }

  SliverWoltModalSheetPage addPatient(
      BuildContext context, ValueNotifier<int> pageIndexNotifier) {
    return WoltModalSheetPage(
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
                  pageIndexNotifier.value = 0;
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
                  switch (selected.value) {
                    case 0:
                      info.value['sexe'] = "Male";
                      break;
                    case 1:
                      info.value['sexe'] = "Female";
                      break;
                    case 2:
                      info.value['sexe'] = "Other";
                      break;
                    default:
                  }           
                  pageIndexNotifier.value = pageIndexNotifier.value + 1;
                },
              ),
            ),
          ],
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 86),
          child: Column(children: [
            Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: AppColors.grey200,
                ),
                child: const Icon(BootstrapIcons.postcard_heart_fill,
                    color: AppColors.grey700)),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Ajoutez les informations d'un patient",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.blue700,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.blue200,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.blue200,
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 32,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Adresse mail",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8,),
                CustomField(
                  label: "prenom.nom@gmail.com",
                  onChanged: (value) => info.value['email'] = value,
                  isPassword: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Prénom",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8,),
                CustomField(
                  label: "Prénom",
                  onChanged: (value) => info.value['prenom'] = value,
                  isPassword: false,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Nom",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8,),
                CustomField(
                  label: "Nom",
                  onChanged: (value) => info.value['nom'] = value,
                  isPassword: false,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Date de naissance",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8,),
                CustomDatePiker(onChanged: (value) => info.value['date'] = value),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Sexe",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8,),
                ValueListenableBuilder<int>(
                  valueListenable: selected,
                  builder: (context, value, child) {
                    return Row(
                      children: [
                            AddButton(
                                onTap: () => updateSelection(0),
                                label: "Masculin",
                                color: value == 0
                                      ? AppColors.blue700
                                      : AppColors.white),
                        const SizedBox(
                          width: 16,
                        ),
                            AddButton(
                                onTap: () => updateSelection(1),
                                label: "Féminin",
                                color: value == 1
                                    ? AppColors.blue700
                                    : AppColors.white),
                        const SizedBox(
                          width: 16,
                        ),
                            AddButton(
                                onTap: () => updateSelection(2),
                                label: "Autre",
                                color: value == 2
                                    ? AppColors.blue700
                                    : AppColors.white),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Taille",
                            style:
                                TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8,),
                          CustomField(
                            label: "1,52m",
                            onChanged: (value) => info.value['taille'] = value,
                            keyboardType: TextInputType.number,
                            isPassword: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 32,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Poids",
                            style:
                                TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8,),
                          CustomField(
                            label: "45kg",
                            onChanged: (value) => info.value['poids'] = value,
                            keyboardType: TextInputType.number,
                            isPassword: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  bool checkadd() {
    if (info.value['email'] == '' ||
        info.value['prenom'] == '' ||
        info.value['nom'] == '' ||
        info.value['date'] == '' ||
        info.value['sexe'] == '' ||
        info.value['taille'] == '' ||
        info.value['poids'] == '' ||
        info.value['medecin'] == '' ||
        info.value['allergies'].isEmpty ||
        info.value['maladies'].isEmpty ||
        info.value['traitements'].isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  SliverWoltModalSheetPage addPatient2(BuildContext context, ValueNotifier<int> pageIndexNotifier) {
    String alergie = '';
    String maladie = '';
    String traitement = '';
    return WoltModalSheetPage(
      hasTopBarLayer: false,
      backgroundColor: AppColors.white,
      hasSabGradient: false,
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
                msg: const Text(
                  'Revenir en arrière',
                ),
                onPressed: () {
                  pageIndexNotifier.value = pageIndexNotifier.value - 1;
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
                //   if(checkadd()){
                //     addPatientService(context, info.value);
                //   } else {
                //     ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(message: 'Veuillez remplir tous les champs', context: context,));
                //   }
                //   pageIndexNotifier.value = 0;
                //   Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 86),
          child: Column(
            children: [
            Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: AppColors.grey200,
                ),
                child: const Icon(BootstrapIcons.postcard_heart_fill,
                    color: AppColors.grey700)),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Ajoutez les informations d'un patient",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 8,
            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.blue700,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.blue700,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.blue200,
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 32,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Votre médecin traitant",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4,),
                CustomField(
                  label: "Docteur Edgar",
                  onChanged: (value) => info.value['medecin'] = value,
                  isPassword: false,
                  keyboardType: TextInputType.text,
                  icon: BootstrapIcons.search,
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: const DoctorList(),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }


SliverWoltModalSheetPage addPatient3(BuildContext context, ValueNotifier<int> pageIndexNotifier) {
  return WoltModalSheetPage(
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
                msg: const Text(
                  'Revenir en arrière',
                ),
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
                //   if(checkadd()){
                //     addPatientService(context, info.value);
                //   } else {
                //     ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(message: 'Veuillez remplir tous les champs', context: context,));
                //   }
                //   pageIndexNotifier.value = 0;
                //   Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 86),
          child: Column(
            children: [
            Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: AppColors.grey200,
                ),
                child: const Icon(BootstrapIcons.postcard_heart_fill,
                    color: AppColors.grey700)),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Ajoutez les informations d'un patient",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 8,
            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.blue700,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.blue700,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.blue700,
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 32,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Antecedents médicaux et sujets de santé",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4,),
                CustomField(
                  label: "Renseignez les informations",
                  onChanged: (value) => value,
                  isPassword: false,
                  keyboardType: TextInputType.text,
                  icon: BootstrapIcons.plus_lg,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Antecedents médicaux et sujets de santé renseignés",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8,),
                const MedicalBackgroundList(),
              ],
            ),
          ]),
        ),
      ),
    );
}

 SliverWoltModalSheetPage patientNavigation(BuildContext context, Map<String, dynamic> patient, int index){
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              Text('${patient['Nom']} ${patient['Prenom']}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),),
              const SizedBox(height: 16),
              CustomNavPatientCard(text: 'Dossier médical', icon: BootstrapIcons.postcard_heart_fill, ontap: () {widget.setPages(5);Navigator.pop(context);}),
              const SizedBox(height: 4),
              CustomNavPatientCard(text: 'Rendez-vous', icon: BootstrapIcons.calendar2_week_fill, ontap: () {widget.setPages(6);Navigator.pop(context);}),
              const SizedBox(height: 4),
              CustomNavPatientCard(text: 'Documents', icon: BootstrapIcons.file_earmark_text_fill, ontap: () {widget.setPages(7);Navigator.pop(context);}),
              const SizedBox(height: 4),
              CustomNavPatientCard(text: 'Messagerie', icon: BootstrapIcons.chat_dots_fill, ontap: () {widget.setPages(8);Navigator.pop(context);}),
              const SizedBox(height: 12),
              Container(height: 2,color: AppColors.blue200),
              const SizedBox(height: 12),
              Buttons(variant: Variante.primary, size: SizeButton.sm, msg: const Text('Revenir à la patientèle', style: TextStyle(fontFamily: 'Poppins'),), onPressed: () {Navigator.pop(context);}),
              const SizedBox(height: 4),
              Buttons(variant: Variante.delete, size: SizeButton.sm, msg: const Text('Supprimer le patient', style: TextStyle(fontFamily: 'Poppins'),), onPressed: () {WoltModalSheet.show(
                context: context,
                pageListBuilder: (BuildContext context) {
                  return [
                    deletePatient(context, patient, index, () => {null})
                  ];
                },
              );},)
            ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageindex = ValueNotifier(0);
    return Column(
      children: [
        Container(
          key: const ValueKey("Header"),
          decoration: BoxDecoration(
            color: AppColors.blue700,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(children: [
              Image.asset(
                "assets/images/logo/edgar-high-five.png",
                height: 40,
                width: 37,
              ),
              const SizedBox(
                width: 16,
              ),
              const Text(
                "Ma patientèle",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: AppColors.white),
              ),
            ]),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.blue200, width: 2)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomList(setPages: widget.setPages,),
                    Buttons(
                      variant: Variante.primary,
                      size: SizeButton.md,
                      msg: const Text('Ajouter un patient +'),
                      onPressed: () {
                        WoltModalSheet.show<void>(
                            context: context,
                            pageIndexNotifier: pageindex,
                            pageListBuilder: (modalSheetContext) {
                              return [
                                //patientNavigation(context, Map<String, dynamic>.of(<String, dynamic>{'Mercury': 1,'Venus' : 2,'Earth': 3}), 2),
                                addPatient(context, pageindex),
                                addPatient2(context, pageindex),
                                addPatient3(context, pageindex)
                              ];
                            });
                      },
                    ),
                  ]),
            ),
          ),
        ),
      ],
    );
  }
}