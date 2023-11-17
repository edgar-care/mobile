import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:medecin_mobile/styles/colors.dart';
import 'package:medecin_mobile/widgets/custom_dashboard_card.dart';

class CustomAppBar extends StatefulWidget {
  final Function(int) callback;
  final Function() getSelected;
  const CustomAppBar({Key? key, required this.callback, required this.getSelected}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomAppBarState createState() => _CustomAppBarState();
}


class _CustomAppBarState extends State<CustomAppBar> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blue200, width: 2)
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children : [
                GestureDetector(
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.blue950,
                    ),
                    child: !isOpen ? const Icon(BootstrapIcons.chevron_down, size: 14, color: Colors.white,) : const Icon(BootstrapIcons.chevron_up, size: 14, color: Colors.white,),
                  ),
                  onTap: () {
                    setState(() {
                      isOpen = !isOpen;
                    });
                  },
                ),
                const SizedBox(width: 8,),
                Image.asset(
                  'assets/images/logo/full-width-color.png',
                  height: 40,
                ),
                const Spacer(),
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.green700,
                  ),
                ),

              ]
            ),
          if(isOpen) Column(
              children: [
                const SizedBox(height: 8,),
                Container(height: 2,color: AppColors.blue200,),
                const SizedBox(height: 8,),
                CustomCard(isSelected: widget.getSelected() == 0 ? true : false, icon: BootstrapIcons.calendar_week_fill, title: "Agenda", onTap: () {widget.callback(0);},),
                const SizedBox(height: 2,),
                CustomCard(isSelected: widget.getSelected() == 1 ? true : false, icon: BootstrapIcons.person_vcard_fill, title: "Patientèle", onTap: () {widget.callback(1);}),
                const SizedBox(height: 8,),
                Container(height: 2,color: AppColors.blue200,),
                const SizedBox(height: 8,),
                CustomCard(isSelected: widget.getSelected() == 2 ? true : false, icon: BootstrapIcons.question_circle_fill, title: "Aide", onTap: () {widget.callback(2);}),
                const SizedBox(height: 2,),
                CustomCard(isSelected: widget.getSelected() == 3 ? true : false, icon: BootstrapIcons.arrow_right_circle_fill, title: "Déconnexion", onTap: () {widget.callback(3);}),
              ],
            ),
          ],
        )
    ),
        ),
      ]);
  }
}