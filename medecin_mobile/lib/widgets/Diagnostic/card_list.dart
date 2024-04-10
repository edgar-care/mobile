import 'package:edgar_pro/services/rdv_service.dart';
import 'package:edgar_pro/widgets/Diagnostic/diagnostic_card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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

  @override
  Widget build(BuildContext context) {
  Future<void> loadAppointment() async {
    switch (widget.type) {
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
    Logger().d(status);
    bAppointment = await getDiagnostics(status);
    Logger().d(bAppointment);
  }
    return FutureBuilder(
      future: loadAppointment(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Expanded(
            child: ListView.separated(
              itemCount: bAppointment.length,
              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                return DiagnosticCard(rdvInfo: bAppointment[index], type: widget.type);
              },
            )
          );
        }
      }
    );
  }
}