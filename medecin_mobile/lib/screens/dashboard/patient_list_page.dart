import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// ignore: must_be_immutable
class PatientPage extends StatefulWidget {
  String id;
  final Function setPages;
  final Function setId;
  PatientPage({super.key, required this.id, required this.setPages, required this.setId});

  @override
  State<PatientPage> createState() => _PatientPageState();
}
class _PatientPageState extends State<PatientPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.blue100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.blue200,
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: () {
            },
            child : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 3,
                    decoration: BoxDecoration(
                      color: AppColors.green500,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(width: 8,),
                  const Text(
                    'Nom Prénom',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins'
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Voir Plus',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins'
                    ),
                  ),
                  const SizedBox(width: 8,),
                  const Icon(
                    BootstrapIcons.chevron_right,
                    size: 12,
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16,),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.blue200, width: 2)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child:
                        Wrap(
                          alignment: WrapAlignment.start,
                          direction: Axis.vertical,
                          spacing: 12,
                          children: [
                            Text('Prénom:', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                            Text('Nom:', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                            Text('Date de naissance:', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                            Text('Sexe:', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                            Text('Taille:', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                            Text('Poids:', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                            Text('Médecin traitant:', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                            Text('Antécédants médicaux et sujets de santé:', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                          ],
                        )
                    ),
                    Buttons(
                      variant: Variante.primary,
                      size: SizeButton.md,
                      msg: const Text('Modifier le dossier médical'),
                      onPressed: () {
                        WoltModalSheet.show<void>(
                            context: context,
                            pageListBuilder: (modalSheetContext) {
                              return [
                              ];
                            });
                      },
                    ),
                  ],),
                  ),
            ),
          ),
      ],
    );
  }
}