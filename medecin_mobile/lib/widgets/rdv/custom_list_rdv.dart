import 'package:edgar_pro/services/rdv_service.dart';
import 'package:edgar_pro/widgets/rdv/custom_list_rdv_card.dart';
import 'package:flutter/material.dart';

class CustomListRdv extends StatefulWidget {
  const CustomListRdv({super.key});

  @override
  State<CustomListRdv> createState() => _CustomListRdvState();
}

class _CustomListRdvState extends State<CustomListRdv> {
  int pressed = 0;
  List<Map<String, dynamic>> bAppointment = [];

  void deleteAppointmentList(int index) {
    setState(() {
      bAppointment.removeAt(index);
    });
  }

  Future<void> _loadAppointment() async {
    bAppointment = await getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadAppointment(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Expanded(
              child: ListView.separated(
            itemCount: bAppointment.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 4),
            itemBuilder: (context, index) {
              return CustomListRdvCard(
                rdvInfo: bAppointment[index],
                delete: () => {deleteAppointmentList(index)},
                old: false,
              );
            },
          ));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
