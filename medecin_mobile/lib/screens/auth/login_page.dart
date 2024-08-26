import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/widgets/navbarplus.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/field_custom.dart';
import 'package:edgar_pro/services/login_service.dart';
import 'package:edgar_pro/widgets/custom_modal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final Function(int) callback;
  const Login({super.key, required this.callback});
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
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
                    Image.asset('assets/images/logo/new_white_logo.png',
                        height: 60, width: 200),
                    const SizedBox(height: 24),
                    const SizedBox(
                      width: 320,
                      child: Text('Bienvenue sur la plateforme edgar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(
                        width: 320,
                        child: Text(
                            'Connectez-vous pour accéder à votre espace médecin',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Adresse mail",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomField(
                          startUppercase: false,
                          text: email,
                          label: "prenom.nom@gmail.com",
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              email = value.trim();
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Mot de passe",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomField(
                          startUppercase: false,
                          label: "Minimum 8 caractères",
                          keyboardType: TextInputType.text,
                          isPassword: true,
                          onChanged: (value) {
                            setState(() {
                              password = value.trim();
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            final model = Provider.of<BottomSheetModel>(context, listen: false);
                            model.resetCurrentIndex();
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) {
                                  return Consumer<BottomSheetModel>(
                                    builder: (context, model, child) {
                                      return ListModal(model: model, children: [
                                        modalForgotPassword(),
                                      ]);
                                    },
                                  );
                                },
                              );
                          },
                          child: const Text("Mot de passe oublié ?",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500),
                        ),),
                        const SizedBox(height: 32),
                        Buttons(
                          variant: Variante.primary,
                          msg: const Text("Se connecter"),
                          size: SizeButton.md,
                          onPressed: () {
                            final model = Provider.of<BottomSheetModel>(context, listen: false);
                            model.resetCurrentIndex();
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) {
                                  return Consumer<BottomSheetModel>(
                                    builder: (context, model, child) {
                                      return ListModal(model: model, children: [
                                        modalChoose2FA(),
                                      ]);
                                    },
                                  );
                                },
                              );
                            // login(email, password, context);
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
                      const Text(
                        "Vous n'êtes pas encore inscrit ?",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Buttons(
                        variant: Variante.secondary,
                        msg: const Text("Créer un compte"),
                        size: SizeButton.md,
                        onPressed: () {
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
      ),
    );
  }
}

Widget modalForgotPassword() {
  String email = "";
  return ModalContainer(
    title: "Mot de passe oublié ?",
    subtitle: "Renseigner votre adresse mail pour réinitialiser votre mot de passe.",
    icon: const IconModal(
        icon: Icon(
          BootstrapIcons.shield_lock_fill,
          color: AppColors.blue700,
          size: 17,
        ),
        type: ModalType.info,
      ),
      body: [
        const Text('Adresse mail du compte perdu', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        CustomField(
          startUppercase: false,
          text: email,
          label: "prenom.nom@gmail.com",
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
              email = value.trim();
          },
        ),
      ],
    footer: Buttons(
            variant: Variante.primary,
            size: SizeButton.md,
            msg: const Text('Réinitialiser le mot de passe'),
            onPressed: () {},
          ),
    );
}

Widget modalChoose2FA() {
  return ModalContainer(
    title: 'Vérifier votre identité',
    subtitle: 'Sélectionner une des méthodes d\'authentification ci-dessous, afin de vérifier votre identité.',
    body: [
      Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.all(
              Radius.circular(16)),
          border: Border.all(
            color: AppColors.blue200,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            NavbarPLusTab(
              title: 'Code envoyé par email',
              onTap: (index) {
              },
              type: 'Top',
              icon: SvgPicture.asset(
                'assets/images/utils/envelope-fill.svg',
                colorFilter: const ColorFilter.mode(
                    AppColors.black, BlendMode.srcIn)
              ),
              outlineIcon: SvgPicture.asset(
                'assets/images/utils/chevron-right.svg',
              ),
            ),
            Container(
              height: 1,
              color: AppColors.blue100,
            ),
            NavbarPLusTab(
              title: 'Application d\'authentification',
              onTap: (index) {
              },
              type: 'Only',
              icon: SvgPicture.asset(
                'assets/images/utils/shield-lock-fill.svg',
                colorFilter: const ColorFilter.mode(
                    AppColors.black, BlendMode.srcIn)
              ),
              outlineIcon: SvgPicture.asset(
                'assets/images/utils/chevron-right.svg',
              ),
            ),
            Container(
              height: 1,
              color: AppColors.blue100,
            ),
            NavbarPLusTab(
              title: 'Code de sauvegarde',
              onTap: (index) {
              },
              type: 'Bottom',
              icon: SvgPicture.asset(
                'assets/images/utils/key-fill.svg',
                colorFilter: const ColorFilter.mode(
                    AppColors.black, BlendMode.srcIn)
              ),
              outlineIcon: SvgPicture.asset(
                'assets/images/utils/chevron-right.svg',
              ),
            ),
          ],
        )
        )
    ],
    icon:const IconModal(
        icon: Icon(
          BootstrapIcons.shield_lock_fill,
          color: AppColors.blue700,
          size: 17,
        ),
        type: ModalType.info,
      ),);
}