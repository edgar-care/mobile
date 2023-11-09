import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototype_1/screens/landingPage/help.dart';

void main() {
  testWidgets('Test fonctionnel pour HelpScreen', (WidgetTester tester) async {
    // Créez l'instance de HelpScreen
    const helpScreen = MaterialApp(home: HelpScreen());

    // Ajoutez HelpScreen au widget tree
    await tester.pumpWidget(helpScreen);

    // Vérifiez si l'adresse mail et la question sont présentes
    expect(find.text('Adresse mail :'), findsOneWidget);
    expect(find.text('Question :'), findsOneWidget);

    // Vérifiez si les champs de texte sont présents

    // Vérifiez si les QuestionsCard sont présentes
    expect(find.byType(QuestionsCard), findsNWidgets(2));

    // Vérifiez si les questions et réponses sont présentes dans les QuestionsCard
    expect(find.text("Que ce passe-t-il si le rendez-vous n'est pas utile ?"),
        findsNWidgets(1));
    expect(
        find.text(
            "Si le médecin juge que le rendez-vous n'est pas utile, le rendez-vous sera annulé et vous recevrez un message avec toutes les informations liées à l'annulation avec un motif et une solution pour calmer vos symptômes"),
        findsNWidgets(1));
  });
}
