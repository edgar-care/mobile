import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototype_1/screens/auth.dart';

void main() {
  testWidgets('Test fonctionnel pour AuthScreen', (WidgetTester tester) async {
    // Créez l'instance de AuthScreen
    const AuthScreen authScreen = AuthScreen();

    // Construisez l'arbre de widgets avec AuthScreen
    await tester.pumpWidget(MaterialApp(home: authScreen));

    // Vérifiez si le logo est présent
    expect(find.byType(Image), findsNWidgets(2));

    // Vérifiez si le bouton "Enregistrez-vous" est présent
    expect(find.text('Enregistrez-vous'), findsOneWidget);

    // Vérifiez si le texte "ou\nconnectez-vous avec" est présent
    expect(find.text('ou\nconnectez-vous avec'), findsOneWidget);
  });
}
