import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:intl/intl.dart';

class GestionRendezVous extends StatefulWidget {
  const GestionRendezVous({Key? key}) : super(key: key);

  @override
  State<GestionRendezVous> createState() => _GestionRendezVousPageState();
}

class _GestionRendezVousPageState extends State<GestionRendezVous> {
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
        DateSlider(),
      ],
    );
  }
}

class DateSlider extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  DateSlider({Key? key});

  final List<Map<String, String>> rdv = [
    {
      'date': '10/9/2023',
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
      'date': '17/9/2023',
      'heure': '23:59:59',
      'medecin': 'Dr. Dupont',
      'adresse': '123 Rue de la Santé, Paris'
    },
  ];

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