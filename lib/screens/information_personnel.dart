import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:prototype_1/widget/bottom_navbar.dart';
import 'package:prototype_1/widget/plain_button.dart';
import 'package:http/http.dart' as http;

class InformationPersonnel extends StatefulWidget {
  const InformationPersonnel({Key? key}) : super(key: key);

  @override
  State<InformationPersonnel> createState() => _InformationPersonnelState();
}

class _InformationPersonnelState extends State<InformationPersonnel> with SingleTickerProviderStateMixin {
  List<bool> isSelected = [true, false];



  Future<void> fetchData(BuildContext context) async {
    const url =
        'https://dvpm9zw6vc.execute-api.eu-west-3.amazonaws.com/patient';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occurred while fetching data'),
        ),
      );
    }
  }

  Map<String, Object> infoMedical= {
    'nom': 'Michel',
    'sexe': 'male',
    'Age': '22 ans',
    'taille': '182 cm',
    'poids': '63 kg',
    'medecin_traitant': 'Dr.Robert',
    'traitement_en_cours': 'Aucun',
    'allergies': 'Aucun',
    'Maladies': 'Aucune'
  };

    
    @override
    Widget cardInformation(BuildContext context) {
      return isSelected[1] 
        ? Card(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: AppColors.blue700, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                ...infoMedical.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Row(
                      children: <Widget>[
                        Text(
                          entry.key,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Text(
                          ':',
                          style: TextStyle(color: Colors.white),
                        ),
                        const Spacer(),
                        Text(
                          '${entry.value}',
                          style: const TextStyle(color: AppColors.green400),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
                GreenPlainButton(
                  text: 'Modifier',
                  onPressed: () {},
                ),
                const SizedBox(height: 20),
              ],
            ),
          )
        : Container();
    }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(
        index: 3,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50),
              width: 120,
              child: Image.asset('assets/images/logo/full-width-colored-edgar-logo.png'),
            ),
            const SizedBox(height: 20),
            ToggleButtons(
              constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width * 0.40),
              borderRadius: BorderRadius.circular(50),
              borderWidth: 1,
              borderColor: AppColors.blue700,
              color: AppColors.blue700,
              selectedColor: AppColors.blue700,
              hoverColor: AppColors.blue700,

              fillColor: AppColors.blue700,
              onPressed: (int index) async {
                fetchData(context);
                setState(() {
                  for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: isSelected,
              children: <Widget>[
                Text(
                  'Information\nPersonnel', 
                  style: TextStyle(color: isSelected[0] ? Colors.white : AppColors.blue900, 
                  ),
                ),
                Text(
                  'Information\nMedical', 
                  style: TextStyle(color: isSelected[1] ? Colors.white : AppColors.blue900)
                ),
              ],
            ),
            const SizedBox(height: 20),
            cardInformation(context),
          ]
          ),
      )
    );
  }
}