// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_modal.dart';
import 'package:edgar_pro/widgets/custom_nav_patient_card.dart';
import 'package:edgar_pro/widgets/patient_list_card.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:provider/provider.dart';

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
                  final model =
                      Provider.of<BottomSheetModel>(context, listen: false);
                  model.resetCurrentIndex();

                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) {
                      return Consumer<BottomSheetModel>(
                        builder: (context, model, child) {
                          return ListModal(model: model, children: [
                            navigationpatient(context, widget.patients[index],
                                index, widget.setPages, widget.setId)
                          ]);
                        },
                      );
                    },
                  );
                },
              );
            }));
  }

  Widget navigationpatient(BuildContext context, Map<String, dynamic> patient,
      int index, Function setPages, Function setId) {
    return ModalContainer(
      title: '${patient['Prenom']} ${patient['Nom']}',
      subtitle: "Séléctionner une catégorie",
      icon: const IconModal(
        icon: Icon(BootstrapIcons.person, size: 18, color: AppColors.grey700),
        type: ModalType.info,
      ),
      footer: Buttons(
        variant: Variante.delete,
        size: SizeButton.sm,
        msg: const Text(
          'Supprimer le patient',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        onPressed: () {
          final model = Provider.of<BottomSheetModel>(context, listen: false);
          model.resetCurrentIndex();

          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) {
              return Consumer<BottomSheetModel>(
                builder: (context, model, child) {
                  return ListModal(model: model, children: [
                    patientDelete(context, patient, widget.deletePatientList)
                  ]);
                },
              );
            },
          );
        },
      ),
      body: [
        CustomNavPatientCard(
            text: 'Dossier médical',
            icon: BootstrapIcons.postcard_heart_fill,
            setPages: setPages,
            pageTo: 6,
            id: patient['id'],
            setId: setId),
        const SizedBox(height: 4),
        CustomNavPatientCard(
            text: 'Rendez-vous',
            icon: BootstrapIcons.calendar2_week_fill,
            setPages: setPages,
            pageTo: 7,
            id: patient['id'],
            setId: setId),
        const SizedBox(height: 4),
        CustomNavPatientCard(
            text: 'Documents',
            icon: BootstrapIcons.file_earmark_text_fill,
            setPages: setPages,
            pageTo: 8,
            id: patient['id'],
            setId: setId),
        const SizedBox(height: 4),
        CustomNavPatientCard(
            text: 'Messagerie',
            icon: BootstrapIcons.chat_dots_fill,
            setPages: setPages,
            pageTo: 9,
            id: patient['id'],
            setId: setId),
        const SizedBox(height: 12),
        Container(height: 2, color: AppColors.blue200),
      ],
    );
  }

  Widget patientDelete(BuildContext context, Map<String, dynamic> patient,
      Function deletePatientList) {
    return ModalContainer(
      title: "Êtes-vous sûr ?",
      subtitle:
          "Si vous supprimez ce patient, vous ne pourrez plus le consulter.",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.x,
          color: AppColors.red700,
          size: 18,
        ),
        type: ModalType.error,
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
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
          Flexible(
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
    );
  }
}
