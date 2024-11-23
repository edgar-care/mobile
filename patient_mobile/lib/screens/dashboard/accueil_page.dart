// ignore_for_file: use_build_context_synchronously

import 'package:edgar_app/screens/dashboard/traitement_page.dart';
import 'package:edgar_app/services/get_appointement.dart';
import 'package:edgar_app/services/get_information_patient.dart';
import 'package:edgar_app/services/medecine.dart';
import 'package:edgar_app/services/medical_antecedent.dart';
import 'package:edgar_app/utils/appoitement_utils.dart';
import 'package:edgar_app/utils/treatement_utils.dart';
import 'package:edgar_app/widget/appoitement_card.dart';
import 'package:edgar_app/widget/card_traitement_info.dart';
import 'package:flutter/material.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../services/doctor.dart';

class HomePage extends StatefulWidget {
  final void Function(int) onItemTapped;
  const HomePage({super.key, required this.onItemTapped});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> infoMedical = {};
  List<Map<String, dynamic>> rdv = [];
  List<dynamic> allDoctor = [];
  String docteurName = '';
  String docteurFirstName = '';
 List<Map<String, dynamic>> medicalAntecedent = [];
  Map<String, String> medicaments = {};
  List<Map<String, dynamic>> meds = [];

  void getAllMedicines() async {
    meds = await getMedecines(context);
    for (var treatment in meds) {
      medicaments[treatment['id']] = treatment['name'];
    }
  }

  void refresh() {
    setState(() {
      fetchData();
    });
  }


  Future<void> fetchData() async {
    await getMedicalAntecedent(context).then((value) {
      if (value.isNotEmpty) {
        medicalAntecedent = value;
      } else {
        TopErrorSnackBar(message: "Error on fetching medical antecedent")
            .show(context);
      }
    });
    await getMedecines(context).then((value) {
      if (value.isNotEmpty) {
        meds = value;    
        for (var treatment in meds) {
          medicaments[treatment['id']] = treatment['name'];
        }
      } else {
        TopErrorSnackBar(message: "Error on fetching medecine").show(context);
        return [];
      }
    });
    await getAllDoctor(context).then((value) {
      if (value.isNotEmpty) {
        allDoctor = value;
      } else {
        TopErrorSnackBar(message: "Error on fetching doctor").show(context);
      }
    });

    await getAppointement(context).then((value) {
      if (value!.isNotEmpty) {
        rdv = List<Map<String, dynamic>>.from(value['rdv']);
      } else {
        TopErrorSnackBar(message: "Error on fetching appoitement")
            .show(context);
      }
    });
    await getMedicalFolder(context).then((value) {
      if (value.isNotEmpty) {
        infoMedical = value;
      } else {
        TopErrorSnackBar(message: "Error on fetching name").show(context);
      }
    });

  }

  DateTime now = DateTime.now();

  Map<String, dynamic>? getNextAppointment() {
    if (rdv.isEmpty) return null;

    DateTime now = DateTime.now();
    List<Map<String, dynamic>> acceptedAppointments = rdv.where((appointment) {
      return DateTime.fromMillisecondsSinceEpoch(
              appointment['start_date'] * 1000)
          .isAfter(now);
    }).toList();

    if (acceptedAppointments.isEmpty) return null;

    acceptedAppointments.sort((a, b) {
      DateTime dateA =
          DateTime.fromMillisecondsSinceEpoch(a['start_date'] * 1000);
      DateTime dateB =
          DateTime.fromMillisecondsSinceEpoch(b['start_date'] * 1000);
      return dateA.compareTo(dateB);
    });

    // Safely handle doctor information
    try {
      Doctor? doc =
          findDoctorById(allDoctor, acceptedAppointments.first['doctor_id']);
      if (doc != null) {
        docteurName = doc.name;
        docteurFirstName = doc.firstname;
      } else {
        docteurName = "Unknown";
        docteurFirstName = "Doctor";
      }
    } catch (e) {
      Logger().e("Error finding doctor: $e");
      docteurName = "Unknown";
      docteurFirstName = "Doctor";
    }

    return acceptedAppointments.first;
  }

  List<Map<String, dynamic>> getTraitement() {
    List<Map<String, dynamic>> traitements = [];
    for (var disease in medicalAntecedent) {
      Logger().d(disease);
      for (var treatment in disease["treatments"]) {
        if (treatment["end_date"] == null ||
            treatment["end_date"] == 0 ||
            treatment["end_date"] >
                DateTime.now().millisecondsSinceEpoch) {
          traitements.add({
            'medId': disease["id"],
            "medNames": disease["name"],
            "treatment": Treatment.fromJson(treatment),
          });
        }
      }
    }
    return traitements;
  }

  void deleteTraitement(String id) async {
    await deleteTraitementRequest(id, context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.blue700,
            ),
          );
        } else {
          Map<String, dynamic>? nextAppointment = getNextAppointment();  
          List<Map<String, dynamic>> traitements = getTraitement();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset("assets/images/logo/Group-1.svg"),
                  const SizedBox(width: 4),
                  SvgPicture.asset("assets/images/logo/Group.svg"),
                  const Spacer(),
                  Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: BoringAvatar(
                        name:
                            "${infoMedical['firstname'] ?? 'Ne fonctionne'} ${infoMedical['name'] != null ? infoMedical["name"].toUpperCase() : 'Pas'}",
                        palette: BoringAvatarPalette(
                          [
                            AppColors.blue700,
                            AppColors.blue200,
                            AppColors.blue500
                          ],
                        ),
                        type: BoringAvatarType.beam,
                        shape: CircleBorder(),
                      )),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                DateTime.now().hour > 18
                    ? 'Bonsoir, ${infoMedical['firstname'] != null ? infoMedical["firstname"].toUpperCase() : 'medical Folder Doesnt work'} !'
                    : 'Bonjour, ${infoMedical['firstname'] != null ? infoMedical["firstname"].toUpperCase() : 'medical Folder Doesnt work'} !',
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Votre prochain rendez-vous",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 2,
                decoration: const BoxDecoration(
                  color: AppColors.blue700,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              const SizedBox(height: 8),
              nextAppointment != null
                  ? AppoitementCard(
                      startDate: DateTime.fromMillisecondsSinceEpoch(
                          nextAppointment['start_date'] * 1000),
                      endDate: DateTime.fromMillisecondsSinceEpoch(
                          nextAppointment['end_date'] * 1000),
                      doctor: "${docteurName.toUpperCase()} $docteurFirstName",
                      onTap: () {},
                    )
                  : const Text(
                      'Pas de prochain rendez-vous',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              const SizedBox(height: 24),
              const Text(
                'Besoin d’un nouveau rendez-vous ?',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 12),
              Buttons(
                msg: const Text("Prendre un rendez-vous"),
                size: SizeButton.md,
                variant: Variant.primary,
                onPressed: () {
                  Navigator.pushNamed(context, '/simulation/intro');
                },
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                "Mes Traitement en cours",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 2,
                decoration: const BoxDecoration(
                  color: AppColors.blue700,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child:
                ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8,
                  ),
                  itemCount: traitements.length <= 3 ? traitements.length : 3,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
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
                                    SubMenu(
                                        treatment: traitements[index],
                                        deleteTraitement: deleteTraitement,
                                        index: index,
                                        meds: meds,
                                        medId: traitements[index]["medId"],
                                        refresh: refresh),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: CardTraitementSimplify(
                          medicaments: medicaments,
                          name: traitements[index]["medNames"],
                          traitement: traitements[index]["treatment"]),
                    );
                  },
                ),
              ),
              if (traitements.length > 3) ...[
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    widget.onItemTapped(3);
                  },
                  child: const Text(
                    "Voir plus de traitements",
                    style: TextStyle(
                      color: AppColors.blue700,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ]
            ],
          );
        }
      },
    );
  }
}
