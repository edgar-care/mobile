// ignore_for_file: use_build_context_synchronously

import 'package:edgar_app/services/appointement.dart';
import 'package:edgar_app/services/doctor.dart';
import 'package:edgar_app/utils/appoitement_utils.dart';
import 'package:edgar_app/widget/card_doctor_appoitement.dart';
import 'package:flutter/material.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  int currentPage = 1;
  int totalPages = 0;
  bool isInitialLoading = false;
  bool isPageLoading = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _handleAppointmentSubmission() async {
    if (selectedId.isEmpty) {
      TopErrorSnackBar(
        message: "Veuillez sélectionner un rendez-vous avant de continuer.",
      ).show(context);
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString('sessionId');

      if (sessionId == null) {
        TopErrorSnackBar(
          message: "Session invalide. Veuillez vous reconnecter.",
        ).show(context);
        return;
      }

      final success = await postAppointementId(selectedId, sessionId, context);
      if (success) {
        if (mounted) {
          Navigator.pushNamed(context, '/simulation/confirmation');
        }
      } else {
        if (mounted) {
          TopErrorSnackBar(
            message:
                "Une erreur s'est produite lors de la validation du rendez-vous.",
          ).show(context);
        }
      }
    } catch (e) {
      if (mounted) {
        TopErrorSnackBar(
          message: "Une erreur inattendue s'est produite. Veuillez réessayer.",
        ).show(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  void updateSelectedAppointment(String id) {
    setState(() {
      selectedId = (selectedId == id) ? '' : id;
    });
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isInitialLoading = true;
      });
      var value = await getAllDoctor(context);
      if (value.isNotEmpty) {
        setState(() {
          doctorsTemp = value;
        });
        initializeDoctors();
        await fetchAppointments(currentPage);
      }
    } catch (e) {
      // Handle errors appropriately
    } finally {
      setState(() {
        isInitialLoading = false;
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
      filteredDoctors = allDoctors.toSet().toList();
      totalPages = (filteredDoctors.length / 2).ceil();
    });
  }

  void filterDoctors(String name) {
    setState(() {
      currentPage = 1; // Reset to first page
      filteredDoctors = allDoctors
          .where((element) => element.keys.first.name.contains(name))
          .toSet()
          .toList();
      totalPages = (filteredDoctors.length / 2).ceil();
    });
    fetchAppointments(currentPage);
  }

  Future<void> fetchAppointments(int page) async {
    setState(() {
      isPageLoading = true;
    });

    int startIndex = (page - 1) * 2;
    List<Future> fetchFutures = [];
    List<Appointment> newAppointments = [];

    // Pre-populate the appointments list with loading placeholders
    for (var i = 0; i < 2; i++) {
      if (startIndex + i < filteredDoctors.length) {
        newAppointments.add(createLoadingAppointment());
      }
    }

    setState(() {
      appointments = newAppointments;
    });

    // Fetch appointments in parallel
    for (var i = 0; i < 2; i++) {
      if (startIndex + i < filteredDoctors.length) {
        fetchFutures.add(
          fetchDoctorAppointment(
              filteredDoctors[startIndex + i].values.first, i),
        );
      }
    }

    await Future.wait(fetchFutures);

    setState(() {
      isPageLoading = false;
    });
  }

  Appointment createLoadingAppointment() {
    return Appointment(
      doctor: "",
      address: Address(
        street: '',
        zipCode: '',
        country: '',
        city: '',
      ),
      dates: [],
    );
  }

  Future<void> fetchDoctorAppointment(String id, int index) async {
    try {
      var value = await getAppoitementDoctorById(id, context);
      if (value.isEmpty) {
        updateAppointmentAtIndex(createEmptyAppointment(id), index);
      } else if (value.containsKey('rdv')) {
        var appointment = transformAppointments(doctorsTemp, value);
        if (appointment != null) {
          updateAppointmentAtIndex(appointment, index);
        } else {
          updateAppointmentAtIndex(createEmptyAppointment(id), index);
        }
      }
    } catch (e) {
      updateAppointmentAtIndex(createEmptyAppointment(id), index);
    }
  }

  void updateAppointmentAtIndex(Appointment appointment, int index) {
    if (mounted) {
      setState(() {
        if (index < appointments.length) {
          appointments[index] = appointment;
        }
      });
    }
  }

  Appointment createEmptyAppointment(String id) {
    Doctor? doctor = findDoctorById(doctorsTemp, id);
    return Appointment(
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
                  child: isInitialLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: AppColors.blue700,
                          strokeWidth: 2,
                        ))
                      : appointments.isEmpty
                          ? const Center(
                              child: Text(
                                'Aucun médecin disponible',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: AppColors.black,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: appointments.length,
                              itemBuilder: (context, index) {
                                final appointment = appointments[index];
                                if (appointment.doctor.isEmpty) {
                                  return const AppointmentLoadingCard();
                                }
                                return CardAppointementDoctorHour(
                                  appointements: appointment,
                                  updateId: updateSelectedAppointment,
                                  idSelected: selectedId,
                                );
                              },
                            ),
                ),
                if (appointments.isNotEmpty) ...[
                  Pagination(
                    currentPage: currentPage,
                    totalPages: totalPages,
                    onPageChanged: (page) {
                      setState(() {
                        currentPage = page;
                      });
                      fetchAppointments(page);
                    },
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: isSubmitting ? null : _handleAppointmentSubmission,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSubmitting
                            ? AppColors.blue300
                            : AppColors.blue700,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isSubmitting
                                ? 'Validation en cours...'
                                : 'Valider le rendez-vous',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          if (isSubmitting)
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          else
                            const Icon(
                              BootstrapIcons.arrow_right_circle_fill,
                              color: AppColors.white,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppointmentLoadingCard extends StatelessWidget {
  const AppointmentLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.blue200,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Doctor Name
            const Text(
              'Dr. John Doe',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: AppColors.black,
              ),
            ),
            // Address Street
            const Text(
              '123 Medical Street',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: AppColors.black,
              ),
            ),
            // Address City and Zip
            const Text(
              '75000 Paris',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Divider(
              color: AppColors.blue700,
              thickness: 1,
            ),
            const SizedBox(height: 4),
            const Text(
              'Disponibilités',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
