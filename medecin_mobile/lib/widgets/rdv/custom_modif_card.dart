import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/rdv/custom_modif_hour.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomModifCard extends StatefulWidget {
  CustomModifCard({super.key});

  @override
  _CustomModifCardState createState() => _CustomModifCardState();
}

class _CustomModifCardState extends State<CustomModifCard> {
  bool isOpen = false;
  int selected = -1;



  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: AppColors.blue200, width: 2,),
        color: AppColors.white
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),),
                    Row(children: [ 
                        Text("nbr horaires", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: AppColors.blue700),),
                        Text(" disponibles", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),),
                    ],)
                ],),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isOpen = !isOpen;
                    });
                  },
                  child: !isOpen ? const Icon(BootstrapIcons.chevron_down, size: 16,) : const Icon(BootstrapIcons.chevron_up, size: 16,),
                ),
              ],
            ),
            const SizedBox(height: 8,),
            if(isOpen)Wrap(
              runSpacing: 4,
              spacing: 8,
              children: [
                  for (var i = 0; i < 4; i++)
                    CustomModifHour(selected: selected, id: i),
              ]
            )
        ])
      ),
    );
  }
}