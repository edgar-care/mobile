// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_nav_patient_card.dart';
import 'package:edgar_pro/widgets/patient_list_card.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// ignore: must_be_immutable
class CustomList extends StatefulWidget {
  final List<Map<String, dynamic>> patients;
  final Function updatePatient;
  final Function setPages;
  final Function deletePatientList;
  final Function setId;
  const CustomList(
      {super.key,
      required this.patients,
      required this.updatePatient,
      required this.setPages,
      required this.setId,
      required this.deletePatientList});

  @override
  // ignore: library_private_types_in_public_api
  _CustomListState createState() => _CustomListState();
}

// ignore: must_be_immutable
class _CustomListState extends State<CustomList> {
  ValueNotifier<int> selected = ValueNotifier(2);

  void updateSelection(int newSelection) {
    selected.value = newSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: widget.patients.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return PatientListCard(
                patientData: widget.patients[index],
                onTap: () {
                  WoltModalSheet.show(
                    context: context,
                    pageListBuilder: (BuildContext context) {
                      return [
                        patientNavigation(context, widget.patients[index],
                            index, widget.setPages, widget.setId),
                      ];
                    },
                  );
                },
              );
            }));
  }

  SliverWoltModalSheetPage patientNavigation(
      BuildContext context,
      Map<String, dynamic> patient,
      int index,
      Function setPages,
      Function setId) {
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(children: [
            Text(
              '${patient['Nom']} ${patient['Prenom']}',
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            CustomNavPatientCard(
                text: 'Dossier médical',
                icon: BootstrapIcons.postcard_heart_fill,
                setPages: setPages,
                pageTo: 4,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 4),
            CustomNavPatientCard(
                text: 'Rendez-vous',
                icon: BootstrapIcons.calendar2_week_fill,
                setPages: setPages,
                pageTo: 5,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 4),
            CustomNavPatientCard(
                text: 'Documents',
                icon: BootstrapIcons.file_earmark_text_fill,
                setPages: setPages,
                pageTo: 6,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 4),
            CustomNavPatientCard(
                text: 'Messagerie',
                icon: BootstrapIcons.chat_dots_fill,
                setPages: setPages,
                pageTo: 7,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 12),
            Container(height: 2, color: AppColors.blue200),
            const SizedBox(height: 12),
            Buttons(
                variant: Variante.primary,
                size: SizeButton.sm,
                msg: const Text(
                  'Revenir à la patientèle',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            const SizedBox(height: 4),
            Buttons(
              variant: Variante.delete,
              size: SizeButton.sm,
              msg: const Text(
                'Supprimer le patient',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onPressed: () {
                WoltModalSheet.show(
                  context: context,
                  pageListBuilder: (BuildContext context) {
                    return [
                      deletePatient(context, patient, widget.deletePatientList),
                    ];
                  },
                );
              },
            )
          ]),
        ),
      ),
    );
  }

  SliverWoltModalSheetPage deletePatient(BuildContext context,
      Map<String, dynamic> patient, Function deletePatientList) {
    return WoltModalSheetPage(
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
                "Si vous supprimez ce patient, vous ne pourrez plus le consulter.",
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
                        Navigator.pop(context);
                        deletePatientService(patient['id'], context);
                        deletePatientList(patient['id']);
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
