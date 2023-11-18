import 'package:flutter/material.dart';
import 'package:medecin_mobile/styles/colors.dart';
import 'package:medecin_mobile/widgets/buttons.dart';
import 'package:medecin_mobile/widgets/field_custom.dart';
import 'package:medecin_mobile/services/login_service.dart';

class Login extends StatefulWidget {
  final Function(int) callback;
  const Login({Key? key, required this.callback}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: AppColors.blue700,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const SizedBox(height: 24),
                  Image.asset('assets/images/logo/new_white_logo.png', height: 60, width: 200),
                  const SizedBox(height: 24),
                  const SizedBox(
                    width: 320,
                    child : Text('Bienvenue sur la plateforme edgar', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(
                    width: 320,
                    child : Text('Connectez-vous pour accéder à votre espace médecin', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w500))
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Adresse mail", style: TextStyle(fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w600), textAlign: TextAlign.left,),
                      const SizedBox(height: 8,),
                      CustomField(
                        label: "prenom.nom@gmail.com",
                        keyboardType : TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text("Mot de passe", style: TextStyle(fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w600), textAlign: TextAlign.left ,),
                      const SizedBox(height: 8,),
                      CustomField(
                        label: "Minimum 8 caractères",
                        keyboardType: TextInputType.text,
                        isPassword: true,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      Buttons(
                        variant: Variante.primary,
                        msg: const Text("Se connecter"),
                        size: SizeButton.md,
                        onPressed: () {
                          login(email,password, context);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 64),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Vous n'êtes pas encore inscrit ?", style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
                      const SizedBox(height: 8,),
                      Buttons(
                        variant: Variante.secondary,
                        msg: const Text("Créer un compte"),
                        size: SizeButton.md,
                        onPressed: ()  {
                          //redirect page register
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],  
      ),
    );
  }
}