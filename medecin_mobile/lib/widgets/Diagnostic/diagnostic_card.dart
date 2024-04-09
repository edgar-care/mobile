import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// ignore: must_be_immutable
class DiagnosticCard extends StatelessWidget {
  Map<String, dynamic> rdvInfo;
  DiagnosticCard({super.key, required this.rdvInfo});

Map<String, dynamic> patientInfo = {};

Future<void> _loadAppointment() async {
    patientInfo = await getPatientById(rdvInfo['id_patient']);
}

  @override
  Widget build(BuildContext context) {
    DateTime start = DateTime.fromMillisecondsSinceEpoch(rdvInfo['start_date'] * 1000);
    DateTime end =  DateTime.fromMillisecondsSinceEpoch(rdvInfo['end_date'] * 1000);
    return FutureBuilder(
      future: _loadAppointment(),
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return  Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.blue200, width: 2.0),
        ),
        child: InkWell(
          onTap: () {
            WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [
                  ];
                },);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${patientInfo["Nom"]} ${patientInfo["Prenom"]}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8,),
                Row(
                  children: [
                    Text(DateFormat('yMd', 'fr').format(start), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                    const SizedBox(width: 4,),
                    const Text("-", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                    const SizedBox(width: 4,),
                    Row(children: [
                      Text(DateFormat('jm', 'fr').format(start), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                      const SizedBox(width: 2,),
                      const Icon(BootstrapIcons.arrow_right, size: 16,),
                      const SizedBox(width: 2,),
                      Text(DateFormat('jm', 'fr').format(end), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                    ]),
                  ]
                )
            ])
          )
        )
      );
      } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
  }
}