import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/styles/colors.dart';

class PatientInfoCard extends StatefulWidget {
  final BuildContext context;
  final Map<String, dynamic> patient;
  final String champ;
  final bool isDeletable;

  const PatientInfoCard({
    super.key,
    required this.context,
    required this.patient,
    required this.champ,
    required this.isDeletable,
  });

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
          for (var i = 0; i < widget.patient[widget.champ].length; i++)
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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      widget.patient[widget.champ][i],
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                    ),
                    if (widget.isDeletable)
                      GestureDetector(
                        child: const Icon(
                          BootstrapIcons.x,
                          color: AppColors.black,
                        ),
                        onTap: () {
                          setState(() {
                            widget.patient[widget.champ].removeAt(i);
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
