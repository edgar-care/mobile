import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../widget/appbar.dart';
import '../widget/button.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom(title),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    Color.fromRGBO(22, 54, 217, 1),
                    Color.fromRGBO(217, 22, 186, 1),
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
                    Color.fromRGBO(22, 54, 217, 1),
                    Color.fromRGBO(217, 22, 186, 1),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 65,
            ),
            PrimaryButton(
                'Commencer mon analyse',
                'home',
                const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                )),
          ],
        ),
      ),
    );
  }
}
