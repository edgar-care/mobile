import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_nav_patient_card.dart';
import 'package:edgar_pro/widgets/rdv_patient/custom_list_rdv_patient.dart';
import 'package:edgar_pro/widgets/rdv_patient/custom_old_list_rdv_patient.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// ignore: must_be_immutable
class PatientPageRdv extends StatefulWidget {
  String id;
  Function setPages;
  Function setId;
  PatientPageRdv({super.key, required this.id, required this.setPages, required this.setId});

  @override
  State<PatientPageRdv> createState() => _PatientPageRdvState();
}

class _PatientPageRdvState extends State<PatientPageRdv> {
  ValueNotifier<int> selected = ValueNotifier(0);
  Map<String, dynamic> patient = {};

  Future<void> _loadInfo() async {
    patient = await getPatientById(widget.id);
  }

  void updateSelection(int newSelection) {
    setState(() {
      selected.value = newSelection;
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: _loadInfo(),
          builder: (context, snapshot) {
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
                    patientNavigation(context, patient, widget.setPages, widget.setId),
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
                    '${patient["Nom"]} ${patient["Prenom"]}',
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
        ValueListenableBuilder<int>(
                  valueListenable: selected,
                  builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.445,
                    child: Buttons(
                      variant: selected.value == 0 ? Variante.primary : Variante.secondary,
                      size: SizeButton.sm,
                      msg: const Text('Prochain rendez-vous'),
                      onPressed: () {
                        updateSelection(0);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.445,
                    child: Buttons(
                      variant: selected.value == 1 ? Variante.primary : Variante.secondary,
                      size: SizeButton.sm,
                      msg: const Text('Rendez-vous passés'),
                      onPressed: () {
                        updateSelection(1);
                      },
                    ),
                  ),
                ],
              );
              }),

        const SizedBox(height: 8,),
         ValueListenableBuilder<int>(
                  valueListenable: selected,
                  builder: (context, value, child) {
                return selected.value == 0 ? CustomListPatient(id: widget.id,) : CustomListOldPatient(id: widget.id);
          }),
      ],
    );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  ); 
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
              CustomNavPatientCard(text: 'Dossier médical', icon: BootstrapIcons.postcard_heart_fill, setPages: setPages, pageTo: 4),
              const SizedBox(height: 4),
              CustomNavPatientCard(text: 'Rendez-vous', icon: BootstrapIcons.calendar2_week_fill, setPages: setPages, pageTo: 5),
              const SizedBox(height: 4),
              CustomNavPatientCard(text: 'Documents', icon: BootstrapIcons.file_earmark_text_fill, setPages: setPages, pageTo: 6),
              const SizedBox(height: 4),
              CustomNavPatientCard(text: 'Messagerie', icon: BootstrapIcons.chat_dots_fill, setPages: setPages, pageTo: 7),
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