// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:edgar_app/services/appointement.dart';
import 'package:edgar_app/services/doctor.dart';
import 'package:edgar_app/utils/appoitement_utils.dart';
import 'package:edgar_app/widget/appointement_card.dart';
import 'package:edgar_app/widget/card_doctor_appoitement.dart';
import 'package:edgar_app/widget/field_custom_perso.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:edgar_app/services/get_appointement.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';

enum RdvStatus { done, waiting }

int screenWidth = 0;

class GestionRendezVous extends StatefulWidget {
  const GestionRendezVous({super.key});

  @override
  State<GestionRendezVous> createState() => _GestionRendezVousPageState();
}

class _GestionRendezVousPageState extends State<GestionRendezVous> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<Map<String, dynamic>> rdv = [];

  List<dynamic> doctor = [];

  RdvStatus status = RdvStatus.waiting;

  final currentDate = DateTime.now();

  Future<void> fetchData() async {
    await getAppointement(context).then((value) {
      if (value!.isNotEmpty) {
        rdv = List<Map<String, dynamic>>.from(value['rdv']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
            message: "Error on fetching appointement", context: context));
      }
    });

    doctor = await getAllDoctor(context);
  }

  Future<void> updateDate(BuildContext context) async {
    fetchData();
    setState(() {});
  }

  List<Map<String, dynamic>> getPastAppointments() {
    DateTime now = DateTime.now();
    return rdv.where((appointment) {
      return DateTime.fromMillisecondsSinceEpoch(
                  appointment['start_date'] * 1000)
              .isBefore(now) &&
          (appointment['appointment_status'] != 'CANCELED' ||
              appointment['appointment_status'] != 'CANCELED_DUE_TO_REVIEW');
    }).toList();
  }

  List<Map<String, dynamic>> getUpcomingAppointments() {
    DateTime now = DateTime.now();
    return rdv.where((appointment) {
      return DateTime.fromMillisecondsSinceEpoch(
                  appointment['start_date'] * 1000)
              .isAfter(now) &&
          (appointment['appointment_status'] != 'CANCELED' ||
              appointment['appointment_status'] != 'CANCELED_DUE_TO_REVIEW');
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.blue700,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(children: [
            Image.asset(
              'assets/images/logo/edgar-high-five.png',
              width: 40,
            ),
            const SizedBox(width: 16),
            const Text(
              'Mes rendez-vous',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ]),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Flexible(
                child: Buttons(
              variant: status == RdvStatus.waiting
                  ? Variant.primary
                  : Variant.secondary,
              size: SizeButton.sm,
              msg: const Text('Prochain rendez-vous'),
              onPressed: () {
                setState(() {
                  status = RdvStatus.waiting;
                });
              },
            )),
            const SizedBox(width: 8),
            Flexible(
                child: Buttons(
              variant: status == RdvStatus.done
                  ? Variant.primary
                  : Variant.secondary,
              size: SizeButton.sm,
              msg: const Text('Rendez-vous passés'),
              onPressed: () {
                setState(() {
                  status = RdvStatus.done;
                });
              },
            )),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue700,
                      strokeWidth: 2,
                    ),
                  );
                } else {
                  final tmp = status == RdvStatus.done
                      ? getPastAppointments()
                      : getUpcomingAppointments();
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 4);
                    },
                    itemBuilder: (context, index) {
                      final Doctor dct =
                          findDoctorById(doctor, tmp[index]["doctor_id"]) ??
                              Doctor(
                                  id: '',
                                  firstname: '',
                                  name: '',
                                  address: Address(
                                      street: '',
                                      zipCode: '',
                                      country: '',
                                      city: ''));
                      return AppoitementCard(
                        startDate: DateTime.fromMillisecondsSinceEpoch(
                            tmp[index]["start_date"] * 1000),
                        endDate: DateTime.fromMillisecondsSinceEpoch(
                            tmp[index]["end_date"] * 1000),
                        doctor: '${dct.name.toUpperCase()} ${dct.firstname}',
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
                                      OpenRdv(
                                        model: model,
                                        rdv: tmp[index],
                                        doctor: doctor,
                                      ),
                                      DeleteRdv(
                                        updataData: updateDate,
                                        model: model,
                                        id: tmp[index]['id']!.toString(),
                                      ),
                                      ModifyRdv(
                                        id: tmp[index]['id']!.toString(),
                                        updataData: updateDate,
                                        model: model,
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        status: status == RdvStatus.done
                            ? AppointementStatus.done
                            : AppointementStatus.waiting,
                      );
                    },
                    itemCount: tmp.length,
                  );
                }
              }),
        ),
      ],
    );
  }
}

class OpenRdv extends StatefulWidget {
  final BottomSheetModel model;
  final Map<String, dynamic> rdv;
  final List<dynamic> doctor;
  const OpenRdv({
    super.key,
    required this.model,
    required this.rdv,
    required this.doctor,
  });

  @override
  State<OpenRdv> createState() => _OpenRdvState();
}

class _OpenRdvState extends State<OpenRdv> {
  @override
  Widget build(BuildContext context) {
    final Doctor dct = findDoctorById(widget.doctor, widget.rdv["doctor_id"]) ??
        Doctor(
            id: '',
            firstname: '',
            name: '',
            address: Address(street: '', zipCode: '', country: '', city: ''));
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(widget.rdv["start_date"] * 1000);
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(widget.rdv["end_date"] * 1000);
    return ModalContainer(
      title: "Informations sur votre rendez-vous",
      subtitle: "Consulter et gérer votre rendez-vous.",
      icon: IconModal(
        icon: SvgPicture.asset(
          "assets/images/utils/calendar_modal.svg",
          width: 18,
        ),
        type: ModalType.info,
      ),
      body: [
        Row(
          children: [
            // ignore: deprecated_member_use
            SvgPicture.asset(
              "assets/images/utils/calendar_modal.svg",
              width: 18,
              // ignore: deprecated_member_use
              color: AppColors.black,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                "Rendez-vous du ${DateFormat('dd MMMM yyyy', 'fr').format(startDate)} de ${startDate.hour.toString().padLeft(2, '0')}h${startDate.minute.toString().padLeft(2, '0')} à ${endDate.hour.toString().padLeft(2, '0')}h${endDate.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // ignore: deprecated_member_use
            SvgPicture.asset(
              "assets/images/utils/personna.svg",
              width: 18,
              // ignore: deprecated_member_use
              color: AppColors.black,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                "Docteur ${dct.name} ${dct.firstname}",
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // ignore: deprecated_member_use
            SvgPicture.asset(
              "assets/images/utils/maps_point.svg",
              width: 18,
              // ignore: deprecated_member_use
              color: AppColors.black,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                "${dct.address.street}, ${dct.address.zipCode} ${dct.address.city}",
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
      ],
      footer: Column(
        children: [
          Buttons(
            variant: Variant.primary,
            size: SizeButton.md,
            msg: const Text('Modifier'),
            onPressed: () async {
              widget.model.changePage(2);
            },
          ),
          const SizedBox(
            height: 8,
          ),
          Buttons(
            variant: Variant.delete,
            size: SizeButton.md,
            msg: const Text('Supprimer'),
            onPressed: () {
              widget.model.changePage(1);
            },
          ),
        ],
      ),
    );
  }
}

class DeleteRdv extends StatefulWidget {
  final Function updataData;
  final BottomSheetModel model;
  final String id;
  const DeleteRdv({
    super.key,
    required this.updataData,
    required this.model,
    required this.id,
  });

  @override
  State<DeleteRdv> createState() => _DeleteRdvState();
}

class _DeleteRdvState extends State<DeleteRdv> {
  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: 'Annuler votre rendez-vous',
      subtitle:
          'Vous êtes sur le point d’annuler votre rendez-vous. Si vous annulez ce rendez-vous, vous ne pourrez plus y assister. ',
      icon: IconModal(
        icon: Padding(
          padding: const EdgeInsets.all(2),
          child: SvgPicture.asset(
            "assets/images/utils/crossAppoitement.svg",
            // ignore: deprecated_member_use
            color: AppColors.red500,
            height: 16,
          ),
        ),
        type: ModalType.error,
      ),
      footer: Column(
        children: [
          Buttons(
            variant: Variant.delete,
            size: SizeButton.md,
            msg: const Text('Oui, annuler le rendez-vous'),
            onPressed: () async {
              await deleteAppointementId(widget.id, context);
              widget.updataData(context);
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: 8,
          ),
          Buttons(
            variant: Variant.secondary,
            size: SizeButton.md,
            msg: const Text('Non, garder le rendez-vous'),
            onPressed: () {
              widget.model.changePage(0);
            },
          ),
        ],
      ),
    );
  }
}

class ModifyRdv extends StatefulWidget {
  final String id;
  final Function updataData;
  final BottomSheetModel model;
  const ModifyRdv({
    super.key,
    required this.id,
    required this.updataData,
    required this.model,
  });

  @override
  State<ModifyRdv> createState() => _ModifyRdvState();
}

class _ModifyRdvState extends State<ModifyRdv> {
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
      var value = await getAllDoctor(context);
      if (value.isNotEmpty) {
        setState(() {
          doctorsTemp = value;
        });
        initializeDoctors();
        await fetchAppointments(currentPage); // Start fetching from page 1
      }
    } catch (e) {
      //catch clauses
    } finally {
      isLoading = false;
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
      var value = await getAppoitementDoctorById(id, context);
      if (value.isEmpty) {
        addEmptyAppointment(id);
      } else if (value.containsKey('rdv')) {
        addAppointmentFromResponse(id, value);
      }
    } catch (e) {
      //catch clauses
    }
  }

  void addEmptyAppointment(String id) {
    Doctor? doctor = findDoctorById(doctorsTemp, id);
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

  void onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
    fetchAppointments(currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
        title: "Modifier votre rendez-vous",
        subtitle:
            "Sélectionner une nouvelle date pour votre rendez-vous. Vous pouvez garder le même médecin ou en choisir un autre.",
        icon: IconModal(
          icon: SvgPicture.asset(
            "assets/images/utils/calendar_modal.svg",
            width: 32,
            height: 18,
          ),
          type: ModalType.info,
        ),
        body: [
          CustomFieldSearchPerso(
            label: "Rechercher par le nom du médecin",
            icon: SvgPicture.asset("assets/images/utils/search.svg"),
            keyboardType: TextInputType.text,
            onChange: filterDoctors,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: AppColors.blue700,
                    strokeWidth: 2,
                  )) // Afficher l'indicateur de chargement
                : ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      return CardAppointementDoctorHourModify(
                        appointements: appointments[index],
                        updateId: updateSelectedAppointment,
                        idSelected: selectedId,
                        oldId: widget.id,
                        updateData: widget.updataData,
                      );
                    },
                  ),
          ),
          Pagination(
            currentPage: currentPage,
            totalPages: totalPages,
            onPageChanged: onPageChanged,
          ),
        ],
        footer: Column(
          children: [
            Buttons(
              variant: Variant.primary,
              size: SizeButton.md,
              msg: const Text("Valider le changement"),
              onPressed: () async {
                if (selectedId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    ErrorSnackBar(
                      message:
                          "Veuillez sélectionner un rendez-vous avant de continuer.",
                      context: context,
                    ),
                  );
                } else {
                  await putAppoitement(widget.id, selectedId, context)
                      .whenComplete(
                    () async {
                      widget.updataData(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SuccessSnackBar(
                          message: "Rendez-vous validé avec succès.",
                          context: context,
                        ),
                      );
                      widget.model.changePage(0);

                      await putAppoitement(widget.id, selectedId, context)
                          .whenComplete(
                        () {
                          // ignore: use_build_context_synchronously
                          widget.updataData(context);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SuccessSnackBar(
                              message: "Rendez-vous validé avec succès.",
                              // ignore: use_build_context_synchronously
                              context: context,
                            ),
                          );
                          widget.model.changePage(0);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            Buttons(
                variant: Variant.secondary,
                size: SizeButton.md,
                msg: const Text("Annuler"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ));
  }
}
