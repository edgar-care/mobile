import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:prototype_1/widget/navbar.dart';
import 'package:prototype_1/widget/plain_button.dart';

class AnnuaireMedecin extends StatelessWidget {
  const AnnuaireMedecin({Key? key}) : super(key: key);

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
    ];

    medecins.sort((a, b) => a['distance'].compareTo(b['distance']));

    List<Widget> medecinCards = medecins.map((medecin) {
      return GestureDetector(
        onTap: () async {
          double latitude = 48.8534;
          double longitude = 2.3488;
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(latitude, longitude),
                              zoom: 14,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('medecin'),
                                position: LatLng(latitude, longitude),
                              ),
                            },
                            myLocationEnabled: false,
                            zoomControlsEnabled: false,
                            scrollGesturesEnabled: false,
                            tiltGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            myLocationButtonEnabled: false,
                            mapToolbarEnabled: false,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Téléphone: ${medecin['telephone']}"),
                            Text("Adresse: ${medecin['adresse']}"),
                          ],
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
                child: ListView(
              children: medecinCards,
            ))
          ])),
    );
  }
}
