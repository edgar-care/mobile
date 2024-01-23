import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/navbar.dart';
import 'package:edgar/widget/plain_button.dart';

class AnnuaireMedecin extends StatelessWidget {
  const AnnuaireMedecin({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> medecins = [
      {
        'nom': 'Dr. Dupont',
        'distance': 14,
        'adresse': '12 Rue des Fleurs',
        'telephone': '01 23 45 67 89',
        'photo': 'url_de_la_photo_du_medecin_1'
      },
      {
        'nom': 'Dr. Dupont',
        'distance': 14,
        'adresse': '12 Rue des Fleurs',
        'telephone': '01 23 45 67 89',
        'photo': 'url_de_la_photo_du_medecin_1'
      },
    ];

    medecins.sort((a, b) => a['distance'].compareTo(b['distance']));

    List<Widget> medecinCards = medecins.map((medecin) {
      return GestureDetector(
        onTap: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(medecin['photo']),
                          radius: 21,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(medecin['nom']),
                          ],
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      indent: 8,
                      endIndent: 8,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 90,
                          width: 90,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors
                                  .grey, // Choisissez la couleur de fond souhaitée
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Téléphone: ${medecin['telephone']}",
                                overflow: TextOverflow.clip,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Adresse: ${medecin['adresse']}",
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Fermer"),
                  ),
                ],
              );
            },
          );
        },
        child: Card(
          color: AppColors.blue700,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  medecin['nom'],
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text("${medecin['distance']} Km",
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Navbar(),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 45,
                  width: 220,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: AppColors.blue700),
                      ),
                      labelText: "Rechercher votre médecin",
                      labelStyle:
                          TextStyle(fontSize: 12, color: AppColors.blue500),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                PlainButton(text: "Rechercher", onPressed: (() {}))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: medecinCards,
                ),
              ),
            )
          ])),
    );
  }
}
