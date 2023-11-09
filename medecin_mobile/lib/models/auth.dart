import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../styles/colors.dart';
import 'package:medecin_mobile/widgets/buttons.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body : Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo/small-width-blue-edgar-logo.png', width: 200),
              const SizedBox(height: 128),
              const Text('Exemple de buttons et\nexemple d\'utilisation de logger', style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue700,
                  fontFamily: 'Poppins'
                ),
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Buttons(
                variant: Variante.secondary,
                size: SizeButton.md,
                msg: const Text("Au click regarde dans la console!"),
                onPressed: () {
                  Logger().i("Bouton cliqué");
                },
              ),
            ],
          ),
        )
    ); 
  }
}