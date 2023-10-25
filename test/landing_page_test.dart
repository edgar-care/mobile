import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototype_1/screens/landingPage/landing_page.dart';

void main() {
  testWidgets('Test fonctionnel de la page d\'accueil',
      (WidgetTester tester) async {
    // Créez l'instance de la page d'accueil
    const landingPage = MaterialApp(home: LandingPage());

    // Ajoutez la page d'accueil à l'arborescence des widgets
    await tester.pumpWidget(landingPage);

    // Vérifiez si le texte "Gagne du temps avec l’assistant\n virtuel du pré-diagnostic" est présent
    expect(
        find.text(
            "Gagne du temps avec l’assistant\n virtuel du pré-diagnostic"),
        findsOneWidget);

    // Vérifiez si le bouton "Trouvez votre rendez-vous\ndès maintenant" est présent
    expect(
        find.text("Trouvez votre rendez-vous\ndès maintenant"), findsOneWidget);

    // Vérifiez si le texte "Liste des Médecins Généralistes" est présent
    expect(find.text("Liste des Médecins Généralistes"), findsOneWidget);

    // Vérifiez si le texte "Avez des questions ?" est présent
    expect(find.text("Avez-vous des questions ?"), findsOneWidget);
  });
}
