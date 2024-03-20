
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/rdv_service.dart';
import 'package:edgar_pro/services/slot_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/rdv/custom_modif_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  var temp = await getSlot();
    for (var i = 0; i < temp.length; i++) {
      if (temp[i]['start_date'] > widget.rdvInfo['start_date'] && temp[i]["id_patient"] == "") {
        bool added = false;
        for(var j = 0; j < freeslots.length; j++) {
          if (DateUtils.isSameDay(DateTime.fromMillisecondsSinceEpoch(freeslots[j][0]['start_date'] * 1000), DateTime.fromMillisecondsSinceEpoch(temp[i]['start_date'] * 1000))) {
            setState(() {
            freeslots[j].add(temp[i]);
            added = true;
            });
          }
        }
        if (!added) {
          setState(() {
            freeslots.add([temp[i]]);
          });}
      }
    }
  }

  Map<String,int> selected = {"first" : 400, "second" : 400};

  void updateSelection(int first, int second) {
    setState(() {
      selected["first"] = first;
      selected["second"] = second;
    });
  }

  @override
  Widget build(BuildContext context) {
  DateTime start = DateTime.fromMillisecondsSinceEpoch(widget.rdvInfo['start_date'] * 1000);
    return Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 400,
          ),
          child: 
              Column(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: AppColors.grey200,
                    ),
                    child : const Icon(BootstrapIcons.calendar2_week_fill, size: 16, color: AppColors.grey700,)),
                  const SizedBox(height: 8,),
                  const Text("Modification du rendez-vous", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),),
                  Text(DateFormat('yMMMMEEEEd', 'fr').format(start), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: AppColors.green500),),
                  const SizedBox(height: 16,),
                  Expanded(
                    child : ListView.builder(
                      itemCount: freeslots.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          CustomModifCard(dateList: freeslots[index], updateFunc: updateSelection, selected: selected, number: index,),
                          const SizedBox(height: 8,)
                          ]);
                  })),
                  const SizedBox(height: 16,),
                  Buttons(
                    variant: Variante.primary,
                    size: SizeButton.sm,
                    msg: const Text("Valider le changement"),
                    onPressed: () {
                      updateAppointment(widget.rdvInfo['id'], freeslots[selected["first"]!][selected["second"]!]['id'], context);
                      widget.updateFunc(DateTime.fromMillisecondsSinceEpoch(freeslots[selected["first"]!][selected["second"]!]['start_date']* 1000));
                      Navigator.pop(context);
                    }),
                ],)
        ),
      );
  }
}