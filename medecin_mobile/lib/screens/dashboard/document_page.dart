import 'dart:io';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/patient_document_service.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_nav_patient_card.dart';
import 'package:edgar_pro/widgets/document_patient_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// ignore: must_be_immutable
class DocumentPage extends StatefulWidget {
  String id;
  Function setPages;
  Function setId;
  DocumentPage(
      {super.key,
      required this.id,
      required this.setPages,
      required this.setId});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  Map<String, dynamic> patientInfo = {};
  List<Map<String, dynamic>> documents = [];
  Future<void> _loadDoc() async {
    patientInfo = await getPatientById(widget.id);
    documents = await getDocumentsIds(widget.id);
  }

  Future<void> updateData() async {
    setState(() {
      _loadDoc();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadDoc(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
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
                    WoltModalSheet.show<void>(
                        context: context,
                        pageListBuilder: (modalSheetContext) {
                          return [
                            patientNavigation(context, patientInfo,
                                widget.setPages, widget.setId),
                          ];
                        });
                  },
                  child: Padding(
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
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${patientInfo['Nom']} ${patientInfo['Prenom']}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                        ),
                        const Spacer(),
                        const Text(
                          'Voir Plus',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          BootstrapIcons.chevron_right,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                  child: ListView.separated(
                      itemCount: documents.length,
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 4,
                          ),
                      itemBuilder: (BuildContext context, int index) {
                        return DocumentPatientCard(
                          type: documents[index]['document_type'],
                          date: 'Aujourd\'hui',
                          name: documents[index]['name'],
                          url: documents[index]['download_url'],
                        );
                      })),
              Buttons(
                variant: Variante.primary,
                size: SizeButton.md,
                msg: const Text('Ajouter un document'),
                onPressed: () {
                  WoltModalSheet.show<void>(
                      context: context,
                      pageListBuilder: (modalSheetContext) {
                        return [
                          addDocument(updateData, patientInfo),
                        ];
                      });
                },
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  SliverWoltModalSheetPage patientNavigation(BuildContext context,
      Map<String, dynamic> patient, Function setPages, Function setId) {
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(children: [
            Text(
              '${patient['Nom']} ${patient['Prenom']}',
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomNavPatientCard(
                text: 'Dossier médical',
                icon: BootstrapIcons.postcard_heart_fill,
                setPages: setPages,
                pageTo: 6,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 4),
            CustomNavPatientCard(
                text: 'Rendez-vous',
                icon: BootstrapIcons.calendar2_week_fill,
                setPages: setPages,
                pageTo: 7,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 4),
            CustomNavPatientCard(
                text: 'Documents',
                icon: BootstrapIcons.file_earmark_text_fill,
                setPages: setPages,
                pageTo: 8,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 4),
            CustomNavPatientCard(
                text: 'Messagerie',
                icon: BootstrapIcons.chat_dots_fill,
                setPages: setPages,
                pageTo: 9,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 12),
            Container(height: 2, color: AppColors.blue200),
            const SizedBox(height: 12),
            Buttons(
                variant: Variante.primary,
                size: SizeButton.sm,
                msg: const Text(
                  'Revenir à la patientèle',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                onPressed: () {
                  setPages(1);
                  Navigator.pop(context);
                }),
          ]),
        ),
      ),
    );
  }

  SliverWoltModalSheetPage addDocument(
      Function updateData, Map<String, dynamic> patientInfo) {
    return WoltModalSheetPage(
      hasTopBarLayer: false,
      child: BodyModal(updateData: updateData, patientInfo: patientInfo),
    );
  }
}

// ignore: must_be_immutable
class BodyModal extends StatefulWidget {
  Function updateData;
  Map<String, dynamic> patientInfo;
  BodyModal({super.key, required this.updateData, required this.patientInfo});

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
      allowedExtensions: ['pdf', 'doc', 'png', 'docx', 'odt'],
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
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 16,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              "Le type de votre document",
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
                items: <String>['Certificat', 'Ordonnance', 'Radio', 'Autre']
                    .map<DropdownMenuItem<String>>((String value) {
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
                      if (fileSelected != null) {
                        postDocument(
                          dropdownValue,
                          dropdownValue2,
                          widget.patientInfo["id"],
                          fileSelected!,
                        ).then((value) => widget.updateData());
                      }
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
