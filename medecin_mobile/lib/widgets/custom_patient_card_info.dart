import 'package:edgar_pro/screens/dashboard/patient_list_page.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class PatientInfoCard extends StatefulWidget {
  final BuildContext context;
  List<dynamic> tmpTraitments;

  PatientInfoCard(
      {super.key, required this.context, required this.tmpTraitments});

  @override
  // ignore: library_private_types_in_public_api
  _PatientInfoCardState createState() => _PatientInfoCardState();
}

class _PatientInfoCardState extends State<PatientInfoCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.80,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 8,
        direction: Axis.horizontal,
        children: [
          for (var i = 0; i < widget.tmpTraitments.length; i++)
            Card(
              elevation: 0,
              margin: const EdgeInsets.all(0),
              color: AppColors.blue50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(
                  color: AppColors.blue200,
                  width: 2,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  if (widget.tmpTraitments[i].isNotEmpty) {
                    WoltModalSheet.show<void>(
                      context: context,
                      pageListBuilder: (modalSheetContext) {
                        return [
                          infoTraitement(
                            context,
                            widget.tmpTraitments[i],
                          ),
                        ];
                      },
                    );
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        widget.tmpTraitments[i]['name'],
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
