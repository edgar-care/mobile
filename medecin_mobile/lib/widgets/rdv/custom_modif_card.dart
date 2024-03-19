import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/rdv/custom_modif_hour.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomModifCard extends StatefulWidget {
  final List<Map<String, dynamic>> dateList;
  final Function updateFunc;
  final Map<String,int> selected;
  final int number;
  const CustomModifCard({super.key, required this.dateList, required this.updateFunc, required this.selected, required this.number});

  @override
  // ignore: library_private_types_in_public_api
  _CustomModifCardState createState() => _CustomModifCardState();
}

class _CustomModifCardState extends State<CustomModifCard> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: AppColors.blue200, width: 2,),
        color: AppColors.white
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            isOpen = !isOpen;
          });
        },
        child:
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat('yMMMMEEEEd', 'fr').format(DateTime.fromMillisecondsSinceEpoch(widget.dateList[0]['start_date'] * 1000)), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),),
                    const Row(children: [
                        Text("nbr horaires", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: AppColors.blue700),),
                        Text(" disponibles", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),),
                    ],)
                ],),
                const Spacer(),
                !isOpen ? const Icon(BootstrapIcons.chevron_down, size: 16,) : const Icon(BootstrapIcons.chevron_up, size: 16,),
              ],
            ),
            if(isOpen)
              Column( children:[
                  const SizedBox(height: 8,),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for(int i = 0; i < widget.dateList.length; i++)
                          CustomModifHour(selected: widget.selected["first"] == widget.number && widget.selected["second"] == i ? true : false, id: i, onTap: () => widget.updateFunc(widget.number, i), info: widget.dateList[i]),
                    ])]
            )
        ])
      ),
    ));
  }
}