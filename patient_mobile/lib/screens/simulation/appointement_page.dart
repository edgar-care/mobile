import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/card_doctor_appoitement.dart';
import 'package:flutter/material.dart';
import 'package:edgar/widget/field_custom.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter_svg/svg.dart';

class AppointementPage extends StatefulWidget {
  const AppointementPage({super.key});

  @override
  State<AppointementPage> createState() => _AppointementPageState();
}

class _AppointementPageState extends State<AppointementPage> {
  List<Map<String, dynamic>> appointements = [
    {
      "doctor": "Dr. Jean Dupont",
      "address": "12 rue de la paix, 75000 Paris",
      "date": [
        {
          "day": "12/12/2023",
          "hour": [
            "10:00",
            "10:30",
            "12:00",
          ]
        },
        {
          "day": "12/12/2023",
          "hour": ["10:00", "10:30", "12:00"]
        },
        {
          "day": "12/12/2023",
          "hour": ["10:00", "10:30", "12:00"]
        },
        {
          "day": "12/12/2023",
          "hour": ["10:00", "10:30", "12:00"]
        },
        {
          "day": "12/12/2023",
          "hour": ["10:00", "10:30", "12:00"]
        },
        {
          "day": "12/12/2023",
          "hour": ["10:00", "10:30", "12:00"]
        }
      ],
    },
    {
      "doctor": "Dr. Jean Dupont",
      "address": "12 rue de la paix, 75000 Paris",
      "date": [
        {
          "day": "12/12/2023",
          "hour": ["10:00", "10:30", "12:00"]
        },
        {
          "day": "12/12/2023",
          "hour": ["10:00", "10:30", "12:00"]
        },
        {
          "day": "12/12/2023",
          "hour": ["10:00", "10:30", "12:00"]
        },
      ],
    },
    {
      "doctor": "Dr. Jean Dupont",
      "address": "12 rue de la paix, 75000 Paris",
      "date": [
        {
          "day": "12/12/2023",
          "hour": ["10:00", "10:30", "12:00"]
        },
        {
          "day": "12/12/2023",
          "hour": ["10:00", "10:30", "12:00"]
        },
        {
          "day": "12/12/2023",
          "hour": ["10:00", "10:30", "12:00"]
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 48,
          child: Column(
            children: [
              const Text(
                "Vous pouvez maintenant sélectionner un rendez-vous chez un médecin.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: AppColors.black,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomFieldSearch(
                label: "Rechercher par le nom du médecin",
                icon: SvgPicture.asset("assets/images/utils/search.svg"),
                keyboardType: TextInputType.text,
                onValidate: (value) {},
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: appointements.length,
                  itemBuilder: (context, index) {
                    return CardAppointementDoxtorHour(
                      appointements: appointements[index],
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/simulation/confirmation');
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
    );
  }
}
