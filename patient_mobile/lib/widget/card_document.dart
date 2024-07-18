// ignore_for_file: constant_identifier_names

import 'package:download_file/data/models/download_file_options.dart';
import 'package:download_file/download_file.dart';
import 'package:edgar/widget.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:logger/logger.dart';
import 'package:edgar/colors.dart';
import 'package:Edgar/services/get_files.dart';
import 'package:provider/provider.dart';

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
                            id: widget.id,
                            isfavorite: widget.isfavorite,
                            model: model,
                            name: widget.nomDocument,
                            url: widget.url,
                          ),
                          ModifyPatient(
                            id: widget.id,
                            model: model,
                            name: widget.nomDocument,
                            updatedata: widget.updatedata,
                          ),
                          DeletePatient(
                            id: widget.id,
                            updatedata: widget.updatedata,
                          )
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

// ignore: must_be_immutable
class OpenPatient extends StatefulWidget {
  String url;
  String id;
  bool isfavorite;
  String name;
  BottomSheetModel model;
  OpenPatient({
    super.key,
    required this.id,
    required this.isfavorite,
    required this.model,
    required this.name,
    required this.url,
  });

  @override
  State<OpenPatient> createState() => _OpenPatientState();
}

class _OpenPatientState extends State<OpenPatient> {
  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Séléctionner une catégorie",
      subtitle: "Voulez vous télécharger, modifier, ou supprimer le document",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.download,
          size: 18,
          color: AppColors.blue700,
        ),
        type: ModalType.info,
      ),
      body: [
        Buttons(
          variant: Variant.primary,
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
          variant: Variant.secondary,
          size: SizeButton.md,
          msg: const Text('Modifier'),
          onPressed: () {
            widget.model.changePage(1);
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Buttons(
          variant: Variant.delete,
          size: SizeButton.md,
          msg: const Text('Supprimer'),
          onPressed: () {
            widget.model.changePage(2);
          },
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ModifyPatient extends StatefulWidget {
  String name;
  String id;
  Function updatedata;
  BottomSheetModel model;
  ModifyPatient({
    super.key,
    required this.id,
    required this.model,
    required this.name,
    required this.updatedata,
  });

  @override
  State<ModifyPatient> createState() => _ModifyPatientState();
}

class _ModifyPatientState extends State<ModifyPatient> {
  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Modifier votre document",
      subtitle: "Changer le nom de votre document",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.pen_fill,
          color: AppColors.green700,
          size: 18,
        ),
        type: ModalType.success,
      ),
      body: [
        const Text('Le nouveau nom de votre document'),
        const SizedBox(
          width: 8,
        ),
        CustomField(
          label: 'Nom du document',
          value: widget.name,
          onChanged: (value) {
            widget.name = value;
          },
          action: TextInputAction.done,
        ),
      ],
      footer: Wrap(
        spacing: 12,
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
          Flexible(
            child: Buttons(
              variant: Variant.validate,
              size: SizeButton.sm,
              msg: const Text('Valider'),
              onPressed: () async {
                modifyDocument(widget.id, widget.name).then((value) {
                  widget.updatedata();
                  Navigator.pop(context);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class DeletePatient extends StatelessWidget {
  String id;
  Function updatedata;
  DeletePatient({super.key, required this.id, required this.updatedata});

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Supprimer votre document",
      subtitle: 'Êtes-vous sûr de vouloir supprimer ce document ?',
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.x,
          color: AppColors.red700,
          size: 18,
        ),
        type: ModalType.error,
      ),
      footer: Wrap(
        spacing: 12,
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
          Flexible(
            child: Buttons(
              variant: Variant.delete,
              size: SizeButton.sm,
              msg: const Text('Supprimer'),
              onPressed: () async {
                deleteDocument(id).then(
                  (value) {
                    updatedata();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
