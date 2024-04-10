import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/field_custom.dart';
import 'package:edgar_pro/widgets/Diagnostic/custom_modal_card.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// ignore: must_be_immutable
class DiagnosticCard extends StatelessWidget {
  Map<String, dynamic> rdvInfo;
  int type;
  DiagnosticCard({super.key, required this.rdvInfo, required this.type});

ValueNotifier<int> pageIndexNotifier = ValueNotifier<int>(0);
Map<String, dynamic> patientInfo = {};


Future<void> _loadAppointment() async {
    patientInfo = await getPatientById(rdvInfo['id_patient']);
}

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    var color;
    switch (type) {
      case 0:
        color = AppColors.blue200;
      case 1:
        color = AppColors.green500;
      case 2:
        color = AppColors.red500;
    }

    DateTime start = DateTime.fromMillisecondsSinceEpoch(rdvInfo['start_date'] * 1000);
    DateTime end =  DateTime.fromMillisecondsSinceEpoch(rdvInfo['end_date'] * 1000);
    return FutureBuilder(
      future: _loadAppointment(),
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return  Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.blue200, width: 2.0),
        ),
        child: InkWell(
          onTap: () {
            WoltModalSheet.show<void>(
                pageIndexNotifier: pageIndexNotifier,
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [
                    navModal(modalSheetContext, patientInfo["Nom"], patientInfo["Prenom"], rdvInfo, pageIndexNotifier),
                    validateModal(modalSheetContext, pageIndexNotifier),
                  ];
                },);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 4,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                const SizedBox(width: 8,),
                Column(
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
                          const SizedBox(width: 2,),
                          const Icon(BootstrapIcons.arrow_right, size: 16,),
                          const SizedBox(width: 2,),
                          Text(DateFormat('jm', 'fr').format(end), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                        ]),
                      ]
                    )
                ])
              ])
          )
        )
      );
      } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
  }

  SliverWoltModalSheetPage navModal(BuildContext context, String name, String firstname, Map<String, dynamic> rdvInfo, ValueNotifier pageindex){
    DateTime date = DateTime.fromMillisecondsSinceEpoch(rdvInfo['start_date'] * 1000);
    String dateString = DateFormat('yMMMd', 'fr').format(date).toString();
    String timeStringStart = DateFormat('HH:mm', 'fr').format(date).toString();
    String timeStringEnd = DateFormat('HH:mm', 'fr').format(date.add(const Duration(minutes: 30))).toString();
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              Column(
                children:[
                  Text('Rendez-vous de $firstname $name', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),),
                  Text('$dateString de $timeStringStart à $timeStringEnd', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),),
                ]),
              const SizedBox(height: 16),
              CustomModalCard(ontap: () {}, text: 'Dossier Médical', icon: BootstrapIcons.postcard_heart,),
              CustomModalCard(text: 'Diagnostic', icon: BootstrapIcons.heart_pulse_fill, ontap: () {},),
              const SizedBox(height: 4),
              CustomModalCard(text: 'Retranscription du chat', icon: BootstrapIcons.file_text_fill, ontap: () {WoltModalSheet.show(
                context: context,
                pageListBuilder: (BuildContext context) {
                  return [
                  ];
                },
              );} ,),
              const SizedBox(height: 12),
              Container(height: 2,color: AppColors.blue200),
              const SizedBox(height: 12),
              Buttons(variant: Variante.validate, size: SizeButton.sm, msg: const Text('Valider le rendez-vous', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600),), onPressed: () {pageIndexNotifier.value = 1;},),
              const SizedBox(height: 4),
              Buttons(variant: Variante.delete, size: SizeButton.sm, msg: const Text('Annuler le rendez-vous', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600),), onPressed: () {pageIndexNotifier.value = 2;},)]),
            ),
        ),
    );
  }

  SliverWoltModalSheetPage validateModal(BuildContext context, ValueNotifier pageIndexNotifier){
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
                    BootstrapIcons.check,
                    color: AppColors.green700,
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
                "En acceptant ce rendez-vous, voous assurez l'utilité de celui-ci auprès de votre patient.",
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
                        pageIndexNotifier.value = 0;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: Buttons(
                      variant: Variante.validate,
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

  SliverWoltModalSheetPage cancelModal(BuildContext context, ValueNotifier pageIndexNotifier){
    String cancelreason = '';
    String healthmethod = '';
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
                "Si vous supprimer ce rendez-vous, vous ne pourrez plus revenir en arrière",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32,),
              const Text("La raison de l'annulation", style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),),
              const SizedBox(height: 4,),
              CustomField(label: "Renseigner la raison de l'annulation", onChanged: (value) => cancelreason = value, keyboardType: TextInputType.text, startUppercase: false,),
              const SizedBox(height: 16,),
              const Text("Méthode de soins", style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),),
              const SizedBox(height: 4,),
              CustomField(label: "Renseigner les methodes de soins pour diminuer les symptômes", onChanged: (value) => healthmethod = value, keyboardType: TextInputType.text, startUppercase: false,),
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
                        pageIndexNotifier.value = 0;
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
}

