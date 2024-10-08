import 'package:edgar/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edgar_pro/screens/auth/login_page.dart';

void main() {
  testWidgets('Test de la page de login', (WidgetTester tester) async {
    // Créez l'instance de la page de connexion
    // ignore: avoid_types_as_parameter_names
    final loginPage = MaterialApp(home: Login(callback: (int) {
      1;
    }));
    // Ajoutez la page de connexion à l'arborescence des widgets
    await tester.pumpWidget(loginPage);

    // Vérifiez si les éléments sont présents sur la page
    expect(find.text('Adresse mail'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('Vous n\'êtes pas encore inscrit ?'), findsOneWidget);
    expect(find.text('Créer un compte'), findsOneWidget);

    // Vérifiez si les champs de texte sont vides
    expect(find.widgetWithText(CustomField, ''), findsNWidgets(2));

    // Remplissez les champs de texte
    await tester.enterText(
        find.widgetWithText(CustomField, 'prenom.nom@gmail.com').first,
        'test@example.com');
    await tester.enterText(
        find.widgetWithText(CustomField, 'Minimum 8 caractères').last,
        'password123');

    // Vérifiez si la navigation vers la page d'aide a été effectuée
  });
}
