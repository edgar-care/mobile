import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototype_1/screens/login.dart';

void main() {
  testWidgets('Test de la page de login', (WidgetTester tester) async {
    // Créez l'instance de la page de connexion
    const loginPage = MaterialApp(home: Login());

    // Ajoutez la page de connexion à l'arborescence des widgets
    await tester.pumpWidget(loginPage);

    // Vérifiez si les éléments sont présents sur la page
    expect(find.text('Adresse mail'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Pas encore inscrit ?'), findsOneWidget);
    expect(find.text('Enregistrez-vous'), findsOneWidget);

    // Vérifiez si les champs de texte sont vides
    expect(find.widgetWithText(TextFormField, ''), findsNWidgets(2));

    // Remplissez les champs de texte
    await tester.enterText(
        find.widgetWithText(TextFormField, '').first, 'test@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, '').last, 'password123');

    // Vérifiez si la navigation vers la page d'aide a été effectuée
  });
}
