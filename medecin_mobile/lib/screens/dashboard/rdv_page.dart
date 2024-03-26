import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/rdv/custom_list_old.dart';
import 'package:edgar_pro/widgets/rdv/custom_list_rdv.dart';
import 'package:flutter/material.dart';

class Rdv extends StatefulWidget {
  const Rdv({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RdvState createState() => _RdvState();
}

class _RdvState extends State<Rdv> {
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
            child: Row(
              children: [
                Image.asset("assets/images/logo/edgar-high-five.png",height: 40,width: 37,),
                const SizedBox(width: 16,),
                const Text("Mes rendez-vous", style: TextStyle(fontSize: 20, fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: AppColors.white),
                ),
            ]),
          ),
        ),
        const SizedBox(height: 16,),
        ValueListenableBuilder<int>(
                  valueListenable: selected,
                  builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.445,
                    child: Buttons(
                      variant: selected.value == 0 ? Variante.primary : Variante.secondary,
                      size: SizeButton.sm,
                      msg: const Text('Prochain rendez-vous'),
                      onPressed: () {
                        updateSelection(0);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.445,
                    child: Buttons(
                      variant: selected.value == 1 ? Variante.primary : Variante.secondary,
                      size: SizeButton.sm,
                      msg: const Text('Rendez-vous passés'),
                      onPressed: () {
                        updateSelection(1);
                      },
                    ),
                  ),
                ],
              );
              }),

        const SizedBox(height: 8,),
         ValueListenableBuilder<int>(
                  valueListenable: selected,
                  builder: (context, value, child) {
                return selected.value == 0 ? const CustomListRdv() : const CustomListOld();
          }),
      ],
    );
  }
}