// ignore_for_file: constant_identifier_names

import 'package:download_file/data/models/download_file_options.dart';
import 'package:download_file/download_file.dart';
import 'package:edgar/widget/custom_modal.dart';
import 'package:edgar/widget/field_custom.dart';
import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:edgar/widget/buttons.dart';
import 'package:edgar/services/get_files.dart';

enum TypeDeDocument {
  PRESCRIPTION,
  OTHER,
  CERTIFICATE,
  XRAY,
}

Size screenSize = const Size(0, 0);

// ignore: must_be_immutable
class CardDocument extends StatefulWidget {
  final TypeDeDocument typeDeDocument;
  final String nomDocument;
  final String nameDoctor;
  bool isfavorite;
  String id;
  String url;
  Function updatedata;

  CardDocument({
    super.key,
    required this.typeDeDocument,
    required this.nomDocument,
    required this.nameDoctor,
    required this.isfavorite,
    required this.id,
    required this.url,
    required this.updatedata,
  });

  @override
  State<CardDocument> createState() => _CardDocumentState();
}

class _CardDocumentState extends State<CardDocument> {
  Color documentColor(TypeDeDocument typeDeDocument) {
    switch (typeDeDocument) {
      case TypeDeDocument.PRESCRIPTION:
        return AppColors.green500;
      case TypeDeDocument.OTHER:
        return AppColors.blue200;
      case TypeDeDocument.CERTIFICATE:
        return AppColors.blue700;
      case TypeDeDocument.XRAY:
        return AppColors.green200;
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      screenSize = MediaQuery.of(context).size;
    });
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue200, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.isfavorite) {
                deleteFavory(widget.id);
              } else {
                changeFavorite(widget.id);
              }
              setState(() {
                widget.isfavorite = !widget.isfavorite;
              });
            },
            child: Container(
              child: widget.isfavorite
                  ? const Icon(Icons.star, color: AppColors.blue700)
                  : const Icon(Icons.star_border, color: AppColors.blue300),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: documentColor(widget.typeDeDocument),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.nomDocument[0].toUpperCase() +
                      widget.nomDocument.substring(1),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Ajouté par ${widget.nameDoctor}",
                  style: const TextStyle(
                    color: AppColors.black,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
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
                          OpenPatient(
                            url: widget.url,
                            id: widget.id,
                            isfavorite: widget.isfavorite,
                            name: widget.nomDocument,
                            model: model,
                          ),
                          ModifyPatient(
                            name: widget.nomDocument,
                            id: widget.id,
                            updatedata: widget.updatedata,
                          ),
                          DeletePatient(
                              id: widget.id, updatedata: widget.updatedata)
                        ],
                      );
                    },
                  );
                },
              );
            },
            child: const Icon(
              BootstrapIcons.three_dots_vertical,
              color: AppColors.black,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

final pageIndex = ValueNotifier(0);

class OpenPatient extends StatefulWidget {
  final String url;
  final String id;
  final bool isfavorite;
  final String name;
  final BottomSheetModel model;
  const OpenPatient(
      {super.key,
      required this.url,
      required this.id,
      required this.isfavorite,
      required this.name,
      required this.model});

  @override
  State<OpenPatient> createState() => _OpenPatientState();
}

class _OpenPatientState extends State<OpenPatient> {
  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Séléctionner une catégorie",
      subtitle: "Télécharger un document ou modifier le",
      icon: const IconModal(
        icon: Icon(
          Icons.filter_alt_rounded,
          color: AppColors.grey700,
          size: 20,
        ),
        type: ModalType.info,
      ),
      body: [
        Buttons(
          variant: Variante.primary,
          size: SizeButton.md,
          msg: const Text('Télécharger'),
          onPressed: () async {
            DownloadFile.downloadAndSafeFile(
              downloadFileOptions: DownloadFileOptions(
                downloadUrl: widget.url,
                fileName: widget.name,
              ),
              context: context,
              loadingWidget: const Center(
                child: Column(
                  children: [
                    Text(
                      'Téléchargement en cours...',
                      style: TextStyle(
                        color: AppColors.black,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    CircularProgressIndicator(
                      color: AppColors.blue700,
                      strokeWidth: 2,
                    ),
                  ],
                ),
              ),
            );
            Logger().i('Downloaded');
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Buttons(
          variant: Variante.secondary,
          size: SizeButton.md,
          msg: const Text('Modifier'),
          onPressed: () {
            setState(() {
              widget.model.changePage(1);
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Buttons(
          variant: Variante.delete,
          size: SizeButton.md,
          msg: const Text('Supprimer'),
          onPressed: () {
            setState(() {
              widget.model.changePage(2);
            });
          },
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ModifyPatient extends StatefulWidget {
  String name;
  final String id;
  final Function updatedata;
  ModifyPatient(
      {super.key,
      required this.name,
      required this.id,
      required this.updatedata});

  @override
  State<ModifyPatient> createState() => _ModifyPatientState();
}

class _ModifyPatientState extends State<ModifyPatient> {
  @override
  Widget build(BuildContext context) {
    int widthBtn = (screenSize.width / 2 - 32).toInt();
    int maxSize = (screenSize.width - 48).toInt();
    return ModalContainer(
      title: "Modifiez votre document",
      subtitle: "Modifier le nom de votre document",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.pen_fill,
          color: AppColors.grey700,
          size: 20,
        ),
        type: ModalType.info,
      ),
      body: [
        const Text('Le nouveau nom de votre document'),
        CustomField(
          label: 'Nom du document',
          value: widget.name,
          onChanged: (value) {
            setState(() {
              widget.name = value;
            });
          },
          maxSize: maxSize,
          action: TextInputAction.done,
        ),
      ],
      footer: Wrap(
        spacing: 12,
        children: [
          Buttons(
              variant: Variante.secondary,
              size: SizeButton.sm,
              msg: const Text('Annuler'),
              widthBtn: widthBtn,
              onPressed: () {
                pageIndex.value = 0;
              }),
          Buttons(
              variant: Variante.validate,
              size: SizeButton.sm,
              msg: const Text('Valider'),
              widthBtn: widthBtn,
              onPressed: () async {
                modifyDocument(widget.id, widget.name).then((value) {
                  widget.updatedata();
                  pageIndex.value = 0;
                  Navigator.pop(context);
                });
              }),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class DeletePatient extends StatefulWidget {
  String id;
  Function updatedata;
  DeletePatient({super.key, required this.id, required this.updatedata});

  @override
  State<DeletePatient> createState() => _DeletePatientState();
}

class _DeletePatientState extends State<DeletePatient> {
  @override
  Widget build(BuildContext context) {
    int widthBtn = (screenSize.width / 2 - 32).toInt();
    return ModalContainer(
      title: "Supprimer votre document",
      subtitle: "Êtes-vous sûr de vouloir supprimer ce document ?",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.x,
          color: AppColors.red700,
          size: 20,
        ),
        type: ModalType.error,
      ),
      footer: Row(
        children: [
          Flexible(
            child: Buttons(
              variant: Variante.secondary,
              size: SizeButton.sm,
              msg: const Text('Annuler'),
              widthBtn: widthBtn,
              onPressed: () {
                pageIndex.value = 0;
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: Buttons(
                variant: Variante.delete,
                size: SizeButton.sm,
                msg: const Text('Supprimer'),
                widthBtn: widthBtn,
                onPressed: () async {
                  deleteDocument(widget.id).then((value) {
                    widget.updatedata();
                    pageIndex.value = 0;
                    Navigator.pop(context);
                  });
                }),
          ),
        ],
      ),
    );
  }
}
