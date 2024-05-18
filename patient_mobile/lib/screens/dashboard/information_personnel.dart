import 'package:edgar/services/get_information_patient.dart';
import 'package:edgar/services/medecine.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/AddPatient/add_button.dart';
import 'package:edgar/widget/buttons.dart';
import 'package:edgar/widget/card_traitement_day.dart';
import 'package:edgar/widget/card_traitement_small.dart';
import 'package:edgar/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class InformationPersonnel extends StatefulWidget {
  const InformationPersonnel({super.key});

  @override
  State<InformationPersonnel> createState() => _InformationPersonnelState();
}

class _InformationPersonnelState extends State<InformationPersonnel>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> infoMedical = {};
  String birthdate = '';

  Future<void> fetchData() async {
    await getMedicalFolder().then((value) {
      if (value.isNotEmpty) {
        infoMedical = value;
        birthdate = DateFormat('dd/MM/yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
                infoMedical['birthdate'] * 1000));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
            message: "Error on fetching name", context: context));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              return CardInformationPersonnel(
                  infoMedical: infoMedical, birthdate: birthdate);
            }
          },
        ),
        const SizedBox(height: 16),
        Buttons(
            variant: Variante.primary,
            size: SizeButton.md,
            msg: const Text('Modifier les informations'),
            onPressed: () {}),
        const SizedBox(height: 16),
      ],
    );
  }
}

class CardInformationPersonnel extends StatefulWidget {
  final String birthdate;
  final Map<String, dynamic> infoMedical;
  const CardInformationPersonnel(
      {super.key, required this.infoMedical, required this.birthdate});

  @override
  State<CardInformationPersonnel> createState() =>
      _CardInformationPersonnelState();
}

class _CardInformationPersonnelState extends State<CardInformationPersonnel> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
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
              value: widget.infoMedical['name'],
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Nom: ',
              value: widget.infoMedical['firstname'],
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
              value: widget.infoMedical['primary_doctor_id'],
            ),
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
                          WoltModalSheet.show<void>(
                            context: context,
                            pageListBuilder: (modalSheetContext) {
                              return [
                                infoTraitement(
                                  context,
                                  treatment,
                                ),
                              ];
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
    ));
  }
}

WoltModalSheetPage infoTraitement(
  BuildContext context,
  Map<String, dynamic> traitement,
) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: BodyInfoModal(
          traitement: traitement,
        ),
      ),
    ),
  );
}

// ignore: must_be_immutable
class BodyInfoModal extends StatefulWidget {
  Map<String, dynamic> traitement;
  BodyInfoModal({super.key, required this.traitement});

  @override
  State<BodyInfoModal> createState() => _BodyInfoModalState();
}

class _BodyInfoModalState extends State<BodyInfoModal> {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              color: AppColors.blue50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.blue200,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/utils/Union.svg',
                  width: 16,
                  height: 16,
                  // ignore: deprecated_member_use
                  color: widget.traitement['medicines'].isEmpty
                      ? AppColors.grey300
                      : AppColors.blue700,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.traitement['name'],
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )),
        const SizedBox(height: 12),
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
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.55,
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
