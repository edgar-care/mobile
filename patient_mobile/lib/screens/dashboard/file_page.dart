import 'dart:io';

import 'package:edgar/services/get_files.dart';
import 'package:edgar/widget/buttons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/field_custom.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/widget/card_document.dart';
import 'package:logger/logger.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class FilePage extends StatefulWidget {
  const FilePage({super.key});

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  @override
  void initState() {
    super.initState();
    fetchData(context);
  }

  List<Map<String, dynamic>> files = [];

  Future<void> fetchData(BuildContext context) async {
    files = await getAllDocument();
  }

  final pageIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    SliverWoltModalSheetPage addDocument(
      BuildContext context,
      ValueNotifier<int> pageIndex,
    ) {
      return WoltModalSheetPage(
        hasTopBarLayer: false,
        backgroundColor: AppColors.white,
        hasSabGradient: true,
        enableDrag: true,
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: BodyModal(),
        ),
      );
    }

    return FutureBuilder(
      future: fetchData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 50),
                    width: 120,
                    child: Image.asset(
                        'assets/images/logo/full-width-colored-edgar-logo.png'),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.blue700,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(children: [
                    Image.asset(
                      'assets/images/logo/edgar-high-five.png',
                      width: 40,
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Mes Documents',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 24),
                CustomField(
                  label: 'Nom du document ou du médecin',
                  icon: BootstrapIcons.search,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 24),
                Buttons(
                    variant: Variante.primary,
                    size: SizeButton.sm,
                    msg: const Text('Ajouter un document'),
                    onPressed: () {
                      WoltModalSheet.show<void>(
                          context: context,
                          pageIndexNotifier: pageIndex,
                          pageListBuilder: (modalSheetContext) {
                            return [
                              addDocument(
                                context,
                                pageIndex,
                              ),
                            ];
                          });
                    }),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    addRepaintBoundaries: true,
                    shrinkWrap: true,
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CardDocument(
                          typeDeDocument: files[index]['document_type'] ==
                                  'PRESCRIPTION'
                              ? TypeDeDocument.PRESCRIPTION
                              : files[index]['document_type'] == 'CERTIFICATE'
                                  ? TypeDeDocument.CERTIFICATE
                                  : files[index]['document_type'] == 'XRAY'
                                      ? TypeDeDocument.XRAY
                                      : TypeDeDocument.OTHER,
                          nomDocument: files[index]['name'],
                          dateDocument: DateTime.now(),
                          nameDoctor: 'Vous',
                          isfavorite: files[index]['is_favorite'],
                          id: files[index]['id'],
                          url: files[index]['download_url'],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
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

  @override
  void initState() {
    super.initState();
  }

  String getFileName(String path) {
    String filePath =
        '/data/user/0/com.edgar.edgar/cache/file_picker/4040. Basic Electrical Installation Work Sixth Edition By Trevor Linsley.pdf';
    String fileName = filePath.split('/').last;
    String title =
        fileName.split('.').skip(1).join('.').replaceAll('.pdf', '').trim();

    return title;
  }

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
      Logger().i(fileSelected);
      Logger().i(fileSelected!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        Wrap(
          spacing: 8,
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.green200,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                BootstrapIcons.file_plus_fill,
                color: AppColors.green700,
              ),
            ),
            const Text(
              'Ajoutez un document à votre espace santé',
              style: TextStyle(
                color: AppColors.black,
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textBaseline: TextBaseline.alphabetic,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          direction: Axis.vertical,
          children: [
            const Text(
              'Votre document',
              style: TextStyle(
                color: AppColors.black,
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textBaseline: TextBaseline.alphabetic,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
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
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Le type de votre document',
                    style: TextStyle(
                      color: AppColors.black,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textBaseline: TextBaseline.alphabetic,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 48,
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
                      style: const TextStyle(color: AppColors.black),
                      onChanged: (String? newValue) {
                        Logger().i(newValue);
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
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Le type de médecine',
                    style: TextStyle(
                      color: AppColors.black,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textBaseline: TextBaseline.alphabetic,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 48,
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
                  )
                ],
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Buttons(
                variant: Variante.secondary,
                size: SizeButton.sm,
                msg: const Text('Annuler'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Buttons(
                variant: Variante.validate,
                size: SizeButton.sm,
                msg: const Text('Ajouter'),
                onPressed: () {
                  if (fileSelected != null) {
                    postDocument(
                      dropdownValue,
                      dropdownValue2,
                      fileSelected!,
                    );
                  }
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
