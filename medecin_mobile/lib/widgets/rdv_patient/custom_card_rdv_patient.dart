import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/rdv_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_nav_patient_card.dart';
import 'package:edgar_pro/widgets/field_custom.dart';
import 'package:edgar_pro/widgets/rdv/modif_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// ignore: must_be_immutable
class CustomCardRdvPatient extends StatefulWidget {
  final Map<String, dynamic> rdvInfo;
  bool old = false;
  final Function delete;
  CustomCardRdvPatient({super.key, required this.rdvInfo, required this.old, required this.delete});

  @override
  State<CustomCardRdvPatient> createState() => _CustomCardRdvPatientState();
}

class _CustomCardRdvPatientState extends State<CustomCardRdvPatient> {

  void updateAppointment(DateTime start) {
    setState(() {
      widget.rdvInfo['start_date'] = (start.millisecondsSinceEpoch ~/ 1000);
      widget.rdvInfo['end_date'] = (start.add(const Duration(minutes: 30)).millisecondsSinceEpoch ~/ 1000);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(widget.rdvInfo['start_date'] * 1000);
    String dateString = DateFormat('yMMMd', 'fr').format(date).toString();
    String timeStringStart = DateFormat('HH:mm', 'fr').format(date).toString();
    String timeStringEnd = DateFormat('HH:mm', 'fr').format(date.add(const Duration(minutes: 30))).toString();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.blue200,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          WoltModalSheet.show(
                context: context,
                pageListBuilder: (BuildContext context) {
                  return [
                    modalRdv(context),
                  ];
                },
              );
        },
        child : Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                height: 25,
                width: 4,
                decoration: BoxDecoration(
                  color: widget.old ? AppColors.blue200 : AppColors.green500,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(width: 8,),
              Text(
                '$dateString de $timeStringStart à $timeStringEnd',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins'
                ),
              ),
              const Spacer(),
              const Icon(BootstrapIcons.chevron_right, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  SliverWoltModalSheetPage modalRdv(BuildContext context,){
    DateTime date = DateTime.fromMillisecondsSinceEpoch(widget.rdvInfo['start_date'] * 1000);
    String dateString = DateFormat('yMMMd', 'fr').format(date).toString();
    String timeStringStart = DateFormat('HH:mm', 'fr').format(date).toString();
    String timeStringEnd = DateFormat('HH:mm', 'fr').format(date.add(const Duration(minutes: 30))).toString();
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              Column(
                children:[
                  Text('Rendez-vous du $dateString', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),),
                  Text('de $timeStringStart à $timeStringEnd', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),),
                ]),
              const SizedBox(height: 16),
              CustomCardModal(text: 'Diagnostic', icon: BootstrapIcons.heart_pulse_fill, onTap: () {WoltModalSheet.show(
                context: context,
                pageListBuilder: (BuildContext context) {
                  return [
                    
                  ];
                },
              );}),
              const SizedBox(height: 4),
              CustomCardModal(text: 'Retranscription du chat', icon: BootstrapIcons.file_text_fill, onTap: () {WoltModalSheet.show(
                context: context,
                pageListBuilder: (BuildContext context) {
                  return [
                    
                  ];
                },
              );}),
              if(!widget.old) Column (children:[
              const SizedBox(height: 12),
              Container(height: 2,color: AppColors.blue200),
              const SizedBox(height: 12),
              Buttons(variant: Variante.primary, size: SizeButton.sm, msg: const Text('Modifier le rendez-vous', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600),), onPressed: () {WoltModalSheet.show(
                context: context,
                pageListBuilder: (BuildContext context) {
                  return [
                    updateAppointmentModal(context, widget.rdvInfo, updateAppointment),
                  ];
                },
              );}),
              const SizedBox(height: 4),
              Buttons(variant: Variante.delete, size: SizeButton.sm, msg: const Text('Annuler le rendez-vous', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600),), onPressed: () {WoltModalSheet.show(
                context: context,
                pageListBuilder: (BuildContext context) {
                  return [
                    deleteRdv(context, widget.rdvInfo['id']),
                  ];
                },
              );},)]),
            ]),
        ),
      ),
    );
  }

   SliverWoltModalSheetPage deleteRdv(BuildContext context, String id){
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: AppColors.red200,
                  ),
                  child: const Icon(
                    BootstrapIcons.x,
                    color: AppColors.red700,
                    size: 40,
                  )),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Êtes-vous sûr ?",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Si vous supprimez ce rendez-vous, vous ne pourrez plus revenir en arrière",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  const Text('La raison de l\'annulation', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
                  const SizedBox(
                    height: 4,
                  ),
                  CustomField(startUppercase: false, label: 'Renseignez la raison de l\'annulation', keyboardType: TextInputType.text, onChanged: (value){}),
              ]),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.427,
                    child: Buttons(
                      variant: Variante.secondary,
                      size: SizeButton.sm,
                      msg: const Text('Annuler'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.427,
                    child: Buttons(
                      variant: Variante.delete,
                      size: SizeButton.sm,
                      msg: const Text('Oui, je suis sûr'),
                      onPressed: () {
                        cancelAppointments(id, context);
                        widget.delete();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ]),
        ),
      ),
    );
   }

    SliverWoltModalSheetPage updateAppointmentModal(BuildContext context, Map<String, dynamic> rdvInfo, Function updateAppointment) {
    
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: ModifList(rdvInfo: rdvInfo, updateFunc: updateAppointment),
    );
  }
}