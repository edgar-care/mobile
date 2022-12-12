import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prototype_1/widget/cards.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../widget/appbar.dart';
import '../widget/button.dart';
import '../styles/colors.dart';

class StartTheAnalyse extends StatelessWidget {
  const StartTheAnalyse({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom(title, context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenue sur',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GradientText(
                  dotenv.env['APP_NAME']!,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.w700),
                  colors: const [
                    AppColors.blue500,
                    AppColors.pink500,
                  ],
                ),
              ],
            ),
            const Text(
              'votre assistant',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Vous allez commencez votre',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GradientText(
                  'analyse',
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.w700),
                  colors: const [
                    AppColors.blue500,
                    AppColors.pink500,
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 65,
            ),
            PrimaryCard(
                const [
                  'Cete sessionn n\'a pas pour but de',
                  'diagnostiquer une maladie',
                  'A l\'issue de votre session, votre prédiagnosic sera',
                  'transmis à votre médecin'
                ],
                const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 45,
            ),
            PrimaryButton(
                'Commencez mon analyse',
                'info',
                const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                context),
          ],
        ),
      ),
    );
  }
}
