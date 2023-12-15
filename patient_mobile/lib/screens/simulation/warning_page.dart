import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/plain_button.dart';

class WarningPage extends StatefulWidget {
  const WarningPage({super.key});

  @override
  State<WarningPage> createState() => _WarningPageState();
}

class _WarningPageState extends State<WarningPage> with SingleTickerProviderStateMixin {
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/images/logo/full-width-colored-edgar-logo.png',
              width: 100,

            ),
            const SizedBox(height: 100),
            const Text(
              'Bienvenue sur edgar\nVotre assistant médical\nnumérique',
              style: TextStyle(
                color: AppColors.grey950,
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                leadingDistribution: TextLeadingDistribution.even,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            const Card(
              color: AppColors.blue100,
              elevation: 0,
              child : Padding(  
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                    'Cette session, n’a pas pour but de\ndiagnostiquer une maladie. À l’issue de\nla session, votre pré-diagnostic sera\ntransmis à un médecin pour être\nexaminé. Une réponse vous sera fournie\ndans un délai maximum de 48h',
                    style: TextStyle(
                      color: AppColors.grey950,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ),
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: PlainButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/chat');
                },
                text: 'Commencer mon analyse',
              ),
            ),
          ],
        ),
      ),
    );
  }
}