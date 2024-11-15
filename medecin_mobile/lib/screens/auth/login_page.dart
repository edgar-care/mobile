// ignore_for_file: use_build_context_synchronously

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/widgets/navbarplus.dart';
import 'package:edgar_pro/widgets/number_list_2fa.dart';
import 'package:flutter/material.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_pro/services/login_service.dart';
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
                          action: TextInputAction.next,
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
                          action: TextInputAction.next,
                          label: "Minimum 8 caractères",
                          keyboardType: TextInputType.text,
                          isPassword: true,
                          isNotCapitalize: true,
                          onChanged: (value) {
                            setState(() {
                              password = value.trim();
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            final model = Provider.of<BottomSheetModel>(context,
                                listen: false);
                            model.resetCurrentIndex();
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) {
                                return Consumer<BottomSheetModel>(
                                  builder: (context, model, child) {
                                    return ListModal(model: model, children: [
                                      modalForgotPassword(context),
                                    ]);
                                  },
                                );
                              },
                            );
                          },
                          child: const Text(
                            "Mot de passe oublié ?",
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Buttons(
                          variant: Variant.primary,
                          msg: const Text("Se connecter"),
                          size: SizeButton.md,
                          onPressed: () {
                            login(email, password, context).then(
                              (value) {
                                if (value.isNotEmpty) {
                                  final model = Provider.of<BottomSheetModel>(
                                      context,
                                      listen: false);
                                  model.resetCurrentIndex();
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return Consumer<BottomSheetModel>(
                                          builder: (context, model, child) {
                                            return ListModal(
                                                model: model,
                                                children: [
                                                  ModalChoose2FA(
                                                    methods: value,
                                                    email: email,
                                                    password: password,
                                                  ),
                                                ]);
                                          },
                                        );
                                      });
                                }
                              },
                            );
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
                        variant: Variant.secondary,
                        msg: const Text("Créer un compte"),
                        size: SizeButton.md,
                        onPressed: () {
                          widget.callback(1);
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

Widget modalForgotPassword(BuildContext context) {
  String email = "";
  return ModalContainer(
    title: "Mot de passe oublié ?",
    subtitle:
        "Renseigner votre adresse mail pour réinitialiser votre mot de passe.",
    icon: const IconModal(
      icon: Icon(
        BootstrapIcons.shield_lock_fill,
        color: AppColors.blue700,
        size: 17,
      ),
      type: ModalType.info,
    ),
    body: [
      const Text('Adresse mail du compte perdu',
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      CustomField(
        action: TextInputAction.none,
        isNotCapitalize: true,
        value: email,
        label: "prenom.nom@gmail.com",
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          email = value.trim();
        },
      ),
    ],
    footer: Buttons(
      variant: Variant.primary,
      size: SizeButton.md,
      msg: const Text('Réinitialiser le mot de passe'),
      onPressed: () {
        missingPassword(email).then((value) {
          Navigator.pop(context);
        });
      },
    ),
  );
}

class ModalChoose2FA extends StatefulWidget {
  final List<dynamic> methods;
  final String email;
  final String password;
  const ModalChoose2FA(
      {super.key,
      required this.methods,
      required this.email,
      required this.password});

  @override
  State<ModalChoose2FA> createState() => _ModalChoose2FAState();
}

class _ModalChoose2FAState extends State<ModalChoose2FA> {
  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: 'Vérifier votre identité',
      subtitle:
          'Sélectionner une des méthodes d\'authentification ci-dessous, afin de vérifier votre identité.',
      body: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(
                color: AppColors.blue200,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                for (int i = 0; i < widget.methods.length; i++) ...[
                  if (widget.methods[i] == 'EMAIL')
                    NavbarPLusTab(
                      title: 'Code envoyé par email',
                      onTap: () {
                        final model = Provider.of<BottomSheetModel>(context,
                            listen: false);
                        model.resetCurrentIndex();
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) {
                            return Consumer<BottomSheetModel>(
                              builder: (context, model, child) {
                                return ListModal(model: model, children: [
                                  ModalEmailLogin(
                                      email: widget.email,
                                      password: widget.password),
                                ]);
                              },
                            );
                          },
                        );
                      },
                      type: 'Top',
                      icon: SvgPicture.asset(
                          'assets/images/utils/envelope-fill.svg',
                          colorFilter: const ColorFilter.mode(
                              AppColors.black, BlendMode.srcIn)),
                      outlineIcon: SvgPicture.asset(
                        'assets/images/utils/chevron-right.svg',
                      ),
                    ),
                  if (widget.methods[i] == 'AUTHENTIFICATOR')
                    NavbarPLusTab(
                      title: 'Application d\'authentification',
                      onTap: () {
                        final model = Provider.of<BottomSheetModel>(context,
                            listen: false);
                        model.resetCurrentIndex();
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) {
                            return Consumer<BottomSheetModel>(
                              builder: (context, model, child) {
                                return ListModal(model: model, children: [
                                  ModalThirdPartyLogin(
                                      email: widget.email,
                                      password: widget.password),
                                ]);
                              },
                            );
                          },
                        );
                      },
                      type: 'Only',
                      icon: SvgPicture.asset(
                          'assets/images/utils/shield-lock-fill.svg',
                          colorFilter: const ColorFilter.mode(
                              AppColors.black, BlendMode.srcIn)),
                      outlineIcon: SvgPicture.asset(
                        'assets/images/utils/chevron-right.svg',
                      ),
                    ),
                  if (i < widget.methods.length && i > 0)
                    Container(
                      height: 1,
                      color: AppColors.blue100,
                    ),
                ],
                NavbarPLusTab(
                  title: 'Code de sauvegarde',
                  onTap: () {
                    final model =
                        Provider.of<BottomSheetModel>(context, listen: false);
                    model.resetCurrentIndex();
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) {
                        return Consumer<BottomSheetModel>(
                          builder: (context, model, child) {
                            return ListModal(model: model, children: [
                              ModalCheckBackupCode(
                                  email: widget.email,
                                  password: widget.password),
                            ]);
                          },
                        );
                      },
                    );
                  },
                  type: 'Bottom',
                  icon: SvgPicture.asset('assets/images/utils/key-fill.svg',
                      colorFilter: const ColorFilter.mode(
                          AppColors.black, BlendMode.srcIn)),
                  outlineIcon: SvgPicture.asset(
                    'assets/images/utils/chevron-right.svg',
                  ),
                ),
              ],
            ))
      ],
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.shield_lock_fill,
          color: AppColors.blue700,
          size: 17,
        ),
        type: ModalType.info,
      ),
    );
  }
}

class ModalEmailLogin extends StatefulWidget {
  final String email;
  final String password;
  const ModalEmailLogin(
      {super.key, required this.email, required this.password});

  @override
  State<ModalEmailLogin> createState() => _ModalEmailLoginState();
}

class _ModalEmailLoginState extends State<ModalEmailLogin> {

  Future<bool> sendEmail() async {
    await sendEmailCode(widget.email);
    return true;
  }

  @override
  void initState() {
    super.initState();
    sendEmail();
  }
  @override
  Widget build(BuildContext context) {
    String code = '';
    void setCode(String action, String code) {
      if (action == 'ADD') {
        setState(() {
          code += code;
        });
      } else if (action == 'DELETE') {
        setState(() {
          code = code.substring(0, code.length - 1);
        });
      }
    }

    return ModalContainer(
      title: "Vérifier votre identité",
      subtitle:
          'Renseigner le code que vous avez reçu dans l\'email que nous venons de vous envoyer.',
      body: [
        FieldNumberList2FA(
          addCode: setCode,
        )
      ],
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.shield_lock_fill,
          color: AppColors.blue700,
          size: 17,
        ),
        type: ModalType.info,
      ),
      footer: Column(
        children: [
          Buttons(
              variant: Variant.primary,
              size: SizeButton.md,
              msg: const Text('Valider le code'),
              onPressed: () {
                checkEmailCode(widget.email, widget.password, code, context)
                    .then((value) {});
              }),
          const SizedBox(
            height: 8,
          ),
          Buttons(
            variant: Variant.secondary,
            size: SizeButton.md,
            msg: const Text('Revenir en arrière'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class ModalThirdPartyLogin extends StatefulWidget {
  final String email;
  final String password;
  const ModalThirdPartyLogin(
      {super.key, required this.email, required this.password});

  @override
  State<ModalThirdPartyLogin> createState() => _ModalThirdPartyLoginState();
}

class _ModalThirdPartyLoginState extends State<ModalThirdPartyLogin> {
  String sendcode = '';

  void setCode(String action, String code) {
    if (action == 'ADD') {
      setState(() {
        sendcode += code;
      });
    } else if (action == 'DELETE') {
      setState(() {
        sendcode = sendcode.substring(0, code.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Vérifier votre identité",
      subtitle:
          'Rouvrer votre application d\'authentification et renseigner le code à 6 chiffres fournis.',
      body: [
        FieldNumberList2FA(
          addCode: setCode,
        )
      ],
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.shield_lock_fill,
          color: AppColors.blue700,
          size: 17,
        ),
        type: ModalType.info,
      ),
      footer: Column(
        children: [
          Buttons(
              variant: Variant.primary,
              size: SizeButton.md,
              msg: const Text('Valider le code'),
              onPressed: () {
                checkThirdPartyCode(
                        widget.email, widget.password, sendcode, context)
                    .then((value) {});
              }),
          const SizedBox(
            height: 8,
          ),
          Buttons(
            variant: Variant.secondary,
            size: SizeButton.md,
            msg: const Text('Revenir en arrière'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class ModalCheckBackupCode extends StatefulWidget {
  final String email;
  final String password;
  const ModalCheckBackupCode(
      {super.key, required this.email, required this.password});

  @override
  State<ModalCheckBackupCode> createState() => _ModalCheckBackupCodeState();
}

class _ModalCheckBackupCodeState extends State<ModalCheckBackupCode> {
  String code = '';
  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: 'Vérifier votre identité',
      subtitle:
          'Renseigner l\'un de vos codes de sauvegarde. Le code utilisé ne pourra plus être utilisé dans le futur.',
      body: [
        const Text('Code de sauvegarde',
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        CustomField(
          isNotCapitalize: true,
          label: "XXXXXXXX",
          keyboardType: TextInputType.text,
          onChanged: (value) {
            setState(() {
              code = value.trim();
            });
          },
          action: TextInputAction.none,
        ),
      ],
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.shield_lock_fill,
          color: AppColors.blue700,
          size: 17,
        ),
        type: ModalType.info,
      ),
      footer: Column(
        children: [
          Buttons(
              variant: Variant.primary,
              size: SizeButton.md,
              msg: const Text('Valider le code'),
              onPressed: () {
                checkBackUpCode(widget.email, widget.password, code, context)
                    .then((value) {});
              }),
          const SizedBox(
            height: 8,
          ),
          Buttons(
            variant: Variant.secondary,
            size: SizeButton.md,
            msg: const Text('Revenir en arrière'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
