// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:edgar/widget/buttons.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

enum TypeDeDocument {
  ORDONNANCE,
  AUTRE,
  CERTIFICAT,
  RADIO,
}

// ignore: must_be_immutable
class CardDocument extends StatefulWidget {
  final TypeDeDocument typeDeDocument;
  final String nomDocument;
  final DateTime dateDocument;
  final String nameDoctor;
  File file;
  CardDocument(
      {super.key,
      required this.typeDeDocument,
      required this.nomDocument,
      required this.dateDocument,
      required this.nameDoctor,
      required this.file});

  @override
  State<CardDocument> createState() => _CardDocumentState();
}

class _CardDocumentState extends State<CardDocument> {
  bool _isfavorite = false;
  Color documentColor(TypeDeDocument typeDeDocument) {
    switch (typeDeDocument) {
      case TypeDeDocument.ORDONNANCE:
        return AppColors.green500;
      case TypeDeDocument.AUTRE:
        return AppColors.blue200;
      case TypeDeDocument.CERTIFICAT:
        return AppColors.blue700;
      case TypeDeDocument.RADIO:
        return AppColors.green200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.blue200, width: 2),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isfavorite = !_isfavorite;
                });
              },
              child: Container(
                child: _isfavorite
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
                    Text(
                      "Ajouté le ${widget.dateDocument.day}/${widget.dateDocument.month}/${widget.dateDocument.year} par ${widget.nameDoctor}",
                      style: const TextStyle(
                        color: AppColors.black,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
                              widget.file,
                            ),
                          ];
                        });
                  },
                  child: const Icon(
                    BootstrapIcons.three_dots_vertical,
                    color: AppColors.black,
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

WoltModalSheetPage openPatient(
  BuildContext context,
  ValueNotifier<int> pageIndex,
  File? file,
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
                  url: file.toString().substring(7, file.toString().length - 1),
                );
              }),
          Buttons(
              variant: Variante.secondary,
              size: SizeButton.sm,
              msg: const Text('Modifier'),
              onPressed: () {}),
          Buttons(
              variant: Variante.delete,
              size: SizeButton.sm,
              msg: const Text('Supprimer'),
              onPressed: () {}),
        ],
      ),
    ),
  );
}
