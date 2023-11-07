import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:prototype_1/services/get_appointement.dart';

enum RdvFilter {
  aVenir,
  passes,
  annules,
}

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
        final uniqueRdv = <Map<String, String>>{}; // Utiliser un Set pour stocker les rendez-vous uniques
        rdvs['rdv'].forEach((dynamic rdv) {
          final rendezVous = {
            'date': DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(rdv['start_date'] * 1000)),
            'heure': DateFormat('HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(rdv['start_date'] * 1000)),
            'fin': DateFormat('HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(rdv['end_date'] * 1000)),
            'medecin': 'Dr. ${rdv['doctor_id'] as String}',
            'adresse': '123 Rue de la Santé, Paris',
          };
          uniqueRdv.add(rendezVous); // Ajouter le rendez-vous au Set
        });
        rdv.addAll(uniqueRdv.toList()); // Convertir le Set en une liste et l'ajouter à rdv
      } else {
        throw Exception('Failed to fetch data');
      }
  }

  @override
  Widget build(BuildContext context) {

  List<Map<String, String>> filteredRdv = rdv;

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
   

  rdv.sort((a, b) => DateFormat('dd/MM/yyyy').parse(a['date']!).compareTo(DateFormat('dd/MM/yyyy').parse(b['date']!)));

  if (rdv.any((element) => element['date'] == DateFormat.yMd().format(currentDate))) {
    rdv.sort((a, b) => DateFormat('HH:mm:ss').parse(a['heure']!).compareTo(DateFormat('HH:mm:ss').parse(b['heure']!)));
  }
  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.only(top: 50),
            width: 120,
            child: Image.asset('assets/images/logo/full-width-colored-edgar-logo.png'),
          ),
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
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: filteredRdv.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final appointment = filteredRdv[index];
              return CardRdv(rdv: appointment);
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
                final isRdv = rdv.any((element) => element['date'] == DateFormat.yMd().format(currentDate));
                return Row(
                  children: [
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 70, // Largeur fixe pour chaque carte
                      height: 90,
                      child: DateCard(
                        month: DateFormat.MMMM().format(currentDate).substring(0, 3),
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

  const DateCard({super.key, required this.month, required this.date, required this.isRdv, required this.isToday});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: 70,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFB0B4C9), width: 1),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (RdvFilter filter in RdvFilter.values)
              InkWell(
                onTap: () {
                  setState(() {
                    selectedFilter = filter;
                  });
                  widget.onValueChanged(selectedFilter);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 3 - 12.0,
                  height: 100.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedFilter == filter ? AppColors.blue700 : Colors.white,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Text(
                    filterToString(filter),
                    style: TextStyle(fontSize: 16.0, color: selectedFilter == filter ? Colors.white : AppColors.blue950),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
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
}


class CardRdv extends StatefulWidget {
  final Map<String, String> rdv;

  const CardRdv({super.key, required this.rdv});

  @override
  // ignore: library_private_types_in_public_api
  _CardRdvState createState() => _CardRdvState();
}

class _CardRdvState extends State<CardRdv> {
  
  @override
  Widget build(BuildContext context) {
    var currenDate = DateTime.now();

    GlobalKey key = GlobalKey(); 
    bool isVisible = false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Stack(
            children: [
              Visibility(
            visible: isVisible,
            child: Positioned(
              left: key.currentContext?.size?.width ?? 0,
              right: key.currentContext?.size?.height ?? 0,
              child: Container(
                width: 200,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                  borderRadius: null,
                ),
                child: const Text('Test'),
              ),
            ),
          ),
            ],
          ),
          SizedBox(
            width: 100   ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.rdv['date'] ==  DateFormat('dd/MM/yyyy').format(currenDate) ? 'Aujourd\'hui' :
                  widget.rdv['date'] ==  DateFormat('dd/MM/yyyy').format(currenDate.add(const Duration(days: 1))) ? 'Demain' :
                  widget.rdv['date']!,
                  style: const TextStyle(
                    color: AppColors.green500,
                    fontFamily: 'Poppins', 
                    fontSize: 16.0,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    height: null,
                  ),
                ),
                Text(
                  widget.rdv['heure']?.replaceAll(':', 'H').substring(0, 5).trim().replaceFirst("H", " H ") ?? '',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.rdv['heure'] != null && widget.rdv['fin'] != null ?
                  '${DateTime.parse('2022-01-01 ${widget.rdv['fin']!}').difference(DateTime.parse('2022-01-01 ${widget.rdv['heure']!}')).inMinutes} min' :
                  '',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.0,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey500,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: MediaQuery.of(context).size.width - 150,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.rdv['medecin'] ?? '',
                          style: const TextStyle(
                            color: AppColors.grey950,
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            height: null,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                          key: key,
                          icon: const Icon(BootstrapIcons.three_dots_vertical, color: AppColors.grey500, size: 20),
                          onPressed: () {
                            // Code to make the invisible container appear
                            setState(() {
                              isVisible = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      height: 1,
                      width: double.infinity - 32,
                      child: Container(
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(BootstrapIcons.geo, color: AppColors.grey600, size: 12 ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 236,
                          child: AutoSizeText(
                            widget.rdv['adresse'] ?? '',
                            maxLines: 2,
                            minFontSize: 12,
                            maxFontSize: 16,
                            style: const TextStyle(
                              color: AppColors.grey500,
                              fontFamily: 'Poppins',
                              fontSize: 12.0,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              height: null,
                            ),
                            textAlign: TextAlign.start
                          ),
                        ),
                        IconButton(
                          icon: const Icon(BootstrapIcons.chevron_right
                          , color: AppColors.grey600, size: 20),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}