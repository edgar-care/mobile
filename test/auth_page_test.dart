import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototype_1/screens/register.dart';

void main() {
  testWidgets('Test fonctionnel pour lib/screens/register.dart', (WidgetTester tester) async {
    // Créez l'instance de l'application et ajoutez la page Register
    await tester.pumpWidget( const MaterialApp(home: Register()));

    // Vérifiez si le logo est présent
    expect(find.byType(Image), findsOneWidget);

    // Vérifiez si les champs de texte sont présents
    expect(find.byType(TextFieldBlock), findsOneWidget);
    expect(find.byType(PasswordTextFieldBlock), findsOneWidget);


    // Vérifiez si le texte "Déjà inscrit ?" est présent
    expect(find.text('Déjà inscrit ?'), findsOneWidget);
  });
}