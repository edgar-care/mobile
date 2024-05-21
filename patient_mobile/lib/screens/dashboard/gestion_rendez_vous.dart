import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'package:edgar/services/get_appointement.dart';
import 'package:edgar/services/put_appoitement.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/buttons.dart';

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
    fetchData(context);
  }

  final List<Map<String, String>> rdv = [];

  final currentDate = DateTime.now();

  RdvFilter rdvFilter = RdvFilter.aVenir;
  Future<void> fetchData(BuildContext context) async {
    final Map<String, dynamic>? rdvs = await getAppointement(context);
    if (rdvs != null) {
      final uniqueRdv = <Map<String, String>>{};
      if (rdvs['rdv'] == null) {
        return;
      }
      rdvs['rdv'].forEach((dynamic rdv) {
        final rendezVous = {
          'id': rdv['id'] as String,
          'date': DateFormat('dd/MM/yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(rdv['start_date'] * 1000)),
          'heure': DateFormat('HH:mm:ss').format(
              DateTime.fromMillisecondsSinceEpoch(rdv['start_date'] * 1000)),
          'fin': DateFormat('HH:mm:ss').format(
              DateTime.fromMillisecondsSinceEpoch(rdv['end_date'] * 1000)),
          'medecin': 'Dr. Malade',
          'adresse': '123 Rue de la Santé, Paris',
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
    setState(() {
      fetchData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredRdv = rdv;
    screenWidth = MediaQuery.of(context).size.width.toInt();
    switch (rdvFilter) {
      case RdvFilter.aVenir:
        filteredRdv = rdv.where((element) {
          final rdvDate = DateFormat('dd/MM/yyyy').parse(element['date']!);
          return rdvDate.isAfter(DateTime.now());
        }).toList();
        break;
      case RdvFilter.passes:
        filteredRdv = rdv.where((element) {
          final rdvDate = DateFormat('dd/MM/yyyy').parse(element['date']!);
          return rdvDate.isBefore(DateTime.now());
        }).toList();
        break;
      case RdvFilter.annules:
        filteredRdv = rdv;
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
      child: Expanded(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            WoltModalSheet.show<void>(
                                context: context,
                                pageIndexNotifier: pageIndexRDV,
                                pageListBuilder: (modalSheetContext) {
                                  return [
                                    openRDV(
                                      context,
                                      pageIndexRDV,
                                      widget.updataData,
                                    ),
                                    deleteRDV(
                                      context,
                                      pageIndexRDV,
                                      widget.rdv['id']!,
                                      widget.updataData,
                                    ),
                                  ];
                                });
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
      ),
    );
  }
}

final pageIndexRDV = ValueNotifier(0);

WoltModalSheetPage openRDV(
  BuildContext context,
  ValueNotifier<int> pageIndex,
  Function updataData,
) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          Buttons(
              variant: Variante.primary,
              size: SizeButton.sm,
              msg: const Text('Modifier'),
              onPressed: () async {}),
          Buttons(
              variant: Variante.delete,
              size: SizeButton.sm,
              msg: const Text('Supprimer'),
              onPressed: () {
                pageIndexRDV.value = 1;
              }),
        ],
      ),
    ),
  );
}

WoltModalSheetPage deleteRDV(
  BuildContext context,
  ValueNotifier<int> pageIndex,
  String id,
  Function updataData,
) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.red200,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              BootstrapIcons.x,
              color: AppColors.red700,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Êtes-vous sûr ?',
            style: TextStyle(
              color: AppColors.grey950,
              fontFamily: 'Poppins',
              fontSize: 20,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              height: null,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Si vous supprimez ce document, ni vous ni votre médecin ne pourrez le consulter.',
            style: TextStyle(
              color: AppColors.grey500,
              fontFamily: 'Poppins',
              fontSize: 14,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              height: null,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Buttons(
                  variant: Variante.secondary,
                  size: SizeButton.sm,
                  msg: const Text('Annuler'),
                  onPressed: () {
                    pageIndexRDV.value = 0;
                  },
                  widthBtn: 140),
              Buttons(
                variant: Variante.delete,
                size: SizeButton.sm,
                msg: const Text('Supprimer'),
                onPressed: () async {
                  putAppointement(context, id);
                  updataData(context);
                  pageIndexRDV.value = 0;
                },
                widthBtn: 140,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
