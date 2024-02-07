import 'package:edgar_pro/services/rdv_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';


class CustomListRdv extends StatefulWidget {
  const CustomListRdv({super.key});

  @override
  State<CustomListRdv> createState() => _CustomListRdvState();
}

class _CustomListRdvState extends State<CustomListRdv> {
  int pressed = 0;
  List<dynamic> bAppointment = [];
  @override
    initState() {
    super.initState();
    _loadAppointment();
  }

  Future<void> _loadAppointment() async {
    var tempAp = await getAppointments();
    for (var i = 0; i < tempAp.length; i++) {
      if (tempAp[i]['id_patient'] == '') {
        tempAp.removeAt(i);
      }
    }
    bAppointment = tempAp;
    Logger().d(bAppointment);
  }

  @override
  Widget build(BuildContext context) {
    // refaire le return pour avoir des cards
    return Expanded(
        child: ListView.builder(itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: pressed == index ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: const Text('date'),
                subtitle: const Text('heure'),
                onTap: () {
                  setState(() {
                    pressed = index;
                  });
                },
              ),
            ),
          );
        },
    ));
  }

}
