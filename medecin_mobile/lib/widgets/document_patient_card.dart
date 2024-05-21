import 'dart:io';
import 'package:download_file/data/models/download_file_options.dart';
import 'package:download_file/download_file.dart';
import 'package:http/http.dart' as http;
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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
            WoltModalSheet.show(
              context: context,
              pageListBuilder: (BuildContext context) {
                return [modal(context, name, date, url)];
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

  SliverWoltModalSheetPage modal(
      BuildContext context, String name, String date, String url) {
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(children: [
          Text(
            name,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(height: 2, color: AppColors.blue200),
          const SizedBox(height: 12),
          Buttons(
              variant: Variante.primary,
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
        ]),
      ),
    );
  }
}
