import 'package:flutter/material.dart';
import 'package:medecin_mobile/styles/colors.dart';
import 'package:medecin_mobile/widgets/buttons.dart';
import 'package:medecin_mobile/widgets/custom_patient_list.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class Patient extends StatelessWidget {
  const Patient({Key? key}) : super(key: key);

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
                    child: Row (
                      children: [
                        Image.asset("assets/images/logo/edgar-high-five.png", height: 40, width: 37,),
                        const SizedBox(width: 16,),
                        const Text("Ma patientèle", style: TextStyle(fontSize: 20, fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: AppColors.white),),
                    ]
                  ),
                ),
              ),
              const SizedBox(height: 8,),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.77,
                width: MediaQuery.of(context).size.width,
                child:
                  Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.blue200, width: 2) 
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomList(),
                        Buttons(
                          variant: Variante.primary,
                          size: SizeButton.md,
                          msg: const Text('Ajouter un patient'),
                          onPressed: () {
                             WoltModalSheet.show<void>(context: context, pageListBuilder: (modalSheetContext){
                              return [const CustomList().addPatient(context)];
                             });
                          },
                        ),
                      ]),
                ),
                  ),
              ),
              
          ],);
    }
}