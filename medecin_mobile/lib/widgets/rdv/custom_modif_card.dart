import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/rdv/custom_modif_hour.dart';
import 'package:flutter/material.dart';

class CustomModifCard extends StatefulWidget {
  const CustomModifCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomModifCardState createState() => _CustomModifCardState();
}

class _CustomModifCardState extends State<CustomModifCard> {
  bool isOpen = false;
  ValueNotifier<int> selected = ValueNotifier(-1);

void updateSelection(int newSelection) {
    selected.value = newSelection;
  }

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
                !isOpen ? const Icon(BootstrapIcons.chevron_down, size: 16,) : const Icon(BootstrapIcons.chevron_up, size: 16,),
              ],
            ),
            if(isOpen)ValueListenableBuilder(
              valueListenable: selected,
              builder: (context, value, child) {
                return Column( children:[
                  const SizedBox(height: 8,),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for(int i = 0; i < 4; i++)
                          CustomModifHour(selected: selected.value == i ? true : false, id: i, onTap: () => updateSelection(i)),
                    ])]
                );
              }
            )
        ])
      ),
    ));
  }
}