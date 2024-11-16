// ignore_for_file: use_build_context_synchronously

import 'package:edgar_app/services/get_appointement.dart';
import 'package:edgar_app/services/get_information_patient.dart';
import 'package:edgar_app/utils/appoitement_utils.dart';
import 'package:edgar_app/widget/appoitement_card.dart';
import 'package:edgar_app/widget/medicament_day_card.dart';
import 'package:flutter/material.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_svg/svg.dart';

import '../../services/doctor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> infoMedical = {};
  List<Map<String, dynamic>> rdv = [];
  List<dynamic> allDoctor = [];

  Future<void> fetchData() async {
    await getAllDoctor().then((value) {
      if (value.isNotEmpty) {
        allDoctor = value;
      } else {
        TopErrorSnackBar(message: "Error on fetching doctor").show(context);
      }
    });

    await getMedicalFolder().then((value) {
      if (value.isNotEmpty) {
        infoMedical = value;
      } else {
        TopErrorSnackBar(message: "Error on fetching name").show(context);
      }
    });

    await getAppointement(context).then((value) {
      if (value.isNotEmpty) {
        rdv = List<Map<String, dynamic>>.from(value['rdv']);
      } else {
        TopErrorSnackBar(message: "Error on fetching appoitement").show(context);
      }
    });
    return;
  }

  DateTime now = DateTime.now();

  Map<String, dynamic>? getNextAppointment() {
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> acceptedAppointments = rdv.where((appointment) {
      return appointment['appointment_status'] == 'ACCEPTED_DUE_TO_REVIEW' &&
          DateTime.fromMillisecondsSinceEpoch(appointment['start_date'] * 1000)
              .isAfter(now);
    }).toList();

    acceptedAppointments.sort((a, b) {
      DateTime dateA =
          DateTime.fromMillisecondsSinceEpoch(a['start_date'] * 1000);
      DateTime dateB =
          DateTime.fromMillisecondsSinceEpoch(b['start_date'] * 1000);
      return dateA.compareTo(dateB);
    });

    return acceptedAppointments.isNotEmpty ? acceptedAppointments.first : null;
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
                      doctor: findDoctorById(
                                  allDoctor, nextAppointment['doctor_id'])
                              ?.name ??
                          'Docteur inconnu',
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
                "Mes médicaments à prendre aujourd'hui",
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
              const Expanded(
                child: DailyMedicamentCard(),
              ),
              const SizedBox(height: 12),
            ],
          );
        }
      },
    );
  }
}
