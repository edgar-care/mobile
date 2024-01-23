import 'package:flutter/material.dart';
import 'package:edgar/widget/navbar.dart';
import 'package:edgar/widget/plain_button.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Navbar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.0),
              child: Text(
                "Gagne du temps avec l’assistant\n virtuel du pré-diagnostic",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  leadingDistribution: TextLeadingDistribution.proportional,
                  overflow: TextOverflow.visible,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            Image.asset(
              'assets/images/logo/edgar-high-five.png',
              width: 110,
            ),
            const SizedBox(height: 30),
            const SizedBox(
              width: 300,
              child: Text(
                "Marre d’attendre pour avoir un rendez-vous  chez le médecin généraliste ? Un Français attend en moyenne 6 jours avant  d’avoir un rendez-vous chez un médecin généraliste",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  leadingDistribution: TextLeadingDistribution.proportional,
                  overflow: TextOverflow.visible,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            PlainButton(
                text: "Trouvez votre rendez-vous\ndès maintenant",
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                }),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/annuaire-medecin');
              },
              child: const Text(
                "Liste des Médecins Généralistes",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                  leadingDistribution: TextLeadingDistribution.proportional,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/help');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo/edgar-confused.png',
                    width: 40,
                  ),
                  const Text(
                    "Avez-vous des questions ?",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      leadingDistribution: TextLeadingDistribution.proportional,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
