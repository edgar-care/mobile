import 'package:edgar_pro/screens/dashboard/patient_list_page.dart';
import 'package:edgar_pro/widgets/card_traitement_small.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class PatientInfoCard extends StatefulWidget {
  final BuildContext context;
  final List<dynamic> tmpTraitments;

  const PatientInfoCard(
      {super.key, required this.context, required this.tmpTraitments});

  @override
  // ignore: library_private_types_in_public_api
  _PatientInfoCardState createState() => _PatientInfoCardState();
}

class _PatientInfoCardState extends State<PatientInfoCard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        runAlignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          for (var i = 0; i < widget.tmpTraitments.length; i++)
            IntrinsicWidth(
                child: GestureDetector(
              onTap: () {
                if (widget.tmpTraitments[i]['treatments'].isEmpty) {
                  return;
                }
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
              },
              child: CardTraitementSmall(
                name: widget.tmpTraitments[i]['name'],
                isEnCours: widget.tmpTraitments[i]['treatments'].isEmpty
                    ? false
                    : true,
                withDelete: false,
                onTap: () {},
              ),
            )),
        ],
      ),
    );
  }
}
