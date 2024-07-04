import 'package:edgar_pro/screens/dashboard/patient_list_page.dart';
import 'package:edgar_pro/widgets/card_traitement_small.dart';
import 'package:edgar_pro/widgets/custom_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                final model =
                    Provider.of<BottomSheetModel>(context, listen: false);
                model.resetCurrentIndex();

                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) {
                    return Consumer<BottomSheetModel>(
                      builder: (context, model, child) {
                        return ListModal(model: model, children: [
                          InfoTreatment(
                            traitement: widget.tmpTraitments[i],
                          )
                        ]);
                      },
                    );
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
