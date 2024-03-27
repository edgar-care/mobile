import 'package:edgar_pro/services/rdv_service.dart';
import 'package:edgar_pro/widgets/rdv/custom_list_rdv_card.dart';
import 'package:edgar_pro/widgets/rdv_patient/custom_card_rdv_patient.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';


class CustomListPatient extends StatefulWidget {
  const CustomListPatient({super.key});

  @override
  State<CustomListPatient> createState() => _CustomListRdvPatientState();
}

class _CustomListRdvPatientState extends State<CustomListPatient> {
  int pressed = 0;
  List<Map<String, dynamic>> bAppointment = [{
			"id": "66007e81f7fcbc4bca6f8df6",
			"doctor_id": "65fa0ecad0a7067ac5593d29",
			"id_patient": "65fa06393c449dfabded7f25",
			"start_date": 1711940400,
			"end_date": 1711942200,
			"cancelation_reason": "",
			"appointment_status": "WAITING_FOR_REVIEW",
			"session_id": "test"
		}];
  @override
    initState() {
    super.initState();
    _loadAppointment();
  }

  void deleteAppointmentList(int index) {
    setState(() {
      bAppointment.removeAt(index);
    });
  }

  Future<void> _loadAppointment() async {
    var tempAp = await getAppointments();
    for (var i = 0; i < tempAp.length; i++) {
      if (tempAp[i]['id_patient'].toString().isNotEmpty && tempAp[i]['cancelation_reason'] == "" && tempAp[i]['start_date'] <= DateTime.now().millisecondsSinceEpoch ~/ 1000) {
        setState(() {
          bAppointment.add(tempAp[i]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.separated(
          itemCount: bAppointment.length,
          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
          return CustomCardRdvPatient(old: false, rdvInfo: bAppointment[index], delete: () => {deleteAppointmentList(index)},);
        },
    ));
  }
}