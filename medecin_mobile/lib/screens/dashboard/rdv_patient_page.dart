import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_patient_list.dart';
import 'package:edgar_pro/widgets/rdv_patient/custom_list_rdv_patient.dart';
import 'package:edgar_pro/widgets/rdv_patient/custom_old_list_rdv_patient.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// ignore: must_be_immutable
class PatientPageRdv extends StatefulWidget {
  String id;
  PatientPageRdv({
    super.key,
    required this.id,
  });

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
                            patientNavigation(context, patient, []),
                          ];
                        });
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
                          '${patient["Prenom"]} ${patient["Nom"]}',
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
                            variant: selected.value == 0
                                ? Variante.primary
                                : Variante.secondary,
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
                            variant: selected.value == 1
                                ? Variante.primary
                                : Variante.secondary,
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
              const SizedBox(
                height: 8,
              ),
              ValueListenableBuilder<int>(
                  valueListenable: selected,
                  builder: (context, value, child) {
                    return selected.value == 0
                        ? CustomListPatient(
                            id: widget.id,
                          )
                        : CustomListOldPatient(id: widget.id);
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
}
