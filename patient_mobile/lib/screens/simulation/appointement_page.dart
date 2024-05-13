import 'package:edgar/services/appointement.dart';
import 'package:edgar/services/doctor.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/utils/traitement_utils.dart';
import 'package:edgar/widget/card_doctor_appoitement.dart';
import 'package:edgar/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:edgar/widget/field_custom.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class AppointementPage extends StatefulWidget {
  const AppointementPage({super.key});

  @override
  State<AppointementPage> createState() => _AppointementPageState();
}

class _AppointementPageState extends State<AppointementPage> {
  @override
  initState() {
    super.initState();
    fetchData();
  }

  List<Appointment> appointements = [];
  List<Appointment> appointementsFilter = [];

  List<dynamic> doctors = [];

  String idSelected = '';

  Future<void> fetchData() async {
    var value = await getAllDoctor();
    if (value.isNotEmpty) {
      setState(() {
        doctors = value;
      });
      for (var doctor in doctors) {
        getAppointementDoctor(doctor['id']);
      }
    }
  }

  String getDate(String date) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(date) * 1000);
    var formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  String getHour(String date) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(date) * 1000);
    var formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

  Future<void> getAppointementDoctor(String id) async {
    await getAppoitementDoctorById(id).then((value) {
      if (value.isNotEmpty && value.containsKey('rdv')) {
        Logger().i('value: $value');
        Appointment? appointement = transformAppointments(doctors, value);
        if (appointement != null) {
          setState(() {
            appointements.add(appointement);
          });
        }
      }
    });
    setState(() {
      appointementsFilter = appointements;
    });
  }

  void updateAppointementSelected(String id) {
    setState(() {
      if (idSelected == id) {
        idSelected = '';
        return;
      }
      idSelected = id;
    });
    Logger().i('idSelected: $idSelected');
  }

  void filterAppointementDoctor(String name) {
    if (name.isEmpty) {
      setState(() {
        appointementsFilter = appointements;
      });
      return;
    }
    setState(() {
      appointementsFilter = appointements
          .where((element) => element.doctor.toLowerCase().contains(name))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 48,
            child: Column(
              children: [
                const Text(
                  "Vous pouvez maintenant sélectionner un rendez-vous chez un médecin.",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomFieldSearch(
                  label: "Rechercher par le nom du médecin",
                  icon: SvgPicture.asset("assets/images/utils/search.svg"),
                  keyboardType: TextInputType.text,
                  onValidate: (value) {
                    filterAppointementDoctor(value);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: appointementsFilter.length,
                    itemBuilder: (context, index) {
                      return CardAppointementDoxtorHour(
                        appointements: appointementsFilter[index],
                        updateId: updateAppointementSelected,
                        idSelected: idSelected,
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (idSelected.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
                          message:
                              "Veuillez sélectionner un rendez-vous avant de continuer.",
                          context: context));
                    } else {
                      await postAppointementId(idSelected, idSelected)
                          .then((value) {
                        if (value) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SuccessLoginSnackBar(
                                  message:
                                      "Votre rendez-vous a bien été pris en compte.",
                                  context: context))
                              .closed
                              .then((reason) {
                            Navigator.pushNamed(
                                // ignore: use_build_context_synchronously
                                context,
                                '/simulation/confirmation');
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              ErrorLoginSnackBar(
                                  message:
                                      "Une erreur est survenue lors de la prise de rendez-vous.",
                                  context: context));
                        }
                      });
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.blue700,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Valider le rendez-vous',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(
                          BootstrapIcons.arrow_right_circle_fill,
                          color: AppColors.white,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
