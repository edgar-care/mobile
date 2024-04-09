import 'package:edgar_pro/services/rdv_service.dart';
import 'package:edgar_pro/widgets/Diagnostic/diagnostic_card.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DiagnosticList extends StatefulWidget {
  int type;
  DiagnosticList({super.key, required this.type});

  @override
  State<DiagnosticList> createState() => _DiagnosticListState();
}

class _DiagnosticListState extends State<DiagnosticList> {
  List<Map<String, dynamic>> bAppointment = [];
  String status = "";

  // ignore: non_constant_identifier_names
  Switch(type) {
    switch (type) {
      case 0:
        status = "WAITING_FOR_REVIEW";
        break;
      case 1:
        status = "ACCEPTED_DUE_TO_REVIEW";
        break;
      case 2:
        status = "CANCELED_DUE_TO_REVIEW";
        break;
    }
  }
  @override
    initState() {
    super.initState();
    _loadAppointment();
  }

  Future<void> _loadAppointment() async {
    var tempAp = await getAppointments();
    for (var i = 0; i < tempAp.length; i++) {
      if (tempAp[i]['id_patient'].toString().isNotEmpty && tempAp[i]['appointment_status'] == ""){
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
          return DiagnosticCard(rdvInfo: bAppointment[index]); // envoyer le 'type' pour trier ce qu'on la modal en fonction de la list
        },
      )
    );
  }
}