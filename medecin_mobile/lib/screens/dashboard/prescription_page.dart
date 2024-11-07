// ignore_for_file: must_be_immutable

import "package:bootstrap_icons/bootstrap_icons.dart";
import "package:edgar/colors.dart";
import "package:edgar/widget.dart";
import "package:edgar_pro/services/patient_info_service.dart";
import "package:edgar_pro/widgets/custom_nav_patient_card.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class PrescriptionPage extends StatefulWidget {
  String id;
  Function setPages;
  Function setId;
  PrescriptionPage({
      super.key,
      required this.id,
      required this.setPages,
      required this.setId});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  Map<String, dynamic> patientInfo = {};

  Future loadInfo() async {
    await getPatientById(widget.id).then((value) {
      setState(() {
        patientInfo = value;
      });
      
    },);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadInfo(),
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
                    final model =
                        Provider.of<BottomSheetModel>(context, listen: false);
                    model.resetCurrentIndex();

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Consumer<BottomSheetModel>(
                          builder: (context, model, child) {
                            return ListModal(
                              model: model,
                              children: [
                                navigationPatient(context, patientInfo,
                                    widget.setPages, widget.setId)
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Padding(
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
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${patientInfo['Prenom']} ${patientInfo['Nom']}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                        ),
                        const Spacer(),
                        const Text(
                          'Voir Plus',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          BootstrapIcons.chevron_right,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          );
        }
      },
    );
        }
        Widget navigationPatient(BuildContext context, Map<String, dynamic> patient,
      Function setPages, Function setId) {
    return ModalContainer(
      title: '${patient['Prenom']} ${patient['Nom']}',
      subtitle: "Veuillez choisir une catégorie",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.person,
          size: 18,
        ),
        type: ModalType.info,
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
            text: 'Ordonnance',
            icon: BootstrapIcons.capsule,
            setPages: setPages,
            pageTo: 9,
            id: patient['id'],
            setId: setId),
        const SizedBox(height: 4),
        CustomNavPatientCard(
            text: 'Messagerie',
            icon: BootstrapIcons.chat_dots_fill,
            setPages: setPages,
            pageTo: 10,
            id: patient['id'],
            setId: setId),
        const SizedBox(height: 12),
        Container(height: 2, color: AppColors.blue200),
        const SizedBox(height: 12),
      ],
      footer: Buttons(
          variant: Variant.primary,
          size: SizeButton.sm,
          msg: const Text(
            'Revenir à la patientèle',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          onPressed: () {
            setPages(1);
            Navigator.pop(context);
          }),
    );
  }
  }