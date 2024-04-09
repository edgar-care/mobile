import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/document_patient_card.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {


  Future<void> _loadInfo() async {
  }

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
        FutureBuilder(
          future: _loadInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Expanded(
                child: ListView.separated(
                  itemCount: 2,
                  separatorBuilder: (context, index) => const SizedBox(height: 4,),
                  itemBuilder: (BuildContext context, int index) {
                    return DocumentPatientCard(type: 'XRAY', date: 'Aujourd\'hui', name: 'Radio');
                  }));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        Buttons(
          variant: Variante.primary,
          size: SizeButton.md,
          msg: const Text('Ajouter un patient +'),
          onPressed: () {
            WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [
                  ];
                });
          },
        ),
      ],
    );
  }
}