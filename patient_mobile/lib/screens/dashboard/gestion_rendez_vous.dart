// ignore_for_file: use_build_context_synchronously

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_app/services/appointement.dart';
import 'package:edgar_app/services/doctor.dart';
import 'package:edgar_app/utils/appoitement_utils.dart';
import 'package:edgar_app/widget/card_doctor_appoitement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edgar_app/services/get_appointement.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';

enum RdvFilter {
  aVenir,
  passes,
  annules,
}

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

  final List<Map<String, String>> rdv = [];
  List<dynamic> doctor = [];

  final currentDate = DateTime.now();

  RdvFilter rdvFilter = RdvFilter.aVenir;
  Future<void> fetchData() async {
    final Map<String, dynamic>? rdvs =
        await getAppointement(context).whenComplete(() {
      setState(() {});
    });
    doctor = await getAllDoctor().whenComplete(() {
      setState(() {});
    });
    if (rdvs != null) {
      final uniqueRdv = <Map<String, String>>{};
      if (rdvs['rdv'] == null) {
        return;
      }
      rdv.clear();
      rdvs['rdv'].forEach((dynamic rdv) {
        final rendezVous = {
          'id': rdv['id'] as String,
          'date': DateFormat('dd/MM/yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(rdv['start_date'] * 1000)),
          'heure': DateFormat('HH:mm:ss').format(
              DateTime.fromMillisecondsSinceEpoch(rdv['start_date'] * 1000)),
          'fin': DateFormat('HH:mm:ss').format(
              DateTime.fromMillisecondsSinceEpoch(rdv['end_date'] * 1000)),
          'medecin':
              "Dr. ${doctor.firstWhere((element) => element['id'] == rdv['doctor_id'])['name'].toString()}",
          'adresse':
              '${doctor.firstWhere((element) => element['id'] == rdv['doctor_id'])["address"]["street"] ?? ""}, ${doctor.firstWhere((element) => element['id'] == rdv['doctor_id'])["address"]["zip_code"]}  ${doctor.firstWhere((element) => element['id'] == rdv['doctor_id'])["address"]["city"]}',
          'status': rdv['appointment_status'].toString(),
        };
        uniqueRdv.add(rendezVous); // Ajouter le rendez-vous au Set
      });
      rdv.addAll(uniqueRdv
          .toList()); // Convertir le Set en une liste et l'ajouter à rdv
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> updateDate(BuildContext context) async {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredRdv = rdv;
    screenWidth = MediaQuery.of(context).size.width.toInt();
    switch (rdvFilter) {
      case RdvFilter.aVenir:
        filteredRdv = rdv.where((element) {
          final rdvDate = DateFormat('dd/MM/yyyy').parse(element['date']!);
          return rdvDate.isAfter(DateTime.now()) &&
              element['status'] != 'CANCELED';
        }).toList();
        break;
      case RdvFilter.passes:
        filteredRdv = rdv.where((element) {
          final rdvDate = DateFormat('dd/MM/yyyy').parse(element['date']!);
          return rdvDate.isBefore(DateTime.now()) &&
              element['status'] != 'CANCELED';
        }).toList();
        break;
      case RdvFilter.annules:
        filteredRdv = rdv.where((element) {
          return element['status'] == 'CANCELED';
        }).toList();
        break;
    }

    rdv.sort((a, b) => DateFormat('dd/MM/yyyy')
        .parse(a['date']!)
        .compareTo(DateFormat('dd/MM/yyyy').parse(b['date']!)));

    if (rdv.any(
        (element) => element['date'] == DateFormat.yMd().format(currentDate))) {
      rdv.sort((a, b) => DateFormat('HH:mm:ss')
          .parse(a['heure']!)
          .compareTo(DateFormat('HH:mm:ss').parse(b['heure']!)));
    }

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
        const SizedBox(height: 30),
        DateSlider(rdv: rdv),
        const SizedBox(height: 30),
        SwitchThreeElements(
          onValueChanged: (RdvFilter value) {
            setState(() {
              rdvFilter = value;
            });
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: filteredRdv.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final appointment = filteredRdv[index];
              return CardRdv(rdv: appointment, updataData: updateDate);
            },
          ),
        ),
      ],
    );
  }
}

class DateSlider extends StatelessWidget {
  final List<Map<String, String>> rdv;
  const DateSlider({super.key, required this.rdv});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 8),
              shrinkWrap: true,
              itemCount: 60, // Nombre total de cartes de dates (2 mois)
              itemBuilder: (context, index) {
                final currentDate = DateTime.now().add(Duration(days: index));
                final isToday = index == 0;
                final isRdv = rdv.any((element) =>
                    element['date'] == DateFormat.yMd().format(currentDate));
                return Row(
                  children: [
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 70, // Largeur fixe pour chaque carte
                      height: 90,
                      child: DateCard(
                        month: DateFormat.MMMM()
                            .format(currentDate)
                            .substring(0, 3),
                        date: DateFormat.d().format(currentDate),
                        isRdv: isRdv,
                        isToday: isToday,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DateCard extends StatelessWidget {
  final String month;
  final String date;
  final bool isRdv;
  final bool isToday;

  const DateCard(
      {super.key,
      required this.month,
      required this.date,
      required this.isRdv,
      required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey200, width: 1),
        color: isToday ? AppColors.blue700 : Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            month, // Replace with the actual month value
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isToday ? Colors.white : AppColors.grey500,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRdv ? Colors.green : Colors.transparent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isToday ? Colors.white : AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}

class SwitchThreeElements extends StatefulWidget {
  final ValueChanged<RdvFilter> onValueChanged;
  const SwitchThreeElements({super.key, required this.onValueChanged});

  @override
  // ignore: library_private_types_in_public_api
  _SwitchThreeElementsState createState() => _SwitchThreeElementsState();
}

class _SwitchThreeElementsState extends State<SwitchThreeElements> {
  RdvFilter selectedFilter = RdvFilter.aVenir;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.grey500, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SwitchElement(
            text: "A venir",
            isSelected: selectedFilter == RdvFilter.aVenir,
            onPressed: () {
              setState(() {
                selectedFilter = RdvFilter.aVenir;
                widget.onValueChanged(selectedFilter);
              });
            },
          ),
          SwitchElement(
            text: "Passés",
            isSelected: selectedFilter == RdvFilter.passes,
            onPressed: () {
              setState(() {
                selectedFilter = RdvFilter.passes;
                widget.onValueChanged(selectedFilter);
              });
            },
          ),
          SwitchElement(
            text: "Annulés",
            isSelected: selectedFilter == RdvFilter.annules,
            onPressed: () {
              setState(() {
                selectedFilter = RdvFilter.annules;
                widget.onValueChanged(selectedFilter);
              });
            },
          ),
        ],
      ),
    );
  }
}

class SwitchElement extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const SwitchElement(
      {super.key,
      required this.text,
      required this.isSelected,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue700 : Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.grey500,
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String filterToString(RdvFilter filter) {
  switch (filter) {
    case RdvFilter.aVenir:
      return 'A venir';
    case RdvFilter.passes:
      return 'Passés';
    case RdvFilter.annules:
      return 'Annulés';
    default:
      return '';
  }
}

// ignore: must_be_immutable
class CardRdv extends StatefulWidget {
  final Map<String, String> rdv;
  Function updataData;
  CardRdv({
    super.key,
    required this.rdv,
    required this.updataData,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CardRdvState createState() => _CardRdvState();
}

class _CardRdvState extends State<CardRdv> {
  @override
  Widget build(BuildContext context) {
    var currenDate = DateTime.now();

    bool isVisible = false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  widget.rdv['date'] ==
                          DateFormat('dd/MM/yyyy').format(currenDate)
                      ? 'Aujourd\'hui'
                      : widget.rdv['date'] ==
                              DateFormat('dd/MM/yyyy').format(
                                  currenDate.add(const Duration(days: 1)))
                          ? 'Demain'
                          : widget.rdv['date']!,
                  style: const TextStyle(
                    color: AppColors.green500,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.rdv['heure']
                          ?.replaceAll(':', 'H')
                          .substring(0, 5)
                          .trim()
                          .replaceFirst("H", " H ") ??
                      '',
                  style: const TextStyle(
                    color: AppColors.grey950,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  "30 min",
                  style: TextStyle(
                    color: AppColors.grey400,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.grey200, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.rdv['medecin'] ?? '',
                        style: const TextStyle(
                          color: AppColors.grey950,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
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
                                      OpenRdv(model: model),
                                      DeleteRdv(
                                        updataData: widget.updataData,
                                        model: model,
                                        id: widget.rdv['id']!,
                                      ),
                                      ModifyRdv(
                                        id: widget.rdv['id']!,
                                        updataData: widget.updataData,
                                        model: model,
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: const Icon(
                          BootstrapIcons.three_dots_vertical,
                          color: AppColors.grey500,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 1,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.rdv['adresse'] ?? '',
                          style: const TextStyle(
                            color: AppColors.grey950,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        child: const Icon(
                          BootstrapIcons.chevron_right,
                          color: AppColors.grey500,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OpenRdv extends StatefulWidget {
  final BottomSheetModel model;
  const OpenRdv({
    super.key,
    required this.model,
  });

  @override
  State<OpenRdv> createState() => _OpenRdvState();
}

class _OpenRdvState extends State<OpenRdv> {
  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Mettre à jour les donnée du rendez-vous?",
      subtitle: "Voulez modifier ou supprimer le rendez-vous",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.$0_circle_fill,
          color: AppColors.blue700,
          size: 18,
        ),
        type: ModalType.info,
      ),
      body: [
        Buttons(
          variant: Variant.primary,
          size: SizeButton.sm,
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
          size: SizeButton.sm,
          msg: const Text('Supprimer'),
          onPressed: () {
            widget.model.changePage(1);
          },
        ),
      ],
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
      title: 'Êtes-vous sûr ?',
      subtitle:
          'Si vous supprimez ce document, ni vous ni votre médecin ne pourrez le consulter.',
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.x,
          color: AppColors.red700,
          size: 18,
        ),
        type: ModalType.error,
      ),
      footer: Row(
        children: [
          Flexible(
            child: Buttons(
              variant: Variant.secondary,
              size: SizeButton.sm,
              msg: const Text('Annuler'),
              onPressed: () {
                widget.model.changePage(0);
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: Buttons(
              variant: Variant.delete,
              size: SizeButton.sm,
              msg: const Text('Supprimer'),
              onPressed: () async {
                await deleteAppointementId(widget.id);
                widget.updataData(context);
                Navigator.pop(context);
              },
            ),
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
      title:
          "Vous pouvez maintenant sélectionner un rendez-vous chez un médecin.",
      subtitle: "Séléctionner un autre rendez-vous",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.pen_fill,
          size: 18,
          color: AppColors.green700,
        ),
        type: ModalType.success,
      ),
      body: [
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
      ],
      footer: GestureDetector(
        onTap: () async {
          if (selectedId.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              ErrorSnackBar(
                message:
                    "Veuillez sélectionner un rendez-vous avant de continuer.",
                context: context,
              ),
            );
          } else {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? sessionId = prefs.getString('sessionId');
            Logger().i("session_id: $sessionId");

            await putAppoitement(widget.id, selectedId).whenComplete(
              () {
                widget.updataData(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SuccessSnackBar(
                    message: "Rendez-vous validé avec succès.",
                    context: context,
                  ),
                );
                widget.model.changePage(0);
                Navigator.pop(context);
              },
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
    );
  }
}
