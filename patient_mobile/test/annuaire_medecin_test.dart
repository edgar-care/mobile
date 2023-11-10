import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototype_1/screens/landingPage/annuaire_medecin.dart';

void main() {
  testWidgets(
      'Vérifier la présence de la barre de recherche et du bouton "Rechercher"',
      (WidgetTester tester) async {
    // Créer l'application et ajouter la page AnnuaireMedecin
    await tester.pumpWidget(const MaterialApp(home: AnnuaireMedecin()));

    // Vérifier que la barre de recherche est présente
    expect(find.byType(TextField), findsOneWidget);

    // Vérifier que le bouton "Rechercher" est présent
    expect(find.text('Rechercher'), findsOneWidget);
  });
}
