// ignore_for_file: use_build_context_synchronously

import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_app/services/medecine.dart';
import 'package:edgar_app/services/traitement.dart';
import 'package:edgar_app/utils/traitement_utils.dart';
import 'package:flutter/material.dart';

class DailyMedicamentCard extends StatefulWidget {
  const DailyMedicamentCard({super.key});

  @override
  State<DailyMedicamentCard> createState() => _DailyMedicamentCardState();
}

class _DailyMedicamentCardState extends State<DailyMedicamentCard> {
  List<dynamic> allTreatments = [];
  List<dynamic> followUp = [];
  List<dynamic> medecines = [];
  final DateTime daySelected = DateTime.now();
  List<Treatment> treatmentsMorning = [];
  List<Treatment> treatmentsAfterNoon = [];
  List<Treatment> treatmentsNight = [];
  List<Treatment> treatmentsEVENING = [];
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var tmp3 = await getMedecines(context);
    followUp = await getFollowUp(context);
    allTreatments = await getTraitement(context);
    treatmentsMorning = await getTreatmentsByDayAndPeriod(
        allTreatments, getDayEnum(), Period.MORNING);
    treatmentsAfterNoon = await getTreatmentsByDayAndPeriod(
        allTreatments, getDayEnum(), Period.NOON);
    treatmentsNight = await getTreatmentsByDayAndPeriod(
        allTreatments, getDayEnum(), Period.NIGHT);
    treatmentsEVENING = await getTreatmentsByDayAndPeriod(
        allTreatments, getDayEnum(), Period.EVENING);

    setState(() {
      medecines = tmp3;
      _isLoading = false;
    });
  }

  Day getDayEnum() {
    switch (daySelected.weekday) {
      case 1:
        return Day.MONDAY;
      case 2:
        return Day.TUESDAY;
      case 3:
        return Day.WEDNESDAY;
      case 4:
        return Day.THURSDAY;
      case 5:
        return Day.FRIDAY;
      case 6:
        return Day.SATURDAY;
      case 7:
        return Day.SUNDAY;
    }
    return Day.MONDAY;
  }

  void updateData() {
    getFollowUp(context).then(
      (value) => {
        setState(() {
          followUp = value;
        })
      },
    );
  }

  void _onStepTapped(int step) {
    setState(() {
      _currentStep = step;
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blue200, width: 2),
      ),
      child: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue700,
                      strokeCap: StrokeCap.round,
                    ),
                  )
                : PageView(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        _currentStep = page;
                      });
                    },
                    children: [
                      PeriodeMedicCheckListe(
                        period: Period.MORNING,
                        treatments: treatmentsMorning,
                        medecines: medecines,
                        followUp: followUp,
                        updateData: updateData,
                        date: DateTime.now(),
                      ),
                      PeriodeMedicCheckListe(
                        period: Period.NOON,
                        treatments: treatmentsAfterNoon,
                        medecines: medecines,
                        followUp: followUp,
                        updateData: updateData,
                        date: daySelected,
                      ),
                      PeriodeMedicCheckListe(
                        period: Period.EVENING,
                        treatments: treatmentsEVENING,
                        medecines: medecines,
                        followUp: followUp,
                        updateData: updateData,
                        date: daySelected,
                      ),
                      PeriodeMedicCheckListe(
                        period: Period.NIGHT,
                        treatments: treatmentsNight,
                        medecines: medecines,
                        followUp: followUp,
                        updateData: updateData,
                        date: daySelected,
                      ),
                    ],
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Flexible(
                child: GestureDetector(
                  onTap: () => _onStepTapped(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _currentStep == index
                          ? AppColors.blue700
                          : AppColors.blue200,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class PeriodeMedicCheckListe extends StatefulWidget {
  final Period period;
  final List<Treatment> treatments;
  final List<dynamic> medecines;
  final List<dynamic> followUp;
  final DateTime date;
  Function updateData;

  PeriodeMedicCheckListe(
      {super.key,
      required this.period,
      required this.treatments,
      required this.medecines,
      required this.followUp,
      required this.updateData,
      required this.date});

  @override
  PeriodeMedicCheckListeState createState() => PeriodeMedicCheckListeState();
}

class PeriodeMedicCheckListeState extends State<PeriodeMedicCheckListe> {
  String getPeriodInFrench(Period period) {
    switch (period) {
      case Period.MORNING:
        return 'Matin';
      case Period.NOON:
        return 'Midi';
      case Period.EVENING:
        return 'Soir';
      case Period.NIGHT:
        return 'Nuit';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtrer les traitements pour la période spécifiée
    List<Treatment> filteredTreatments = widget.treatments
        .where((treatment) => treatment.periods.contains(widget.period))
        .toList();

    String getMedicineName(String medicineId) {
      var med = widget.medecines.firstWhere(
        (med) => med['id'] == medicineId,
        orElse: () => {'name': ''},
      );
      return med['name'];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getPeriodInFrench(widget.period),
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'poppins',
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        if (filteredTreatments.isEmpty)
          const Text(
            "Pas de médicament pour cette période",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        for (int index = 0; index < filteredTreatments.length; index++)
          Row(
            children: [
              Checkbox(
                value: widget.followUp.any((element) =>
                    element['treatment_id'] == filteredTreatments[index].id &&
                    element['period'].contains(
                        widget.period.toString().trim().split('.').last) &&
                    DateTime.fromMillisecondsSinceEpoch(element['date'] * 1000)
                            .day ==
                        widget.date.day),
                onChanged: (value) async {
                  if (DateTime.now().year != widget.date.year ||
                      DateTime.now().day != widget.date.day ||
                      DateTime.now().month != widget.date.month) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      ErrorSnackBar(
                        message:
                            "Vous ne pouvez pas modifier un suivi pour une date passée ou future",
                        context: context,
                      ),
                    );
                    return;
                  }
                  if (value == true) {
                    await postFollowUp({
                      "treatment_id": filteredTreatments[index].id,
                      "date": DateTime.now().millisecondsSinceEpoch ~/ 1000,
                      "period": [
                        widget.period.toString().trim().split('.').last
                      ],
                    }, context).then(
                      (value) => {
                        widget.updateData(),
                      },
                    );
                  } else {
                    await deleteFollowUpRequest(widget.followUp.firstWhere(
                      (element) =>
                          element['treatment_id'] ==
                              filteredTreatments[index].id &&
                          element['period'].contains(
                              widget.period.toString().trim().split('.').last),
                    )['id'], context)
                        .then(
                      (value) => {
                        widget.updateData(),
                      },
                    );
                  }
                },
                activeColor: AppColors.blue700,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(color: AppColors.blue200, width: 2)),
              ),
              // const SizedBox(
              //   width: 8,
              // ),
              Text(
                '${filteredTreatments[index].quantity} x ${getMedicineName(filteredTreatments[index].medicineId)}',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'poppins',
                  decoration: widget.followUp.any((element) =>
                          element['treatment_id'] ==
                              filteredTreatments[index].id &&
                          element['period'].contains(widget.period
                              .toString()
                              .trim()
                              .split('.')
                              .last) &&
                          DateTime.fromMillisecondsSinceEpoch(
                                      element['date'] * 1000)
                                  .day ==
                              widget.date.day)
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
      ],
    );
  }
}
