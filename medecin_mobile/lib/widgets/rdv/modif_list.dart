import 'package:edgar_pro/services/rdv_service.dart';
import 'package:edgar_pro/services/slot_service.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_pro/widgets/rdv/custom_modif_card.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ModifList extends StatefulWidget {
  final Map<String, dynamic> rdvInfo;
  final Function updateFunc;
  const ModifList({super.key, required this.rdvInfo, required this.updateFunc});
  @override
  // ignore: library_private_types_in_public_api
  _ModifListState createState() => _ModifListState();
}

class _ModifListState extends State<ModifList> {
  List<List<Map<String, dynamic>>> freeslots = [];

  @override
  initState() {
    super.initState();
    _loadAppointment();
  }

  Future<void> _loadAppointment() async {
    var temp = await getSlot(context);
    for (var i = 0; i < temp.length; i++) {
      if ((temp[i]['start_date'] * 1000) >
              (DateTime.now().millisecondsSinceEpoch) &&
          temp[i]["id_patient"] == "") {
        bool added = false;
        for (var j = 0; j < freeslots.length; j++) {
          if (DateUtils.isSameDay(
              DateTime.fromMillisecondsSinceEpoch(
                  freeslots[j][0]['start_date'] * 1000),
              DateTime.fromMillisecondsSinceEpoch(
                  temp[i]['start_date'] * 1000))) {
            setState(() {
              freeslots[j].add(temp[i]);
              added = true;
            });
          }
        }
        if (!added) {
          setState(() {
            freeslots.add([temp[i]]);
          });
        }
      }
    }
    freeslots.sort((a, b) => a[0]['start_date'].compareTo(b[0]['start_date']));
  }

  Map<String, int> selected = {"first": 400, "second": 400};

  void updateSelection(int first, int second) {
    setState(() {
      selected["first"] = first;
      selected["second"] = second;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < freeslots.length; i++) ...[
          CustomModifCard(
            dateList: freeslots[i],
            updateFunc: updateSelection,
            selected: selected,
            number: i,
          ),
          const SizedBox(
            height: 8,
          ),
        ],
        const SizedBox(
          height: 16,
        ),
        Buttons(
          variant: Variant.primary,
          size: SizeButton.md,
          msg: const Text("Valider le changement"),
          onPressed: () {
            updateAppointment(
                    widget.rdvInfo['id'],
                    freeslots[selected["first"]!][selected["second"]!]['id'],
                    context)
                .then((value) => {
                      widget.updateFunc(DateTime.fromMillisecondsSinceEpoch(
                          freeslots[selected["first"]!][selected["second"]!]
                                  ['start_date'] *
                              1000))
                    });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
