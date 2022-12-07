import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../widget/appbar.dart';
import '../widget/button.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(title),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Avant de commencer, j\'ai besoin de',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GradientText(
                ' quelques informations',
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w700),
                colors: const [
                  Color.fromRGBO(22, 54, 217, 1),
                  Color.fromRGBO(217, 22, 186, 1),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              const Text('Je suis un.e',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          index = 0;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            index == 0 ? enableColor : disableColor,
                      ),
                      child: Text('Homme')),
                  const SizedBox(width: 10),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          index = 1;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            index == 0 ? enableColor : disableColor,
                      ),
                      child: Text('Femme'))
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              const Text('Quel est votre âge ?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
              Container(
                color: Colors.grey,
                child: SizedBox(
                  width: 200,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Votre âge',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text('Quel est votre taille ? (en cm))',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
              Container(
                color: Colors.grey,
                child: SizedBox(
                  width: 200,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Votre taille',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text('Quel est votre poids ?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
              Container(
                color: Colors.grey,
                child: SizedBox(
                  width: 200,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Votre poids',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              PrimaryButton(
                  'Valider mes informations',
                  'info',
                  const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )),
            ]),
          ),
        ));
  }

}

void setState(Null Function() param0) {
}

Color disableColor = Colors.red;
Color enableColor = Color.fromRGBO(73, 101, 242, 1);
int index = -1;
