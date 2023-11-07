
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:prototype_1/widget/plain_button.dart';
import 'package:prototype_1/services/get_information_patient.dart';


class InformationPersonnel extends StatefulWidget {
  const InformationPersonnel({super.key});

  @override
  State<InformationPersonnel> createState() => _InformationPersonnelState();
}

class _InformationPersonnelState extends State<InformationPersonnel> with SingleTickerProviderStateMixin {
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    fetchData(context);
  }
  Map<String, Object>? infoMedical = {};

  Future<void> fetchData(BuildContext context) async {
    infoMedical = await getInformationPersonnel(context);
  }

    
  Widget cardInformation(BuildContext context) {
    return isSelected[1] ? Card(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        color: AppColors.blue700, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            ...infoMedical!.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Row(
                  children: <Widget>[
                    Text(
                      entry.key.replaceAll('_', ' '),
                      style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                    const Text(
                      ' :',
                      style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                    const Spacer(),
                    Text(
                      '${entry.value}',
                      style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              );
            // ignore: unnecessary_to_list_in_spreads
            }).toList(),
            const SizedBox(height: 20),
            GreenPlainButtonWithIcon(
              text: 'Modifier',
              icon: BootstrapIcons.pencil,
              onPressed: () {
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      )
    : Container();
  }

  @override
   Widget build(BuildContext context) {
    return Column(
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
          onPressed: (int index) {
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
              'Information\nPersonnelle', 
              style: TextStyle(color: isSelected[0] ? Colors.white : AppColors.blue900, fontFamily: 'Poppins'
              ),
            ),
            Text(
              'Information\nMedicale', 
              style: TextStyle(color: isSelected[1] ? Colors.white : AppColors.blue900, fontFamily: 'Poppins')
            ),
          ],
        ),
        const SizedBox(height: 20),
        cardInformation(context),
      ]
      );
  }
}