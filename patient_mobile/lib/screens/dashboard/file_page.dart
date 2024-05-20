// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/widget/card_filter_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:edgar/services/get_files.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/buttons.dart';
import 'package:edgar/widget/card_document.dart';
import 'package:edgar/widget/field_custom.dart';
import 'package:permission_handler/permission_handler.dart';

final documentTypeMap = {
  'PRESCRIPTION': TypeDeDocument.PRESCRIPTION,
  'CERTIFICATE': TypeDeDocument.CERTIFICATE,
  'XRAY': TypeDeDocument.XRAY,
  // ... other document types
};

class FilePage extends StatefulWidget {
  const FilePage({super.key});

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  @override
  void initState() {
    super.initState();
    fetchData();
    checkPermission();
  }

  List<Map<String, dynamic>> files = [];
  List<Map<String, dynamic>> originalFiles = [];

  Future<void> checkPermission() async {
    final status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      final st = await Permission.manageExternalStorage.request();
      Logger().i('Permission status: $st');
    }
  }

  Future<void> fetchData() async {
    files = await getAllDocument();
    originalFiles = files;
    return;
  }

  void updateData() async {
    var tmp = await getAllDocument();
    setState(() {
      files = tmp;
    });
  }

  final pageIndex = ValueNotifier(0);

  String searchTerm = '';
  bool isByAlpha = false;
  bool isOrdonnance = false;
  bool isCertificat = false;
  bool isRadio = false;
  bool isAutre = false;
  bool isFavorite = false;

  void toggleFilter(String filterType) {
    setState(() {
      switch (filterType) {
        case 'Ordonnance':
          isOrdonnance = !isOrdonnance;
          break;
        case 'Certificat':
          isCertificat = !isCertificat;
          break;
        case 'Radio':
          isRadio = !isRadio;
          break;
        case 'Autre':
          isAutre = !isAutre;
          break;
        case 'Favoris':
          isFavorite = !isFavorite;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            color: AppColors.blue700,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(children: [
            Image.asset(
              'assets/images/logo/edgar-high-five.png',
              width: 40,
            ),
            const SizedBox(width: 16),
            const Text(
              'Mes documents',
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
          onChanged: (value) {
            setState(() {
              searchTerm = value; // Store the search term
            });
          },
          action: TextInputAction.search,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppColors.blue700, width: 1),
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isByAlpha = !isByAlpha;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        isByAlpha
                            ? BootstrapIcons.arrow_down
                            : BootstrapIcons.arrow_up,
                        color: AppColors.blue700,
                        size: 16,
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        'Nom',
                        style: TextStyle(
                          color: AppColors.blue700,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isByAlpha
                            ? BootstrapIcons.chevron_down
                            : BootstrapIcons.chevron_up,
                        color: AppColors.blue700,
                        size: 16,
                      )
                    ],
                  ),
                )),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                WoltModalSheet.show<void>(
                  context: context,
                  pageListBuilder: (modalSheetContext) {
                    return [
                      WoltModalSheetPage(
                        hasTopBarLayer: false,
                        backgroundColor: AppColors.white,
                        hasSabGradient: true,
                        enableDrag: true,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      BootstrapIcons.person_fill,
                                      color: AppColors.blue700,
                                      size: 16,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Ajouté par un médecin',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      BootstrapIcons.person_fill,
                                      color: AppColors.blue700,
                                      size: 16,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Ajouté par votre médecin traitant',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  toggleFilter('Favoris');
                                  Navigator.pop(context);
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      BootstrapIcons.star_fill,
                                      color: AppColors.blue700,
                                      size: 16,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Favoris',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  toggleFilter('Certificat');
                                  Navigator.pop(context);
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      BootstrapIcons.circle_fill,
                                      color: AppColors.blue700,
                                      size: 16,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Certificat',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  toggleFilter('Autre');
                                  Navigator.pop(context);
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      BootstrapIcons.circle_fill,
                                      color: AppColors.blue200,
                                      size: 16,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Autre documents',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  toggleFilter('Radio');
                                  Navigator.pop(context);
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      BootstrapIcons.circle_fill,
                                      color: AppColors.green200,
                                      size: 16,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Radiologie',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  toggleFilter('Ordonnance');
                                  Navigator.pop(context);
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      BootstrapIcons.circle_fill,
                                      color: AppColors.green700,
                                      size: 16,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Ordonnance',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                );
              },
              child: const Row(
                children: [
                  Text(
                    'Ajouter des filtres',
                    style: TextStyle(
                      color: AppColors.blue700,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    BootstrapIcons.plus_lg,
                    color: AppColors.blue700,
                    size: 16,
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            spacing: 8,
            children: [
              if (isOrdonnance)
                IntrinsicWidth(
                  child: FilterCard(
                    header: const Icon(BootstrapIcons.circle_fill,
                        color: AppColors.green500, size: 16),
                    onTap: () {
                      toggleFilter('Ordonnance');
                    },
                    text: 'Ordonnance',
                  ),
                ),
              if (isCertificat)
                IntrinsicWidth(
                  child: FilterCard(
                    header: const Icon(BootstrapIcons.circle_fill,
                        color: AppColors.blue700, size: 16),
                    onTap: () {
                      toggleFilter('Certificat');
                    },
                    text: 'Certificat',
                  ),
                ),
              if (isRadio)
                IntrinsicWidth(
                  child: FilterCard(
                    header: const Icon(BootstrapIcons.circle_fill,
                        color: AppColors.green200, size: 16),
                    onTap: () {
                      toggleFilter('Radio');
                    },
                    text: 'Radio',
                  ),
                ),
              if (isAutre)
                IntrinsicWidth(
                  child: FilterCard(
                    header: const Icon(BootstrapIcons.circle_fill,
                        color: AppColors.blue200, size: 16),
                    onTap: () {
                      toggleFilter('Autre');
                    },
                    text: 'Autre',
                  ),
                ),
              if (isFavorite)
                IntrinsicWidth(
                  child: FilterCard(
                    header: const Icon(BootstrapIcons.star_fill,
                        color: AppColors.blue700, size: 16),
                    onTap: () {
                      toggleFilter('Favoris');
                    },
                    text: 'Favoris',
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Buttons(
          variant: Variante.primary,
          size: SizeButton.md,
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
                    updateData,
                  ),
                ];
              },
            );
          },
        ),
        const SizedBox(height: 12),
        Expanded(
          child: FutureBuilder<void>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blue700,
                    strokeWidth: 2,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else {
                var filteredFiles = files
                    .where((document) => document['name']
                        .toLowerCase()
                        .contains(searchTerm.toLowerCase()))
                    .toList();

                // Apply sorting if needed
                if (isByAlpha) {
                  filteredFiles.sort((a, b) => a['name'].compareTo(b['name']));
                } else {
                  filteredFiles.sort((a, b) => b['name'].compareTo(a['name']));
                }

                // Apply favorite filter first if selected
                if (isFavorite) {
                  filteredFiles = filteredFiles
                      .where((document) => document['is_favorite'] == true)
                      .toList();
                }

                // Apply other filters conditionally and cumulatively
                if (isOrdonnance) {
                  filteredFiles = filteredFiles
                      .where((document) =>
                          document['document_type'] == 'PRESCRIPTION')
                      .toList();
                }
                if (isCertificat) {
                  filteredFiles = filteredFiles
                      .where((document) =>
                          document['document_type'] == 'CERTIFICATE')
                      .toList();
                }
                if (isRadio) {
                  filteredFiles = filteredFiles
                      .where((document) => document['document_type'] == 'XRAY')
                      .toList();
                }
                if (isAutre) {
                  filteredFiles = filteredFiles
                      .where((document) => document['document_type'] == 'OTHER')
                      .toList();
                }
                Logger().i('Filtered files: $filteredFiles');
                if (filteredFiles.isEmpty) {
                  return const Center(
                    child: Text('Aucun document trouvé'),
                  );
                }
                return ListView.builder(
                  itemCount: filteredFiles.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CardDocument(
                        typeDeDocument: documentTypeMap[filteredFiles[index]
                                ['document_type']] ??
                            TypeDeDocument.OTHER,
                        nomDocument: filteredFiles[index]['name'],
                        nameDoctor: 'Vous',
                        isfavorite: filteredFiles[index]['is_favorite'],
                        id: filteredFiles[index]['id'],
                        url: filteredFiles[index]['download_url'],
                        updatedata: fetchData,
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

WoltModalSheetPage addDocument(
  BuildContext context,
  ValueNotifier<int> pageIndex,
  Function updateData,
) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: BodyModal(updateData: updateData),
    ),
  );
}

class BodyModal extends StatefulWidget {
  final Function updateData;
  const BodyModal({super.key, required this.updateData});

  @override
  State<BodyModal> createState() => _BodyModalState();
}

class _BodyModalState extends State<BodyModal> {
  final Logger _logger = Logger();
  String dropdownValue = 'Général';
  String dropdownValue2 = 'Ordonnance';
  File? fileSelected;

  String getFileName(String path) {
    return path.split('/').last;
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
        _logger.d('File selected: ${fileSelected!.path}');
      });
    } else {
      _logger.d('No file selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textBaseline: TextBaseline.alphabetic,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Votre document',
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textBaseline: TextBaseline.alphabetic,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
              ),
              const SizedBox(height: 8),
              Container(
                width: MediaQuery.of(context).size.width - 48,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.blue500, width: 2),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: openFileExplorer,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          border:
                              Border.all(color: AppColors.grey700, width: 1),
                        ),
                        child: const Text(
                          'Choisir un fichier',
                          style: TextStyle(
                            color: AppColors.grey700,
                            fontFamily: 'Poppins',
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                            textBaseline: TextBaseline.alphabetic,
                          ),
                        ),
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
          const SizedBox(height: 16),
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
                        fontSize: 12,
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
                        icon: const Icon(Icons.arrow_drop_down),
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
                            _logger.d('Dropdown 1: $dropdownValue');
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
                        fontSize: 12,
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
                        value: dropdownValue2,
                        icon: const Icon(Icons.arrow_drop_down),
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
                            _logger.d('Dropdown 2: $dropdownValue2');
                          });
                        },
                        items: <String>[
                          'Ordonnance',
                          'Certificat',
                          'Autre',
                          'Radio',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: AppColors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width - 48,
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Buttons(
                    variant: Variante.secondary,
                    size: SizeButton.sm,
                    msg: const Text('Annuler'),
                    onPressed: () {
                      _logger.d('Cancel button pressed.');
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Buttons(
                    variant: Variante.validate,
                    size: SizeButton.sm,
                    msg: const Text('Ajouter'),
                    onPressed: () {
                      if (fileSelected != null) {
                        _logger.d('Add button pressed with file selected.');
                        postDocument(
                          dropdownValue,
                          dropdownValue2,
                          fileSelected!,
                        ).then((value) {
                          if (value == null) {
                            widget.updateData();
                            Navigator.pop(context);
                          }
                        });
                      } else {
                        _logger.d('Add button pressed with no file selected.');
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
