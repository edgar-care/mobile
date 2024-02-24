// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/widget/card_filter_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:edgar/services/get_files.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/buttons.dart';
import 'package:edgar/widget/card_document.dart';
import 'package:edgar/widget/field_custom.dart';

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
    fetchData(context);
  }

  List<Map<String, dynamic>> files = [];

  Future<void> fetchData(BuildContext context) async {
    files = await getAllDocument();
  }

  Future<void> updateData(BuildContext context) async {
    setState(() {
      fetchData(context);
    });
  }

  final pageIndex = ValueNotifier(0);

  String searchTerm = '';
  List<Map<String, dynamic>> originalfiles = [];
  bool isByAlpha = false;
  bool isOrdonnance = false;
  bool isCertificat = false;
  bool isRadio = false;
  bool isAutre = false;
  bool isFavorite = false;

  void setIsOrdonnance() {
    setState(() {
      isOrdonnance = true;
    });
  }

  void setIsCertificat() {
    setState(() {
      isCertificat = true;
    });
  }

  void setIsRadio() {
    setState(() {
      isRadio = true;
    });
  }

  void setIsAutre() {
    setState(() {
      isAutre = true;
    });
  }

  void setIsFavorite() {
    setState(() {
      isFavorite = true;
    });
  }



  @override
  Widget build(BuildContext context) {
    SliverWoltModalSheetPage addDocument(
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

                        return Column(
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
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                onChanged: (value) {
                                  setState(() {
                                  searchTerm = value; // Store the search term
                                });
                              }, action: TextInputAction.search,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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
                                      child: Wrap(
                                      spacing: 8,
                                      runAlignment: WrapAlignment.start,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      alignment: WrapAlignment.start,
                                      children: [
                                        Icon(
                                          isByAlpha
                                              ? BootstrapIcons.arrow_down
                                              : BootstrapIcons.arrow_up,
                                          color: AppColors.blue700,
                                          size: 16,
                                        ),
                                        const Text(
                                          'Nom',
                                          style: TextStyle(
                                            color: AppColors.blue700,
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Icon(
                                          isByAlpha
                                                ? BootstrapIcons.chevron_down
                                                : BootstrapIcons.chevron_up,
                                            color: AppColors.blue700,
                                            size: 16,
                                        )
                                      ],
                                    ),
                                    )
                                  ),
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
                                              child: Column(children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                              });
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
                                setState(() {
                                  Navigator.pop(context);
                                });
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
                                  setIsFavorite();
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
                                  setIsCertificat();
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
                                  setIsAutre();
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
                                  setIsRadio();
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
                                  setIsOrdonnance();
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
                        ],)
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(BootstrapIcons.plus_lg, color: AppColors.blue700, size: 16,)
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
              IntrinsicWidth(child: FilterCard(
                  header: const Icon(BootstrapIcons.circle_fill, color: AppColors.green700, size: 16),
                  onTap: () {
                    setState(() {
                      isOrdonnance = false;
                    });
                  },
                  text: 'Ordonnance',
                ),),

              if (isCertificat)
                IntrinsicWidth(child: FilterCard(
                  header: const Icon(BootstrapIcons.circle_fill, color: AppColors.blue700, size: 16),
                  onTap: () {
                    setState(() {
                      isCertificat = false;
                    });
                  },
                  text: 'Certificat',
                ),),
              if (isRadio)
                IntrinsicWidth(child: FilterCard(
                  header: const Icon(BootstrapIcons.circle_fill, color: AppColors.green200, size: 16),
                  onTap: () {
                    setState(() {
                      isRadio = false;
                    });
                  },
                  text: 'Radio',
                ),),
              if (isAutre)
                IntrinsicWidth(child: FilterCard(
                  header: const Icon(BootstrapIcons.circle_fill, color: AppColors.blue200, size: 16),
                  onTap: () {
                    setState(() {
                      isAutre = false;
                    });
                  },
                  text: 'Autre',
                ),),
              if (isFavorite)
                IntrinsicWidth(child: FilterCard(
                  header: const Icon(BootstrapIcons.star_fill, color: AppColors.blue700, size: 16),
                  onTap: () {
                    setState(() {
                      isFavorite = false;
                    });
                  },
                  text: 'Favoris',
                ),),
            ],
          ),
        ),
          const SizedBox(height: 12),
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
                          updateData,
                        ),
                      ];
                    });
              }),
          const SizedBox(height: 24),
          FutureBuilder(
          future: fetchData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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
                return Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: filteredFiles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CardDocument(
                          typeDeDocument: documentTypeMap[filteredFiles[index]['document_type']] ??
                                          TypeDeDocument.OTHER,
                          nomDocument: filteredFiles[index]['name'],
                          nameDoctor: 'Vous',
                          isfavorite: filteredFiles[index]['is_favorite'],
                          id: filteredFiles[index]['id'],
                          url: filteredFiles[index]['download_url'],
                          updatedata: updateData,
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      );
  }
}

// ignore: must_be_immutable
class BodyModal extends StatefulWidget {
  Function updateData;
  BodyModal({
    super.key,
    required this.updateData,
  });

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
    String fileName = path.split('/').last;
    return fileName;
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
                    widget.updateData(context);
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
