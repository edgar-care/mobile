import 'package:edgar_app/services/appointement.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_app/utils/appoitement_utils.dart';
import 'package:edgar/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CardAppointementDoctorHour extends StatefulWidget {
  final Appointment appointements;
  final Function updateId;
  final String idSelected;

  const CardAppointementDoctorHour({
    super.key,
    required this.appointements,
    required this.updateId,
    required this.idSelected,
  });

  @override
  State<CardAppointementDoctorHour> createState() =>
      _CardAppointementDoctorHourState();
}

class _CardAppointementDoctorHourState
    extends State<CardAppointementDoctorHour> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr', null);
  }

  final ValueNotifier<int> pageIndex = ValueNotifier(0);

  String getAbbreviatedWeekday(String weekday) {
    if (weekday.isEmpty) {
      return '';
    }
    if (weekday.length < 2) {
      return weekday.toUpperCase();
    }
    return (weekday[0].toUpperCase() + weekday.substring(1)).substring(0, 3);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            widget.appointements.doctor,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: AppColors.black,
            ),
          ),
          Text(
            widget.appointements.address.street,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: AppColors.black,
            ),
          ),
          Text(
            '${widget.appointements.address.zipCode} ${widget.appointements.address.city}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: AppColors.black,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Divider(
            color: AppColors.blue700,
            thickness: 1,
          ),
          const SizedBox(
            height: 4,
          ),
          if (widget.appointements.dates.isEmpty)
            const Center(
              child: Text(
                'Aucun rendez-vous disponible',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: AppColors.black,
                ),
              ),
            )
          else
            SizedBox(
              height: 160, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.appointements.dates.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 82,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: index == widget.appointements.dates.length - 1
                              ? AppColors.white
                              : AppColors.blue200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          getAbbreviatedWeekday(
                            DateFormat('EEEE', 'fr').format(
                              DateFormat('dd/MM/yyyy').parse(
                                widget.appointements.dates[index].day,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM', 'fr')
                              .format(
                                DateFormat('dd/MM/yyyy').parse(
                                  widget.appointements.dates[index].day,
                                ),
                              )
                              .substring(0,
                                  6), // Modification to include only the first three letters of the month
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        for (var hour
                            in widget.appointements.dates[index].hour.take(3))
                          HourItem(
                            hour: hour.hour,
                            onTap: () => widget.updateId(hour.id),
                            isSelect: hour.id == widget.idSelected,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          if (widget.appointements.dates.isNotEmpty)
            const SizedBox(
              height: 8,
            ),
          if (widget.appointements.dates.isNotEmpty)
            Buttons(
              variant: Variant.secondary,
              size: SizeButton.sm,
              msg: const Text("Voir plus d'horaires"),
              onPressed: () {
                final model =
                    Provider.of<BottomSheetModel>(context, listen: false);
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
                            SeeMore(
                                appointements: widget.appointements,
                                idSelected: widget.idSelected,
                                updateId: widget.updateId)
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SeeMore extends StatefulWidget {
  final Appointment appointements;
  final Function updateId;
  String idSelected;
  SeeMore({
    super.key,
    required this.appointements,
    required this.idSelected,
    required this.updateId,
  });

  @override
  State<SeeMore> createState() => _SeeMoreState();
}

class _SeeMoreState extends State<SeeMore> {
  String idselected = '';

  void updateId(String id) {
    setState(() {
      widget.idSelected = id;
      idselected = id;
    });
  }

  String getAbbreviatedWeekday(String weekday) {
    if (weekday.isEmpty) {
      return '';
    }
    if (weekday.length < 2) {
      return weekday.toUpperCase();
    }
    return (weekday[0].toUpperCase() + weekday.substring(1)).substring(0, 3);
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Séléctionner un rendez-vous",
      subtitle: "Choisissez vos horraire",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.calendar,
          color: AppColors.green700,
          size: 18,
        ),
        type: ModalType.success,
      ),
      body: [
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.appointements.dates.length,
            itemBuilder: (context, index) {
              final date = widget.appointements.dates[index];
              return Container(
                width: 100, // Adjust the width as needed
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: index == widget.appointements.dates.length - 1
                          ? Colors.transparent
                          : AppColors.blue200,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      getAbbreviatedWeekday(
                        DateFormat('EEEE', 'fr').format(
                          DateFormat('dd/MM/yyyy').parse(date.day),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      DateFormat('dd MMMM', 'fr').format(
                        DateFormat('dd/MM/yyyy').parse(date.day),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 237,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: date.hour
                            .map((hour) => HourItem(
                                  hour: hour.hour,
                                  onTap: () {
                                    updateId(hour.id);
                                    widget.updateId(hour.id);
                                  },
                                  isSelect: hour.id == widget.idSelected,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
      footer: Buttons(
        variant: Variant.primary,
        size: SizeButton.sm,
        msg: const Text("Valider le rendez-vous"),
        onPressed: () async {
          if (idselected.isEmpty) {
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

            await postAppointementId(idselected, sessionId!).then(
              (value) {
                if (value) {
                  Navigator.pushNamed(
                    // ignore: use_build_context_synchronously
                    context,
                    '/simulation/confirmation',
                  );
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    ErrorSnackBar(
                      message:
                          "Une erreur s'est produite lors de la validation du rendez-vous.",
                      // ignore: use_build_context_synchronously
                      context: context,
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class HourItem extends StatefulWidget {
  final String hour;
  final bool isSelect;
  final Function onTap;
  const HourItem(
      {super.key,
      required this.hour,
      required this.onTap,
      required this.isSelect});

  @override
  State<HourItem> createState() => _HourItemState();
}

class _HourItemState extends State<HourItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onTap();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 4),
        width: 64,
        decoration: BoxDecoration(
          color: widget.isSelect ? AppColors.blue700 : AppColors.blue200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            widget.hour.replaceFirst(':', 'H'),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: widget.isSelect ? AppColors.white : AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
