import 'package:edgar_pro/services/rdv_service.dart';
import 'package:edgar_pro/widgets/rdv/custom_list_rdv_card.dart';
import 'package:edgar_pro/widgets/rdv_patient/custom_card_rdv_patient.dart';
import 'package:flutter/material.dart';


class CustomListOldPatient extends StatefulWidget {
  const CustomListOldPatient({super.key});

  @override
  State<CustomListOldPatient> createState() => _CustomListRdvPatientState();
}

class _CustomListRdvPatientState extends State<CustomListOldPatient> {
  int pressed = 0;
  List<Map<String, dynamic>> bAppointment = [];
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
          return CustomCardRdvPatient(old: true, rdvInfo: bAppointment[index], delete: () => {deleteAppointmentList(index)},);
        },
    ));
  }
}