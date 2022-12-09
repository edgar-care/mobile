import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prototype_1/widget/button.dart';
import '../widget/appbar.dart';
import '../styles/colors.dart';
import '../widget/text.dart';

class LoginHintPage extends StatefulWidget {
  const LoginHintPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginHintPage> createState() => _LoginHintPageState();
}

class _LoginHintPageState extends State<LoginHintPage> {
  bool _isLogin = false;
  bool _isRegister = false;
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    void updateIsLogin() {
      setState(() {
        _isLogin = !_isLogin;
      });
    }

    void updateIsRegister() {
      setState(() {
        _isRegister = !_isRegister;
      });
    }

    void updateEmail(String value) {
      setState(() {
        _email = value;
      });
    }

    void updatePassword(String value) {
      setState(() {
        _password = value;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom(widget.title),
      body: SingleChildScrollView(
        dragStartBehavior: DragStartBehavior.down,
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (_isLogin == false && _isRegister == false) ...[
              const SizedBox(height: 118),
              const Text('Ce médecin va examiner votre analyse',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextWhithGradiant(
                  [
                    TextGradiant(' sous'),
                    TextGradiant('maximum 24h', isGrandiant: true),
                  ],
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 96),
              const Text('En attendant, je vous conseil de faire',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              TextWhithGradiant(
                  [
                    TextGradiant('une sieste dans un endroit'),
                    TextGradiant('calme', isGrandiant: true),
                    TextGradiant('et'),
                    TextGradiant('frais', isGrandiant: true),
                  ],
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 96),
              const Text('Pour que je puisse revenir vers vous',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              const Text('aun moyen de communiquer avec vous ?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 48),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: (() {
                        updateIsRegister();
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Créer un compte',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  ElevatedButton(
                      onPressed: (() {
                        updateIsLogin();
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              color: AppColors.blue200, width: 2),
                        ),
                      ),
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          color: AppColors.purple600,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ],
            if (_isLogin == true || _isRegister == true) ...[
              const SizedBox(height: 118),
              if (_isLogin == true) ...[
                const Center(
                    child: Text(
                  'Se connecter',
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.blue700,
                      fontWeight: FontWeight.bold),
                )),
              ],
              if (_isRegister == true) ...[
                const Center(
                    child: Text('S\'inscrire',
                        style: TextStyle(
                            fontSize: 20,
                            color: AppColors.blue700,
                            fontWeight: FontWeight.bold))),
              ],
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      fontSize: 18,
                    ),
                    focusColor: AppColors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        borderSide:
                            BorderSide(color: AppColors.blue400, width: 2)),
                    label: FaIcon(
                      FontAwesomeIcons.envelope,
                      color: AppColors.blue400,
                      size: 28,
                    ),
                    border: OutlineInputBorder(
                        gapPadding: 0,
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        borderSide:
                            BorderSide(color: AppColors.blue400, width: 2)),
                  ),
                  onChanged: (String value) {
                    updateEmail(value);
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 18,
                      ),
                      label: FaIcon(
                        FontAwesomeIcons.lock,
                        color: AppColors.blue400,
                        size: 28,
                        textDirection: TextDirection.ltr,
                      ),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide:
                              BorderSide(color: AppColors.blue400, width: 2)),
                    ),
                    onChanged: (String value) => {
                      updatePassword(value),
                    },
                  )),
              const SizedBox(height: 96),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: (() {
                        if (_isLogin == true) {
                          updateIsLogin();
                        } else {
                          if (_isRegister == true) {
                            updateIsRegister();
                          }
                        }
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              color: AppColors.blue200, width: 2),
                        ),
                      ),
                      child: const Text(
                        'Retour',
                        style: TextStyle(
                          color: AppColors.purple600,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  PrimaryButton(
                      'Valider',
                      'rdv',
                      const TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
