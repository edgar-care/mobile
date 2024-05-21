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
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<Appointment> appointments = [];
  List<Map<Doctor, String>> allDoctors = [];
  List<Map<Doctor, String>> filteredDoctors = [];
  List<dynamic> doctorsTemp = [];
  String selectedId = '';
  int currentPage = 1; // Start at page 1
  int totalPages = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var value = await getAllDoctor();
      if (value.isNotEmpty) {
        setState(() {
          doctorsTemp = value;
        });
        initializeDoctors();
        await fetchAppointments(currentPage); // Start fetching from page 1
      }
    } catch (e) {
      Logger().e("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void initializeDoctors() {
    for (var element in doctorsTemp) {
      var id = element['id'];
      Doctor? doctor = findDoctorById(doctorsTemp, id);
      if (doctor != null) {
        setState(() {
          allDoctors.add({doctor: id});
        });
      }
    }
    setState(() {
      filteredDoctors = allDoctors;
      totalPages = (filteredDoctors.length / 2).ceil();
    });
  }

  Future<void> fetchAppointments(int currentPage) async {
    setState(() {
      appointments = [];
      isLoading = true;
    });

    int startIndex =
        (currentPage - 1) * 2; // Adjust start index for 1-based page
    for (var i = 0; i < 2; i++) {
      if (startIndex + i < filteredDoctors.length) {
        await fetchDoctorAppointment(
            filteredDoctors[startIndex + i].values.first);
      } else {
        break;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchDoctorAppointment(String id) async {
    try {
      var value = await getAppoitementDoctorById(id);
      if (value.isEmpty) {
        addEmptyAppointment(id);
      } else if (value.containsKey('rdv')) {
        addAppointmentFromResponse(id, value);
      }
    } catch (e) {
      Logger().e("Error fetching data: $e");
    }
  }

  void addEmptyAppointment(String id) {
    Doctor? doctor = findDoctorById(doctorsTemp, id);
    Logger().i("Doctor: ${doctor?.address.city}");
    Appointment appointment = Appointment(
      doctor:
          (doctor?.name.isEmpty ?? true) || (doctor?.firstname.isEmpty ?? true)
              ? "Dr. Edgar"
              : "Dr. ${doctor!.name} ${doctor.firstname}",
      address: Address(
        street: doctor?.address.street.isEmpty ?? true
            ? '1 rue de la Paix'
            : doctor!.address.street,
        zipCode: doctor?.address.zipCode.isEmpty ?? true
            ? '69000'
            : doctor!.address.zipCode,
        country: doctor?.address.country.isEmpty ?? true
            ? 'France'
            : doctor!.address.country,
        city: doctor?.address.city.isEmpty ?? true
            ? 'Lyon'
            : doctor!.address.city,
      ),
      dates: [],
    );
    setState(() {
      appointments.add(appointment);
    });
  }

  void addAppointmentFromResponse(String id, Map<String, dynamic> value) {
    Appointment? appointment = transformAppointments(doctorsTemp, value);

    Logger().i("Appointment: $appointment");
    if (appointment != null) {
      setState(() {
        appointments.add(appointment);
      });
    } else {
      addEmptyAppointment(id);
    }
  }

  void updateSelectedAppointment(String id) {
    setState(() {
      selectedId = (selectedId == id) ? '' : id;
    });
    Logger().i("Selected id: $selectedId");
  }

  void filterDoctors(String name) {
    setState(() {
      currentPage = 1; // Reset to first page
      filteredDoctors = allDoctors
          .where((element) => element.keys.first.name.contains(name))
          .toList();
      totalPages = (filteredDoctors.length / 2).ceil();
    });
    fetchAppointments(currentPage);
  }

  void onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
    fetchAppointments(currentPage);
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
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),
                CustomFieldSearch(
                  label: "Rechercher par le nom du médecin",
                  icon: SvgPicture.asset("assets/images/utils/search.svg"),
                  keyboardType: TextInputType.text,
                  onValidate: (value) {
                    filterDoctors(value);
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: AppColors.blue700,
                          strokeWidth: 2,
                        )) // Afficher l'indicateur de chargement
                      : ListView.builder(
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            return CardAppointementDoctorHour(
                              appointements: appointments[index],
                              updateId: updateSelectedAppointment,
                              idSelected: selectedId,
                            );
                          },
                        ),
                ),
                Pagination(
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onPageChanged: onPageChanged,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    if (selectedId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        ErrorLoginSnackBar(
                          message:
                              "Veuillez sélectionner un rendez-vous avant de continuer.",
                          context: context,
                        ),
                      );
                    } else {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? sessionId = prefs.getString('sessionId');
                      Logger().i("session_id: $sessionId");

                      await postAppointementId(selectedId, sessionId!).then(
                        (value) {
                          if (value) {
                            Navigator.pushNamed(
                              context,
                              '/simulation/confirmation',
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              ErrorLoginSnackBar(
                                message:
                                    "Une erreur s'est produite lors de la validation du rendez-vous.",
                                context: context,
                              ),
                            );
                          }
                        },
                      );
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
