// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:edgar/widget/field_custom.dart';
import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:logger/logger.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:edgar/widget/buttons.dart';
import 'package:http/http.dart' as http;
import 'package:edgar/services/get_files.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

enum TypeDeDocument {
  PRESCRIPTION,
  OTHER,
  CERTIFICATE,
  XRAY,
}

// ignore: must_be_immutable
class CardDocument extends StatefulWidget {
  final TypeDeDocument typeDeDocument;
  final String nomDocument;
  final DateTime dateDocument;
  final String nameDoctor;
  bool isfavorite;
  String id;
  String url;
  CardDocument(
      {super.key,
      required this.typeDeDocument,
      required this.nomDocument,
      required this.dateDocument,
      required this.nameDoctor,
      required this.isfavorite,
      required this.id,
      required this.url});

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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.blue200, width: 2),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            GestureDetector(
              onTap: () {
                changeFavorite(widget.id);
                setState(() {
                  widget.isfavorite = !widget.isfavorite;
                });
              },
              child: Container(
                child: widget.isfavorite
                    ? const Icon(Icons.star, color: AppColors.blue300)
                    : const Icon(Icons.star_border, color: AppColors.blue300),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 4,
              height: 50,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: documentColor(widget.typeDeDocument),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nomDocument,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: constraints.maxWidth * 0.7,
                      child: Text(
                        "Ajouté le ${widget.dateDocument.day}/${widget.dateDocument.month}/${widget.dateDocument.year} par ${widget.nameDoctor}",
                        style: const TextStyle(
                          color: AppColors.black,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    WoltModalSheet.show<void>(
                        context: context,
                        pageIndexNotifier: pageIndex,
                        pageListBuilder: (modalSheetContext) {
                          return [
                            openPatient(
                              context,
                              pageIndex,
                              widget.url,
                              widget.id,
                              widget.nomDocument,
                            ),
                            modifierPatient(context, pageIndex,
                                widget.nomDocument, widget.id),
                            deletePatient(context, pageIndex, widget.id),
                          ];
                        });
                  },
                  child: const Icon(
                    BootstrapIcons.three_dots_vertical,
                    color: AppColors.black,
                    size: 24,
                  ),
                ),
              ],
            ),
          ]),
        );
      },
    );
  }
}

final pageIndex = ValueNotifier(0);

Future<File> downloadFile(String url, String savePath) async {
  var response = await http.get(Uri.parse(url));
  var file = File(savePath);
  await file.writeAsBytes(response.bodyBytes);
  return file;
}

WoltModalSheetPage openPatient(
  BuildContext context,
  ValueNotifier<int> pageIndex,
  String url,
  String id,
  String name,
) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          Buttons(
              variant: Variante.primary,
              size: SizeButton.sm,
              msg: const Text('Télécharger'),
              onPressed: () async {
                FileDownloader.downloadFile(
                  url: url,
                  name: name,
                  onDownloadCompleted: (String id) {
                    Logger().i('Télécharger');
                  },
                  onDownloadError: (String error) {
                    Logger().e(error);
                  },
                  notificationType: NotificationType.all,
                );
              }),
          Buttons(
              variant: Variante.secondary,
              size: SizeButton.sm,
              msg: const Text('Modifier'),
              onPressed: () {
                pageIndex.value = 1;
              }),
          Buttons(
              variant: Variante.delete,
              size: SizeButton.sm,
              msg: const Text('Supprimer'),
              onPressed: () {
                pageIndex.value = 2;
              }),
        ],
      ),
    ),
  );
}

WoltModalSheetPage modifierPatient(
  BuildContext context,
  ValueNotifier<int> pageIndex,
  String name,
  String id,
) {
  int widthBtn = (MediaQuery.of(context).size.width / 2 - 32).toInt();
  int maxSize = (MediaQuery.of(context).size.width - 48).toInt();
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 32,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
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
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  BootstrapIcons.pen_fill,
                  color: AppColors.grey700,
                  size: 16,
                ),
              ),
              const Text(
                'Modifiez votre document',
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            direction: Axis.vertical,
            children: [
              const Text('Le nouveau nom de votre document'),
              CustomField(
                label: 'Nom du document',
                value: name,
                onChanged: (value) {
                  name = value;
                },
                maxSize: maxSize,
              ),
            ],
          ),
          Wrap(
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
                  onPressed: () {
                    modifyDocument(id, name);
                    pageIndex.value = 0;
                  }),
            ],
          ),
        ],
      ),
    ),
  );
}

WoltModalSheetPage deletePatient(
  BuildContext context,
  ValueNotifier<int> pageIndex,
  String id,
) {
  int widthBtn = (MediaQuery.of(context).size.width / 2 - 32).toInt();
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 32,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
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
                  color: AppColors.red200,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  BootstrapIcons.x,
                  color: AppColors.red700,
                  size: 32,
                ),
              ),
              const Text(
                'Supprimer votre document',
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text('Êtes-vous sûr de vouloir supprimer ce document ?',
                  style: TextStyle(
                    color: AppColors.grey400,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center),
            ],
          ),
          Wrap(
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
                  variant: Variante.delete,
                  size: SizeButton.sm,
                  msg: const Text('Supprimer'),
                  widthBtn: widthBtn,
                  onPressed: () {
                    deleteDocument(id);
                    pageIndex.value = 0;
                    Navigator.pop(context);
                  }),
            ],
          ),
        ],
      ),
    ),
  );
}
