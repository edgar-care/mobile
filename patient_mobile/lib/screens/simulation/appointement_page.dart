import 'package:edgar/services/appointement.dart';
import 'package:edgar/services/doctor.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/utils/traitement_utils.dart';
import 'package:edgar/widget/card_doctor_appoitement.dart';
import 'package:edgar/widget/pagination.dart';
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
  List<Map<Doctor, String>> allDoctors = [];
  List<Map<Doctor, String>> allDoctorsFilter = [];

  List<dynamic> doctorstmp = [];

  String idSelected = '';

  int currentPage = 0;
  int totalPages = 30;

  Future<void> fetchData() async {
    var value = await getAllDoctor();
    if (value.isNotEmpty) {
      setState(() {
        doctorstmp = value;
      });
      getAllDoctors();
      get3Appointement(currentPage);
    }
  }

  void get3Appointement(int currentPage) async {
    setState(() {
      appointements = [];
    });
    for (var i = 0; i < 2; i++) {
      if (2 * currentPage + i < allDoctorsFilter.length) {
        await getAppointementDoctor(
            allDoctorsFilter[2 * currentPage + i].values.first);
      } else {
        break;
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

  void getAllDoctors() {
    for (var element in doctorstmp) {
      var id = element['id'];
      Doctor? doctor = findDoctorById(doctorstmp, id);
      setState(() {
        if (doctor != null) {
          allDoctors.add({doctor: id});
        }
      });
    }
    setState(() {
      allDoctorsFilter = allDoctors;
      totalPages = (allDoctorsFilter.length / 2 - 1).ceil();
      if (allDoctorsFilter.length % 2 != 0) {
        totalPages++;
      }
    });
  }

  Future<void> getAppointementDoctor(String id) async {
    await getAppoitementDoctorById(id).then((value) {
      if (value.isEmpty) {
        Doctor? doctor = findDoctorById(doctorstmp, id);
        Appointment appointement = Appointment(
          doctor: doctor != null ? doctor.name : 'Edgar',
          address: doctor != null
              ? doctor.address
              : Address(
                  city: 'Lyon',
                  country: 'France',
                  zipCode: '69000',
                  street: '1 rue du Paradis',
                ),
          dates: [],
        );
        setState(() {
          appointements.add(appointement);
        });
        return;
      }
      if (value.isNotEmpty && value.containsKey('rdv')) {
        Appointment? appointement = transformAppointments(doctorstmp, value);
        if (appointement != null) {
          setState(() {
            appointements.add(appointement);
          });
        }
        if (appointement == null) {
          Doctor? doctor = findDoctorById(doctorstmp, id);
          Appointment appointement = Appointment(
            doctor: doctor!.name == "" ? 'Edgar' : doctor.name,
            address: Address(
              city: doctor.address.city == "" ? 'Lyon' : doctor.address.city,
              country: doctor.address.country == ""
                  ? 'France'
                  : doctor.address.country,
              zipCode: doctor.address.zipCode == ""
                  ? '69000'
                  : doctor.address.zipCode,
              street: doctor.address.street == ""
                  ? '1 rue du Paradis'
                  : doctor.address.street,
            ),
            dates: [],
          );
          setState(() {
            appointements.add(appointement);
          });
        }
      }
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
  }

  void filterAppointementDoctor(String name) {
    setState(() {
      currentPage = 0;
      allDoctorsFilter = allDoctors
          .where((element) => element.keys.first.name.contains(name))
          .toList();
      totalPages = (allDoctorsFilter.length / 2 - 1).floor();
      if (allDoctorsFilter.length % 2 != 0) {
        totalPages++;
      }
      Logger().i('totalPages: $totalPages');
      Logger().i('allDoctorsFilter: ${allDoctorsFilter.length}');
    });
    get3Appointement(currentPage);
  }

  void onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
    get3Appointement(currentPage);
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
                    itemCount: appointements.length,
                    itemBuilder: (context, index) {
                      return CardAppointementDoctorHour(
                        appointements: appointements[index],
                        updateId: updateAppointementSelected,
                        idSelected: idSelected,
                      );
                    },
                  ),
                ),
                Pagination(
                    currentPage: currentPage,
                    totalPages: totalPages,
                    onPageChanged: onPageChanged),
                const SizedBox(
                  height: 16,
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
