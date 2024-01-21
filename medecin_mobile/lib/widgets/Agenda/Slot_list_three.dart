// ignore_for_file: file_names

import 'package:edgar_pro/services/slot_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/Agenda/slot.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SlotListThree extends StatefulWidget {
  DateTime date;
  SlotListThree({super.key, required this.date});

  @override
  // ignore: library_private_types_in_public_api
  _SlotListThreeState createState() => _SlotListThreeState();
}

class _SlotListThreeState extends State<SlotListThree> {
  String patientName = "";
List<dynamic> slots = [];

  @override
initState() {
  super.initState();
  _loadSlots();
}

  Future<void> _loadSlots() async {
    var tempslots = await getSlot();
    setState(() {
      slots = tempslots;
    });
  }

  Future<void> _refreshSlots() async {
    var tempslots = await getSlot();
    setState(() {
      slots = tempslots;
    });
  }
   @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.74,
      child:  RefreshIndicator(
        color: AppColors.blue200,
        onRefresh: _refreshSlots,
        child: ListView.builder(
        itemCount: 24,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children : [
              Container(height: 1,color: AppColors.blue200,),
              const SizedBox(height: 4,),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.end,
              children : [
                Text(index.toString().length == 1 ? "0$index:00" : "$index:00", style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w600),),
                const SizedBox(width: 8,),
                Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.end,
                  clipBehavior: Clip.values[1],
                  spacing: 2,
                  children: [
                    checktypeslot(slots, widget.date.add(Duration(hours: index))),
                    checktypeslot(slots, widget.date.add(Duration(hours: index, minutes: 30))),
                ]),
                const SizedBox(width: 8,),
                Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.end,
                  clipBehavior: Clip.values[1],
                  spacing: 2,
                  children: [
                    checktypeslot(slots, widget.date.add(Duration(days: 1, hours: index))),
                    checktypeslot(slots, widget.date.add(Duration(days: 1,hours: index, minutes: 30))),
                ]),
                const SizedBox(width: 8,),
                Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.end,
                  clipBehavior: Clip.values[1],
                  spacing: 2,
                  children: [
                    checktypeslot(slots, widget.date.add(Duration(days: 2, hours: index))),
                    checktypeslot(slots, widget.date.add(Duration(days: 2, hours: index, minutes: 30))),
                ]),
            ],),
            const SizedBox(height: 4,),
        ])
        ;}
      ),
      ),
      );
  }
  Widget checktypeslot (List<dynamic> slots, DateTime date) {
    for (var i = 0; i < slots.length; i++) {
      if (slots[i]['start_date'] * 1000 == date.millisecondsSinceEpoch && slots[i]['id_patient'] != "") {
        return  Slot(type: SlotType.taken, three: true,);
      }
      if (slots[i]['start_date'] * 1000 == date.millisecondsSinceEpoch){
        return  Slot(type: SlotType.create, date: date, id: slots[i]['id'], three: true,);
      }
    }
    return Slot(type: SlotType.empty, date: date, id: '1', three: true,);
    }
}