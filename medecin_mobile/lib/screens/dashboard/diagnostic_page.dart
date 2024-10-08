import 'package:edgar/colors.dart';
import 'package:edgar_pro/widgets/Diagnostic/card_list.dart';
import 'package:edgar/widget.dart';
import 'package:flutter/material.dart';

class Diagnostic extends StatefulWidget {
  const Diagnostic({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DiagnosticState createState() => _DiagnosticState();
}

class _DiagnosticState extends State<Diagnostic> {
  ValueNotifier<int> selected = ValueNotifier(0);

  void updateSelection(int newSelection) {
    setState(() {
      selected.value = newSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          key: const ValueKey("Header"),
          decoration: BoxDecoration(
            color: AppColors.blue700,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(children: [
              Image.asset(
                "assets/images/logo/edgar-high-five.png",
                height: 40,
                width: 37,
              ),
              const SizedBox(
                width: 16,
              ),
              const Text(
                "Mes diagnostics",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: AppColors.white),
              ),
            ]),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        ValueListenableBuilder<int>(
            valueListenable: selected,
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Buttons(
                      variant: selected.value == 0
                          ? Variant.primary
                          : Variant.secondary,
                      size: SizeButton.sm,
                      msg: const Text('En attente'),
                      onPressed: () {
                        updateSelection(0);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: Buttons(
                      variant: selected.value == 1
                          ? Variant.primary
                          : Variant.secondary,
                      size: SizeButton.sm,
                      msg: const Text('Validés'),
                      onPressed: () {
                        updateSelection(1);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: Buttons(
                      variant: selected.value == 2
                          ? Variant.primary
                          : Variant.secondary,
                      size: SizeButton.sm,
                      msg: const Text('Refusés'),
                      onPressed: () {
                        updateSelection(2);
                      },
                    ),
                  ),
                ],
              );
            }),
        const SizedBox(
          height: 8,
        ),
        ValueListenableBuilder<int>(
            valueListenable: selected,
            builder: (context, value, child) {
              return DiagnosticList(type: selected.value);
            }),
      ],
    );
  }
}
