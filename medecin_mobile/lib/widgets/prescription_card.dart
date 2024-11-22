import "package:bootstrap_icons/bootstrap_icons.dart";
import "package:download_file/data/models/download_file_options.dart";
import "package:download_file/download_file.dart";
import "package:edgar/colors.dart";
import "package:edgar/widget.dart";
import "package:edgar_pro/widgets/navbarplus.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class PrescriptionCard extends StatelessWidget {
  final String date;
  final String name;
  final String url;
  const PrescriptionCard(
      {super.key, required this.date, required this.name, required this.url});

  @override
  Widget build(BuildContext context) {
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
                    return ListModal(
                        model: model,
                        children: [downloadModal(context, name, url)]);
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
                    color: AppColors.green500,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(width: 8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  Text("Ajouté le $date",
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.grey500)),
                ]),
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
}

Widget downloadModal(BuildContext context, String name, String url) {
  return ModalContainer(
    body: [
      Text(
        name,
        style: const TextStyle(
            fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 4),
      Container(
        color: AppColors.blue100,
        height: 1,
      ),
      NavbarPLusTab(
        title: 'Télécharger',
        onTap: () {
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
        },
        type: 'Only',
        icon: const Icon(
          BootstrapIcons.download,
          color: AppColors.blue800,
          size: 16,
        ),
      ),
      Container(
        color: AppColors.blue100,
        height: 1,
      ),
    ],
  );
}
