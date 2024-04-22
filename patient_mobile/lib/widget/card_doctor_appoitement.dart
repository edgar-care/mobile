import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class CardAppointementDoxtorHour extends StatefulWidget {
  final Map<String, dynamic> appointements;
  const CardAppointementDoxtorHour({super.key, required this.appointements});

  @override
  State<CardAppointementDoxtorHour> createState() =>
      _CardAppointementDoxtorHourState();
}

class _CardAppointementDoxtorHourState
    extends State<CardAppointementDoxtorHour> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr', null);
  }

  final ValueNotifier<int> pageIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        width: double.infinity,
        height: 318,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.blue200,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.appointements["doctor"],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: AppColors.black,
              ),
            ),
            Text(
              widget.appointements["address"].split(', ')[1],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: AppColors.black,
              ),
            ),
            Text(
              widget.appointements["address"].split(', ')[0],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: AppColors.black,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const Divider(
              color: AppColors.blue200,
              thickness: 2,
            ),
            const SizedBox(
              height: 4,
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.appointements["date"].length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color:
                              index == widget.appointements["date"].length - 1
                                  ? AppColors.white
                                  : AppColors.blue200,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('EEEE', 'fr').format(
                              DateFormat('dd/MM/yyyy').parse(
                                  widget.appointements["date"][index]["day"])),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMMM', 'fr').format(
                              DateFormat('dd/MM/yyyy').parse(
                                  widget.appointements["date"][index]["day"])),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        for (var hour in widget.appointements["date"][index]
                                ["hour"]
                            .take(3))
                          HourItem(
                            hour: hour,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Buttons(
                variant: Variante.secondary,
                size: SizeButton.sm,
                msg: const Text("Voir plus d'horaires"),
                onPressed: () {
                  WoltModalSheet.show<void>(
                      context: context,
                      pageIndexNotifier: pageIndex,
                      pageListBuilder: (modalSheetContext) {
                        return [
                          seeMore(context, widget.appointements),
                        ];
                      });
                }),
          ],
        ));
  }
}

WoltModalSheetPage seeMore(
  BuildContext context,
  final Map<String, dynamic> appointements,
) {
  return WoltModalSheetPage(
    hasTopBarLayer: false,
    backgroundColor: AppColors.white,
    hasSabGradient: true,
    enableDrag: true,
    child: BodySeeMore(appointements: appointements),
  );
}

class BodySeeMore extends StatefulWidget {
  final Map<String, dynamic> appointements;
  const BodySeeMore({super.key, required this.appointements});

  @override
  State<BodySeeMore> createState() => _BodySeeMoreState();
}

class _BodySeeMoreState extends State<BodySeeMore> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.appointements["date"].length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color:
                              index == widget.appointements["date"].length - 1
                                  ? AppColors.white
                                  : AppColors.blue200,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('EEEE', 'fr').format(
                              DateFormat('dd/MM/yyyy').parse(
                                  widget.appointements["date"][index]["day"])),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMMM', 'fr').format(
                              DateFormat('dd/MM/yyyy').parse(
                                  widget.appointements["date"][index]["day"])),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        for (var hour in widget.appointements["date"][index]
                            ["hour"])
                          HourItem(
                            hour: hour,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Buttons(
              variant: Variante.primary,
              size: SizeButton.sm,
              msg: const Text("Valider le rendez-vous"),
              onPressed: () {
                Navigator.pushNamed(context, '/simulation/confirmation');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HourItem extends StatefulWidget {
  final String hour;
  const HourItem({super.key, required this.hour});

  @override
  State<HourItem> createState() => _HourItemState();
}

class _HourItemState extends State<HourItem> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTapped = !isTapped;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isTapped ? AppColors.blue700 : AppColors.blue200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          widget.hour,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: isTapped ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
