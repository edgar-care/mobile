// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      Navigator.pushNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue700,
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 32,
          ),
          SvgPicture.asset("assets/images/logo/newLogosvg.svg"),
          const Spacer(),
          Image.asset("assets/images/logo/edgar_cut.png"),
          Container(
            padding: const EdgeInsets.all(32),
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              border: Border(
                top: BorderSide(color: AppColors.blue200, width: 2),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue700,
                  spreadRadius: -1.0,
                  blurRadius: 4,
                  offset: Offset(0, -1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "Gagne du temps avec l'assistant virtuel du pré-diagnostic",
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  "Accéder à votre espace patient, gérer vos rendez-vous et bien plus",
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 42,
                ),
                GestureDetector(
                  onTap: () {
                    final model =
                        Provider.of<BottomSheetModel>(context, listen: false);
                    model.resetCurrentIndex();

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Consumer<BottomSheetModel>(
                          builder: (context, model, child) {
                            return ListModal(
                              model: model,
                              children: [
                                ModalRegister(
                                  model: model,
                                  isRegister: true,
                                ),
                                ModalLogin(
                                  model: model,
                                  isLogin: false,
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: AppColors.white,
                      ),
                      child: const Center(
                        child: Text(
                          "Inscription",
                          style: TextStyle(
                            color: AppColors.blue700,
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    final model =
                        Provider.of<BottomSheetModel>(context, listen: false);
                    model.resetCurrentIndex();

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Consumer<BottomSheetModel>(
                          builder: (context, model, child) {
                            return ListModal(
                              model: model,
                              children: [
                                ModalLogin(
                                  model: model,
                                  isLogin: true,
                                ),
                                ModalRegister(model: model, isRegister: false)
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: AppColors.blue700,
                        border: Border.all(color: AppColors.white, width: 2)),
                    child: const Center(
                      child: Text(
                        "Connexion",
                        style: TextStyle(
                          color: AppColors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}

class ModalContainerTest extends StatelessWidget {
  /// Tittle of the modal
  final String title;

  /// Icon de la modal
  final Widget icon;

  /// Subtittle of the modal
  final String subtitle;

  /// The body of the modal
  final List<Widget>? body;

  /// The footer of the modal
  final Widget? footer;

  /// Required Tittle, subtittle, and Icon
  const ModalContainerTest({
    super.key,
    required this.title,
    required this.subtitle,
    this.body,
    this.footer,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        // padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon,
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.close),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                height: 1.5,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                color: Colors.black,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                height: 1.5,
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                color: AppColors.grey700,
              ),
              softWrap: true,
            ),
            if (body != null) ...[
              const SizedBox(height: 24),
              SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(), // Optional: Add bounce effect
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        264, // Adjust as needed
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: body!,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }
}

class ModalLogin extends StatefulWidget {
  final BottomSheetModel model;
  final bool isLogin;
  const ModalLogin({super.key, required this.model, required this.isLogin});

  @override
  State<ModalLogin> createState() => _ModalLoginState();
}

class _ModalLoginState extends State<ModalLogin> {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return ModalContainerTest(
      title: "Bon retour sur la plateforme edgar",
      subtitle:
          "Connectez-vous avec votre compte pour accéder à votre espace patient, gérer vos rendez-vous et bien plus.",
      icon: IconModal(
        icon: SvgPicture.asset(
          "assets/images/utils/pailette.svg",
          width: 18,
          // ignore: deprecated_member_use
          // color: AppColors.blue700,
        ),
        type: ModalType.info,
      ),
      body: [
        const Text(
          "Addresse mail",
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        CustomField(
          label: "prenom.nom@gmail.com",
          onChanged: (value) {
            setState(() {
              email = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
          action: TextInputAction.next,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "Mot de passe",
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        CustomField(
          label: "Minimum 8 caractères",
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
          action: TextInputAction.next,
          isPassword: true,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          child: const Text(
            "Mot de passe oublié ?",
            style: TextStyle(
              color: AppColors.black,
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Buttons(
          variant: Variant.primary,
          size: SizeButton.md,
          msg: const Text("Connexion"),
          onPressed: () async {
            await dotenv.load();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String url = '${dotenv.env['URL']}auth/p/login';
            ScaffoldMessenger.of(context).showSnackBar(
              InfoSnackBar(
                message: 'Connexion en cours...',
                context: context,
              ),
            );
            final response = await http.post(
              Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'email': email, 'password': password}),
            );

            Logger().i("Good");
            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              final token = jsonDecode(response.body)['token'];
              prefs.setString('token', token);
              ScaffoldMessenger.of(context).showSnackBar(
                SuccessSnackBar(
                  message: 'Connexion réussie',
                  context: context,
                ),
              );
              await Future.delayed(const Duration(seconds: 3));
              Navigator.pushNamed(context, '/dashboard');
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              final scaffoldContext = context;
              ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                ErrorSnackBar(
                  message: 'Identifiants incorrects ou mot de passe invalide',
                  context: scaffoldContext,
                ),
              );
            }
          },
        )
      ],
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Vous n'êtes pas encore inscrit ?",
            style: TextStyle(
              color: AppColors.black,
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 4,
          ),
          Buttons(
            variant: Variant.secondary,
            size: SizeButton.md,
            msg: const Text("Créer un compte"),
            onPressed: () {
              if (widget.isLogin) {
                widget.model.changePage(1);
              } else {
                widget.model.changePage(0);
              }
            },
          )
        ],
      ),
    );
  }
}

class ModalRegister extends StatefulWidget {
  final BottomSheetModel model;
  final bool isRegister;
  const ModalRegister(
      {super.key, required this.model, required this.isRegister});

  @override
  State<ModalRegister> createState() => _ModalRegisterState();
}

class _ModalRegisterState extends State<ModalRegister> {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    bool emailValidityChecker(String email) {
      return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
    }

    return ModalContainerTest(
      title: "Bienvenue sur la plateforme edgar",
      subtitle:
          "Un compte edgar vous permettra de suivre votre santé ainsi que prendre des rendez-vous pour vous et vos proches.",
      icon: IconModal(
        icon: SvgPicture.asset(
          "assets/images/utils/pailette.svg",
          width: 18,
        ),
        type: ModalType.info,
      ),
      body: [
        const Text(
          "Addresse mail",
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        CustomField(
          label: "prenom.nom@gmail.com",
          onChanged: (value) {
            setState(() {
              email = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
          action: TextInputAction.next,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "Mot de passe",
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        CustomField(
          label: "Minimum 8 caractères",
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
          action: TextInputAction.next,
          isPassword: true,
        ),
        const SizedBox(height: 8),
        const SizedBox(
          height: 24,
        ),
        Buttons(
          variant: Variant.primary,
          size: SizeButton.md,
          msg: const Text("Inscription"),
          onPressed: () async {
            if (password == "" || email == "") {
              ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                  message: "Veuillez remplir tous les champs",
                  context: context));
              return;
            }
            if (password.length < 8) {
              // ignore: use_build_context_synchronouslyx
              ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                  message:
                      "Le mot de passe doit contenir au moins 8 caractères",
                  context: context));
              return;
            }
            if (!emailValidityChecker(email)) {
              ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                  message: "Adresse mail invalide", context: context));
              return;
            }
            var reponse = await RegisterUser(email, password);
            if (reponse) {
              ScaffoldMessenger.of(context).showSnackBar(SuccessSnackBar(
                  message: "Inscription réussie", context: context));
              Navigator.pushNamed(context, '/onboarding');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                  message: "Erreur lors de l'inscription", context: context));
            }
          },
        )
      ],
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Vous êtes déja encore inscrit ?",
            style: TextStyle(
              color: AppColors.black,
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 4,
          ),
          Buttons(
            variant: Variant.secondary,
            size: SizeButton.md,
            msg: const Text("Se connecter à un compte"),
            onPressed: () {
              if (widget.isRegister) {
                widget.model.changePage(1);
              } else {
                widget.model.changePage(0);
              }
            },
          )
        ],
      ),
    );
  }
}