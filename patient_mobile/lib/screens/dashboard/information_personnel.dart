// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:edgar_app/services/doctor.dart';
import 'package:edgar_app/services/get_information_patient.dart';
import 'package:edgar_app/services/medecine.dart';
import 'package:edgar_app/widget/AddPatient/add_button.dart';
import 'package:edgar_app/widget/card_traitement_day.dart';
import 'package:edgar_app/widget/card_traitement_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:provider/provider.dart';

class InformationPersonnel extends StatefulWidget {
  const InformationPersonnel({super.key});

  @override
  State<InformationPersonnel> createState() => _InformationPersonnelState();
}

class _InformationPersonnelState extends State<InformationPersonnel>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> infoMedical = {};
  String birthdate = '';
  String doctorName = '';

  Future<void> fetchData() async {
    await getMedicalFolder().then((value) {
      if (value.isNotEmpty) {
        infoMedical = {
          ...value,
          "medical_antecedents": value['medical_antecedents'] ?? []
        };

        birthdate = DateFormat('dd/MM/yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
                infoMedical['birthdate'] * 1000));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            ErrorSnackBar(message: "Error on fetching name", context: context));
      }
    });
    doctorName = await getNameDoctor();
  }

  Future<String> getNameDoctor() async {
    try {
      final value = await getAllDoctor();
      if (value.isNotEmpty) {
        for (var doctor in value) {
          if (doctor['id'] == infoMedical['primary_doctor_id']) {
            if (doctor['name'] != null) {
              return 'Dr. ${doctor['firstname']} ${doctor['name'].toUpperCase()}';
            } else {
              return 'Dr.Edgar';
            }
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            ErrorSnackBar(message: "Error on fetching name", context: context));
        return 'test';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          ErrorSnackBar(message: "Error on fetching name", context: context));
      return 'test';
    }
    return 'Dr.Edgar'; // default return value if no doctor matches
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.blue700,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Image.asset(
                'assets/images/logo/edgar-high-five.png',
                width: 40,
              ),
              const SizedBox(width: 16),
              const Text(
                'Dossier Médical',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blue700,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Erreur lors du chargement des données'),
              );
            } else {
              return Expanded(
                child: CardInformationPersonnel(
                    infoMedical: infoMedical,
                    birthdate: birthdate,
                    doctorName: doctorName),
              );
            }
          },
        ),
        const SizedBox(height: 16),
        Buttons(
            variant: Variant.primary,
            size: SizeButton.md,
            msg: const Text('Modifier les informations'),
            onPressed: () {}),
      ],
    );
  }
}

class CardInformationPersonnel extends StatefulWidget {
  final String birthdate;
  final Map<String, dynamic> infoMedical;
  final String doctorName;
  const CardInformationPersonnel(
      {super.key,
      required this.infoMedical,
      required this.birthdate,
      required this.doctorName});

  @override
  State<CardInformationPersonnel> createState() =>
      _CardInformationPersonnelState();
}

class _CardInformationPersonnelState extends State<CardInformationPersonnel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.blue200,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElementInfo(
              title: 'Prénom: ',
              value: widget.infoMedical['firstname'],
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Nom: ',
              value: widget.infoMedical['name'],
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Date de naissance: ',
              value: widget.birthdate,
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Sexe: ',
              value: widget.infoMedical['sex'] == 'MALE'
                  ? 'Homme'
                  : widget.infoMedical['sex'] == 'FEMALE'
                      ? 'Femme'
                      : 'Autres',
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Taille: ',
              value: '${widget.infoMedical['height'] / 100} m',
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Poids: ',
              value: '${widget.infoMedical['weight'] / 100} kg',
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Médecin traitant: ',
              value: widget.doctorName,
            ),
            const SizedBox(height: 8),
            const Text(
              'Antécédants médicaux et sujets de santé:',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                for (var treatment in widget.infoMedical['medical_antecedents'])
                  IntrinsicWidth(
                    child: GestureDetector(
                      onTap: () {
                        if (treatment['medicines'] != null) {
                          final model = Provider.of<BottomSheetModel>(context,
                              listen: false);
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
                                      InfoTreatment(
                                        traitement: treatment,
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                      child: CardTraitementSmall(
                        name: treatment['name'],
                        isEnCours:
                            treatment['medicines'] == null ? false : true,
                        onTap: () {},
                        withDelete: false,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class InfoTreatment extends StatefulWidget {
  Map<String, dynamic> traitement;
  InfoTreatment({super.key, required this.traitement});

  @override
  State<InfoTreatment> createState() => _InfoTreatmentState();
}

class _InfoTreatmentState extends State<InfoTreatment> {
  late Future<bool> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }

  List<Map<String, dynamic>> medicaments = [];

  List<String> medNames = [];

  Future<bool> fetchData() async {
    try {
      medicaments = await getMedecines();

      for (var i = 0; i < widget.traitement['medicines'].length; i++) {
        var medname = medicaments.firstWhere(
            (med) =>
                med['id'] == widget.traitement['medicines'][i]['medicine_id'],
            orElse: () => {'name': ''})['name'];
        medNames.add(medname);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isHealth =
        ValueNotifier(widget.traitement['still_relevant']);
    return ModalContainer(
      title: widget.traitement['name'],
      subtitle: "Voici les information du traitement",
      icon: IconModal(
        icon: SvgPicture.asset(
          'assets/images/utils/Union.svg',
          width: 16,
          height: 16,
          // ignore: deprecated_member_use
          color: widget.traitement['medicines'].isEmpty
              ? AppColors.grey300
              : AppColors.blue700,
        ),
        type: ModalType.info,
      ),
      body: [
        const Text(
          'Le sujet de santé est toujours en cours ?',
          style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: isHealth,
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AddButton(
                    onTap: (() {}),
                    label: "Oui",
                    color: value == true ? AppColors.blue700 : AppColors.white),
                const SizedBox(width: 8),
                AddButton(
                    onTap: (() {}),
                    label: "Non",
                    color:
                        value == false ? AppColors.blue700 : AppColors.white),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        const Text(
          'Les médicaments prescrits',
          style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder<bool>(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.blue700,
                  strokeWidth: 2,
                ));
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else {
                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: widget.traitement['medicines'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return CardTraitementDay(
                              isClickable: false,
                              data: widget.traitement['medicines'][index],
                              name: medNames[index],
                              onTap: () {},
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        )
      ],
    );
  }
}

class ElementInfo extends StatelessWidget {
  final String title;
  final String value;
  const ElementInfo({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
