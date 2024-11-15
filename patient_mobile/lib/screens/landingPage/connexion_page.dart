// ignore_for_file: use_build_context_synchronously

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_app/services/auth.dart';
import 'package:edgar_app/widget/navbarplus.dart';
import 'package:edgar_app/widget/number_list_2fa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return ModalContainer(
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
                        modalForgotPassword(context),
                      ]);
                    },
                  );
                });
          },
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
          onPressed: () {
            login(email, password, context).then(
              (value) {
                if (value.isNotEmpty) {
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

    return ModalContainer(
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
            var reponse = await registerUser(email, password, context);
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
                        Navigator.pop(context);
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
                      type: 'Only',
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
                        Navigator.pop(context);
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
                    Navigator.pop(context);
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
        missingPassword(email, context).then((value) {
          Navigator.pop(context);
        });
      },
    ),
  );
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

    Future<bool> sendEmail() async {
      await sendEmailCode(widget.email, context);
      return true;
    }

    return FutureBuilder(
        future: sendEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 48,
              child: Row(
                children: [
                  CircularProgressIndicator(
                    color: AppColors.white,
                    semanticsValue: 'Loading...',
                  ),
                  SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 4,
                        child: LinearProgressIndicator(
                          backgroundColor: AppColors.blue700,
                          minHeight: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.white),
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 120,
                        height: 4,
                        child: LinearProgressIndicator(
                          backgroundColor: AppColors.blue700,
                          minHeight: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          } else {
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
                        checkEmailCode(
                                widget.email, widget.password, code, context)
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
        });
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
  String _code = '';

  void setCode(String action, String code) {
    if (action == 'ADD') {
      setState(() {
        _code += code;
      });
    } else if (action == 'DELETE') {
      setState(() {
        _code = _code.substring(0, _code.length - 1);
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
                    widget.email, widget.password, _code, context);
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
