import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_nav_patient_card.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// ignore: must_be_immutable
class PatientPage extends StatefulWidget {
  String id;
  final Function setPages;
  final Function setId;
  PatientPage({super.key, required this.id, required this.setPages, required this.setId});

  @override
  State<PatientPage> createState() => _PatientPageState();
}
class _PatientPageState extends State<PatientPage> {
    Map<String, dynamic> patientInfo = {};
    Future<void> _loadInfo() async{
      patientInfo = await getPatientById(widget.id);
    }

    Future<void> updateData() async {
      setState(() {
        _loadInfo();
      });
    }

    String sexe(String sexe) {
      switch (sexe) {
        case 'MALE':
          return 'Masculin';
        case 'FEMALE':
          return 'Feminin';
        default:
          return 'Autre';
      }
    }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _loadInfo(),
      builder:  (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.blue100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.blue200,
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: () {
                   WoltModalSheet.show<void>(
                        context: context,
                        pageListBuilder: (modalSheetContext) {
                          return [
                            patientNavigation(context, patientInfo, widget.setPages, widget.setId),
                          ];
                        });
                },
                child : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: 3,
                        decoration: BoxDecoration(
                          color: AppColors.green500,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(width: 8,),
                      Text(
                        '${patientInfo['Nom']} ${patientInfo['Prénom']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins'
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Voir Plus',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins'
                        ),
                      ),
                      const SizedBox(width: 8,),
                      const Icon(
                        BootstrapIcons.chevron_right,
                        size: 12,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16,),
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
                         Expanded(
                          child:
                            Wrap(
                              alignment: WrapAlignment.start,
                              direction: Axis.vertical,
                              spacing: 12,
                              children: [
                                Text('Prénom: ${patientInfo['Prenom']}', style: const TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                                Text('Nom: ${patientInfo['Nom']}', style: const TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                                Text('Date de naissance: ${patientInfo['date_de_naissance']}', style: const TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                                Text('Sexe: ${sexe(patientInfo['sexe'])}', style: const TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                                Text('Taille: ${patientInfo['taille']}', style: const TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                                Text('Poids: ${patientInfo['poids']}', style: const TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                                const Text('Médecin traitant: WIP', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                                const Text('Antécédants médicaux et sujets de santé: WIP', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                              ],
                            )
                        ),
                        Buttons(
                          variant: Variante.primary,
                          size: SizeButton.md,
                          msg: const Text('Modifier le dossier médical'),
                          onPressed: () {
                            WoltModalSheet.show<void>(
                                context: context,
                                pageListBuilder: (modalSheetContext) {
                                  return [
                                  ];
                                });
                          },
                        ),
                      ],),
                      ),
                ),
              ),
          ],
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }

    SliverWoltModalSheetPage patientNavigation(BuildContext context, Map<String, dynamic> patient, Function setPages, Function setId) {
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
              CustomNavPatientCard(text: 'Dossier médical', icon: BootstrapIcons.postcard_heart_fill, setPages: setPages, pageTo: 4, id: patient['id'], setId: setId),
              const SizedBox(height: 4),
              CustomNavPatientCard(text: 'Rendez-vous', icon: BootstrapIcons.calendar2_week_fill, setPages: setPages, pageTo: 5, id: patient['id'], setId: setId),
              const SizedBox(height: 4),
              CustomNavPatientCard(text: 'Documents', icon: BootstrapIcons.file_earmark_text_fill, setPages: setPages, pageTo: 6, id: patient['id'], setId: setId),
              const SizedBox(height: 4),
              CustomNavPatientCard(text: 'Messagerie', icon: BootstrapIcons.chat_dots_fill, setPages: setPages, pageTo: 7, id: patient['id'], setId: setId),
              const SizedBox(height: 12),
              Container(height: 2,color: AppColors.blue200),
              const SizedBox(height: 12),
              Buttons(variant: Variante.primary, size: SizeButton.sm, msg: const Text('Revenir à la patientèle', style: TextStyle(fontFamily: 'Poppins'),), onPressed: () {setPages(1); Navigator.pop(context);}),
            ]),
        ),
      ),
    );
  }

}