import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/document_patient_card.dart';
import 'package:file_picker/file_picker.dart';
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
          msg: const Text('Ajouter un document'),
          onPressed: () {
            WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  return [
                    addDocument(),
                  ];
                });
          },
        ),
      ],
    );
  }
  SliverWoltModalSheetPage addDocument() {
    return WoltModalSheetPage(
      hasTopBarLayer: false,
      child: const BodyModal(),
    );
  }
}

class BodyModal extends StatefulWidget {
  const BodyModal({super.key});

  @override
  State<BodyModal> createState() => _BodyModalState();
}

class _BodyModalState extends State<BodyModal> {
   String dropdownValue = 'Général';
    String dropdownValue2 = 'Ordonnance';
    File? fileSelected;

   void openFileExplorer() async {
      final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'png', 'jpg', 'jpeg', 'docx', 'odt'],
        dialogTitle: 'Choisir un fichier',
      );
      if (file != null) {
        setState(() {
          fileSelected = File(file.files.single.path!);
        });
      }
    }

    String getFileName(String path) {
      String fileName = path.split('/').last;
      return fileName;
    }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
              Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: AppColors.green200,
                  ),
                  child: const Icon(
                    BootstrapIcons.file_check_fill,
                    color: AppColors.green700,
                    size: 24,
                  )),
               const SizedBox(
                height: 8,
              ),
              const Text(
                "Ajoutez un document au patient",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Votre document",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                  width: MediaQuery.of(context).size.width - 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.blue500, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          border: Border.all(color: AppColors.grey700, width: 1),
                        ),
                        child: TextFieldTapRegion(
                          debugLabel: 'Choisir un fichier',
                          child: const Text(
                            'Choisir un fichier',
                            style: TextStyle(
                              color: AppColors.grey700,
                              fontFamily: 'Poppins',
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              textBaseline: TextBaseline.alphabetic,
                              decorationColor: AppColors.grey400,
                            ),
                          ),
                          onTapInside: (event) {
                            openFileExplorer();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fileSelected == null
                              ? 'Aucun fichier sélectionné'
                              : getFileName(fileSelected!.path),
                          style: const TextStyle(
                            color: AppColors.grey700,
                            fontFamily: 'Poppins',
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                            textBaseline: TextBaseline.alphabetic,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Type de document",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.blue500, width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: DropdownButton<String>(
                    value: dropdownValue2,
                    icon: const Icon(BootstrapIcons.chevron_down),
                    iconSize: 16,
                    style: const TextStyle(color: AppColors.black),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(12),
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue2 = newValue!;
                      });
                    },
                    items: <String>[
                      'Ordonnance',
                      'Certificat',
                      'Autre',
                      'Radio'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: const TextStyle(
                                color: AppColors
                                    .black)), // Added style to change display value color
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Le type de médecine",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.blue500, width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(BootstrapIcons.chevron_down),
                    iconSize: 16,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(12),
                    underline: Container(
                      height: 0,
                    ),
                    style: const TextStyle(color: AppColors.black),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>[
                      'Général',
                      'Finance',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                ]),
             const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.42,
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
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: Buttons(
                      variant: Variante.validate,
                      size: SizeButton.sm,
                      msg: const Text('Ajouter'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ]),
          ],
        ),
      );
  }
}