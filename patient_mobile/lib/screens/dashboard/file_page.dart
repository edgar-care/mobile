// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously, duplicate_ignore
import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_app/widget/card_filter_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:edgar_app/services/get_files.dart';
import 'package:edgar_app/widget/card_document.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:provider/provider.dart';

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
  List<Map<String, dynamic>> filteredFiles = [];

  Future<void> checkPermission() async {
    final status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      Permission.manageExternalStorage.request();
    }
  }

  Future<void> fetchData() async {
    files = await getAllDocument(context);
    return;
  }

  void updateData() async {
    var tmp = await getAllDocument(context);
    setState(() {
      files = tmp;
      filteredFiles = files;
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
                final model =
                    Provider.of<BottomSheetModel>(context, listen: false);
                model.resetCurrentIndex();

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Consumer<BottomSheetModel>(
                      builder: (context, model, child) {
                        return ListModal(
                          model: model,
                          children: [
                            ModalContainer(
                              title: "Filtrer vos document",
                              subtitle:
                                  "Séléctionner les catégories qui vous intéresse",
                              icon: const IconModal(
                                icon: Icon(
                                  BootstrapIcons.filter_square,
                                  color: AppColors.blue700,
                                  size: 18,
                                ),
                                type: ModalType.info,
                              ),
                              body: [
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
                                        color: AppColors.green500,
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
                            )
                          ],
                        );
                      },
                    );
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
          variant: Variant.primary,
          size: SizeButton.md,
          msg: const Text('Ajouter un document'),
          onPressed: () {
            final model = Provider.of<BottomSheetModel>(context, listen: false);
            model.resetCurrentIndex();

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return Consumer<BottomSheetModel>(
                  builder: (context, model, child) {
                    return ListModal(
                      model: model,
                      children: [
                        AddDocument(
                          updateData: updateData,
                        ),
                      ],
                    );
                  },
                );
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
                filteredFiles = files
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
                        updatedata: updateData,
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

class AddDocument extends StatefulWidget {
  final Function updateData;
  const AddDocument({super.key, required this.updateData});

  @override
  State<AddDocument> createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
  String dropdownValue = 'Général';
  String dropdownValue2 = 'Ordonnance';
  File? fileSelected;
  bool clicked = false;

  String getFileName(String path) {
    return path.split('/').last;
  }

  void openFileExplorer() async {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'png', 'docx', 'odtx', 'odt'],
      dialogTitle: 'Choisir un fichier',
    );
    if (file != null) {
      setState(() {
        fileSelected = File(file.files.single.path!);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Ajoutez un document à votre espace santé",
      subtitle: "Compléter tout les champs",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.file_plus_fill,
          color: AppColors.green700,
          size: 18,
        ),
        type: ModalType.success,
      ),
      body: [
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        border: Border.all(color: AppColors.grey700, width: 1),
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
      ],
      footer: Row(
        children: [
          Flexible(
            child: Buttons(
              variant: Variant.secondary,
              size: SizeButton.sm,
              msg: const Text('Annuler'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Buttons(
              variant: Variant.validate,
              size: SizeButton.sm,
              msg: const Text('Ajouter'),
              onPressed: () {
                clicked = true;
                if (fileSelected != null) {
                  postDocument(
                    dropdownValue,
                    dropdownValue2,
                    fileSelected!,
                    context
                  ).then((value) {
                    clicked = false;
                    if (value == true) {
                      widget.updateData();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  });
                } else {
                  TopErrorSnackBar(message: "Veuillez séléctionner un fichier")
                      .show(context);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
