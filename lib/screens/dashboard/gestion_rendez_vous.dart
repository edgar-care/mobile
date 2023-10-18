import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:intl/intl.dart';

class GestionRendezVous extends StatefulWidget {
  const GestionRendezVous({Key? key}) : super(key: key);

  @override
  State<GestionRendezVous> createState() => _GestionRendezVousPageState();
}

class _GestionRendezVousPageState extends State<GestionRendezVous> {

    final List<Map<String, String>> rdv = [
    {
      'date': '10/18/2023',
      'heure': '23:59:59',
      'medecin': 'Dr. Dupont',
      'adresse': '123 Rue de la Santé, Paris'
    },
    {
      'date': '10/20/2023',
      'heure': '23:59:59',
      'medecin': 'Dr. Dupont',
      'adresse': '123 Rue de la Santé, Paris'
    },
    {
      'date': '17/09/2023',
      'heure': '23:59:59',
      'medecin': 'Dr. Dupont',
      'adresse': '123 Rue de la Santé, Paris'
    },
  ];

  final currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
        const SwitchThreeElements(),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: rdv.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final filteredRdv = rdv.where((element) => element['date'] != null && element['date']!.isNotEmpty && DateTime.parse(element['date']!).isAfter(DateTime.now())).toList();
              return CardRdv(rdv: filteredRdv[index % filteredRdv.length]);
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
                        month: DateFormat.MMMM().format(currentDate),
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

  const DateCard({Key? key, required this.month, required this.date, required this.isRdv, required this.isToday}) : super(key: key);

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
  const SwitchThreeElements({super.key});

 @override
 // ignore: library_private_types_in_public_api
 _SwitchThreeElementsState createState() => _SwitchThreeElementsState();
}

class _SwitchThreeElementsState extends State<SwitchThreeElements> {
 int _selectedIndex = 0;

 @override
 Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: 
      Container(
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
            for (int i = 0; i < 3; i++)
              InkWell(
                onTap: () {
                setState(() {
                    _selectedIndex = i;
                });
                },
                child: Container(
                width: MediaQuery.of(context).size.width / 3 - 12.0,
                  height: 100.0,
                  alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: _selectedIndex == i ? AppColors.blue700 : Colors.white,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Text(
                    ['A venir', 'Passés', 'Annuler'][i],
                    style: TextStyle(fontSize: 16.0, color: _selectedIndex == i ? Colors.white : AppColors.blue950),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.rdv['date'] == DateFormat.yMd().format(currenDate) ? 'Aujourd\'hui' : widget.rdv['date'] ?? '',
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
                widget.rdv['heure']?.replaceAll(':', 'h').substring(0, 5) ?? '',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Container(
            width: MediaQuery.of(context).size.width - 140,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          icon: const Icon(Icons.more_vert, color: AppColors.grey500, size: 20),
                          onPressed: () {
                            
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
                        const Icon(Icons.location_on, color: AppColors.grey500, size: 20),
                        Text(
                          widget.rdv['adresse'] ?? '',
                          style: const TextStyle(
                            color: AppColors.grey500,
                            fontFamily: 'Poppins',
                            fontSize: 12.0,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            height: null,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios
                          , color: AppColors.grey500, size: 20),
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