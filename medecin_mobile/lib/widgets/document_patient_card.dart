import 'dart:io';
import 'package:download_file/data/models/download_file_options.dart';
import 'package:download_file/download_file.dart';
import 'package:http/http.dart' as http;
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DocumentPatientCard extends StatelessWidget {
  final String type;
  final String date;
  final String name;
  final String url;
  DocumentPatientCard(
      {super.key,
      required this.type,
      required this.date,
      required this.name,
      required this.url});
  Color? color;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'XRAY':
        color = AppColors.green300;
        break;
      case 'PRESCRIPTION':
        color = AppColors.green500;
        break;
      case 'CERTIFICATE':
        color = AppColors.blue700;
        break;
      default:
        color = AppColors.blue200;
    }
    return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.blue200,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () {
            final model = Provider.of<BottomSheetModel>(context, listen: false);
            model.resetCurrentIndex();

            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) {
                return Consumer<BottomSheetModel>(
                  builder: (context, model, child) {
                    return ListModal(model: model, children: [
                      modal(context, name, date, url),
                    ]);
                  },
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
            child: Row(
              children: [
                Container(
                  height: 35,
                  width: 4,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(width: 8),
                Text(name,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                const Icon(
                  BootstrapIcons.chevron_right,
                  size: 17,
                )
              ],
            ),
          ),
        ));
  }

  Future<File> downloadFile(String url, String savePath) async {
    var response = await http.get(Uri.parse(url));
    var file = File(savePath);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Widget modal(BuildContext context, String name, String date, String url) {
    return ModalContainer(
      title: name,
      subtitle: "Voulez vous télécharger ce document",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.download,
          size: 18,
          color: AppColors.grey600,
        ),
        type: ModalType.info,
      ),
      footer: Buttons(
          variant: Variant.primary,
          size: SizeButton.sm,
          msg: const Text(
            'Télécharger le document',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            DownloadFile.downloadAndSafeFile(
              downloadFileOptions: DownloadFileOptions(
                downloadUrl: url,
                fileName: name,
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
          }),
    );
  }
}
