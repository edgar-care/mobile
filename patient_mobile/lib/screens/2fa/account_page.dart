// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_app/screens/2fa/authentication_page.dart';
import 'package:edgar_app/screens/2fa/reset_password_pages.dart';
import 'package:edgar_app/services/account.dart';
import 'package:edgar_app/services/multiplefa.dart';
import 'package:edgar_app/widget/navbarplus.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AccountPage extends StatefulWidget {
  Map<String, dynamic> infoMedical = {};
  AccountPage({super.key, required this.infoMedical});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Map<String, dynamic> enable2fa = {};
  String birthdate = '';
  String email = 'Email non renseigné';

  @override
  void initState() {
    super.initState();
    getEmail();
    getInfo();
  }

  void refresh() {
    getInfo();
    setState(() {});
  }

  Future<bool> getInfo() async {
    var tmp = await getEnable2fa(context);
    enable2fa = tmp;
    birthdate = DateFormat('dd/MM/yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(
            widget.infoMedical['birthdate'] * 1000));
    return true;
  }

  void getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String encodedPayload = token!.split('.')[1];
    String decodedPayload =
        utf8.decode(base64.decode(base64.normalize(encodedPayload)));
    setState(() {
      email = jsonDecode(decodedPayload)["patient"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: Scaffold(
            backgroundColor: AppColors.blue50,
            body: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/images/utils/arrowChat.svg',
                                // ignore: deprecated_member_use
                                color: AppColors.black,
                                height: 16,
                              ),
                              const Text(
                                'Compte',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(width: 18),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: AppColors.blue700,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: FutureBuilder(
                                future: getInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 80,
                                                height: 4,
                                                child: LinearProgressIndicator(
                                                  backgroundColor:
                                                      AppColors.blue700,
                                                  minHeight: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          AppColors.white),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              SizedBox(
                                                width: 120,
                                                height: 4,
                                                child: LinearProgressIndicator(
                                                  backgroundColor:
                                                      AppColors.blue700,
                                                  minHeight: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          AppColors.white),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Row(
                                      children: [
                                        SizedBox(
                                          width: 48,
                                          height: 48,
                                          child: BoringAvatar(
                                            name:
                                                "${widget.infoMedical['firstname']} ${widget.infoMedical['name'].toUpperCase()}",
                                            palette: BoringAvatarPalette(
                                              [
                                                AppColors.blue700,
                                                AppColors.blue200,
                                                AppColors.blue500
                                              ],
                                            ),
                                            type: BoringAvatarType.beam,
                                            shape: CircleBorder(),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${widget.infoMedical['firstname']} ${widget.infoMedical['name'].toUpperCase()}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                            if (widget.infoMedical['sex'] ==
                                                    "MALE" ||
                                                widget.infoMedical['sex'] ==
                                                    'OTHER') ...[
                                              Text(
                                                'Né le $birthdate',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Poppins",
                                                ),
                                              )
                                            ] else ...[
                                              Text(
                                                'Née le $birthdate',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Poppins",
                                                ),
                                              )
                                            ]
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                border: Border.all(
                                  color: AppColors.blue200,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  NavbarPLusTab(
                                      title: 'Email',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder<void>(
                                            opaque: false,
                                            pageBuilder:
                                                (BuildContext context, _, __) {
                                              return const SizedBox();
                                            },
                                          ),
                                        );
                                      },
                                      type: 'Only',
                                      outlineIcon: Text(
                                        email,
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.grey500),
                                      )),
                                  Container(
                                    height: 1,
                                    color: AppColors.blue100,
                                  ),
                                  NavbarPLusTab(
                                    title: 'Mot de passe',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder<void>(
                                          opaque: false,
                                          pageBuilder:
                                              (BuildContext context, _, __) {
                                            return const ResetPasswordPage();
                                          },
                                        ),
                                      );
                                    },
                                    type: 'Only',
                                    outlineIcon: SvgPicture.asset(
                                      'assets/images/utils/chevron-right.svg',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Sécurité du Compte',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.blue100,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  NavbarPLusTab(
                                    title: 'Double authentification',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder<void>(
                                          opaque: false,
                                          pageBuilder:
                                              (BuildContext context, _, __) {
                                            return DoubleAuthentication(
                                              refreshAccount: refresh,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    type: 'Only',
                                    outlineIcon: SvgPicture.asset(
                                      'assets/images/utils/chevron-right.svg',
                                    ),
                                  ),
                                  Container(
                                    color: AppColors.blue100,
                                    height: 1,
                                  ),
                                  NavbarPLusTab(
                                    title: 'Codes de sauvegarde',
                                    onTap: () {
                                      final model =
                                          Provider.of<BottomSheetModel>(context,
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
                                                    enable2fa['methods'].isEmpty
                                                        ? modalRedirect2FA(
                                                            context, refresh)
                                                        : modalReNewBackup(
                                                            context),
                                                  ]);
                                            },
                                          );
                                        },
                                      );
                                    },
                                    type: 'Only',
                                    outlineIcon: SvgPicture.asset(
                                      'assets/images/utils/chevron-right.svg',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Gestion du Compte',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.blue100,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  NavbarPLusTab(
                                    title: 'Désactiver le compte',
                                    onTap: () {
                                      final model =
                                          Provider.of<BottomSheetModel>(context,
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
                                                    modalDisableAccount(
                                                        context),
                                                  ]);
                                            },
                                          );
                                        },
                                      );
                                    },
                                    type: 'Only',
                                  ),
                                  Container(
                                    color: AppColors.blue100,
                                    height: 1,
                                  ),
                                  NavbarPLusTab(
                                    title: 'Supprimer le compte',
                                    color: AppColors.red600,
                                    onTap: () {
                                      final model =
                                          Provider.of<BottomSheetModel>(context,
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
                                                    modalDeleteAccount(context),
                                                  ]);
                                            },
                                          );
                                        },
                                      );
                                    },
                                    type: 'Only',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            )));
  }
}

Widget modalDisableAccount(BuildContext context) {
  return ModalContainer(
    title: 'Désactiver le compte',
    subtitle:
        'Vous êtes sur le point de désactiver votre compte. Vous ne pourrez plus accéder à votre compte.',
    icon: const IconModal(
      icon: Icon(
        BootstrapIcons.person_x_fill,
        color: AppColors.red600,
        size: 17,
      ),
      type: ModalType.error,
    ),
    footer: Column(
      children: [
        Buttons(
          variant: Variant.delete,
          size: SizeButton.md,
          msg: const Text('Désactiver le compte'),
          onPressed: () async {
            await disableAccount(context).then(
              (value) {
                Navigator.pop(context);
              },
            ).then(
              (value) {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/desactivate');
              },
            );
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Buttons(
          variant: Variant.secondary,
          size: SizeButton.md,
          msg: const Text('Annuler'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Widget modalDeleteAccount(BuildContext context) {
  return ModalContainer(
    title: 'Supprimer le compte',
    subtitle:
        'Vous êtes sur le point de supprimer votre compte. Vous ne pourrez plus accéder à votre compte.',
    icon: const IconModal(
      icon: Icon(
        BootstrapIcons.person_x_fill,
        color: AppColors.red600,
        size: 17,
      ),
      type: ModalType.error,
    ),
    footer: Column(
      children: [
        Buttons(
          variant: Variant.delete,
          size: SizeButton.md,
          msg: const Text('Supprimer le compte'),
          onPressed: () {},
        ),
        const SizedBox(
          height: 8,
        ),
        Buttons(
          variant: Variant.secondary,
          size: SizeButton.md,
          msg: const Text('Annuler'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Widget modalReNewBackup(BuildContext context) {
  return ModalContainer(
    title: 'Vos codes de sauvegarde',
    subtitle:
        'Vous avez déjà consulté vos codes de sauvegarde. Par sourcis de sécurité vous ne pouvez consulter vos code de sauvegarde qu\'une seule fois, lors de la génération de ceux-ci.',
    icon: const IconModal(
      icon: Icon(
        BootstrapIcons.shield_lock_fill,
        color: AppColors.blue700,
        size: 17,
      ),
      type: ModalType.info,
    ),
    footer: Buttons(
      variant: Variant.primary,
      size: SizeButton.md,
      msg: const Text('Générer de nouveaux codes'),
      onPressed: () {
        Navigator.pop(context);
        final model = Provider.of<BottomSheetModel>(context, listen: false);
        model.resetCurrentIndex();
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return Consumer<BottomSheetModel>(
              builder: (context, model, child) {
                return ListModal(model: model, children: const [
                  ModalGenerateBackup(),
                ]);
              },
            );
          },
        );
      },
    ),
  );
}

class ModalGenerateBackup extends StatefulWidget {
  const ModalGenerateBackup({super.key});

  @override
  State<ModalGenerateBackup> createState() => _ModalGenerateBackupState();
}

class _ModalGenerateBackupState extends State<ModalGenerateBackup> {
  List<dynamic> backupCodes = [];

  Future<bool> getbackupcode() async {
    var tmp = await generateBackupCode(context);
    backupCodes = tmp;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getbackupcode(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == true) {
            return ModalContainer(
              title: 'Vos codes de sauvegarde',
              subtitle:
                  'Avec la double authentification activée, vous aurez besoin de ces codes de sauvegarde si vous n\'avez plus accès à votre appareil.',
              icon: const IconModal(
                icon: Icon(
                  BootstrapIcons.shield_lock_fill,
                  color: AppColors.blue700,
                  size: 17,
                ),
                type: ModalType.info,
              ),
              body: [
                const Text(
                  'Ces codes sont très importants, vous ne pourrez les lire qu\'une seule fois. Nous vous recommandons de les stocker dans un lieu sûr:',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          backupCodes[0].toString(),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          backupCodes[1].toString(),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          backupCodes[2].toString(),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          backupCodes[3].toString(),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          backupCodes[4].toString(),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Column(
                      children: [
                        Text(
                          backupCodes[5].toString(),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          backupCodes[6].toString(),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          backupCodes[7].toString(),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          backupCodes[8].toString(),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          backupCodes[9].toString(),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
              ],
              footer: Buttons(
                variant: Variant.primary,
                size: SizeButton.md,
                msg: const Text('Confirmer'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

Widget modalRedirect2FA(BuildContext context, Function refreshAccount) {
  return ModalContainer(
    title: 'Vos codes de sauvegarde',
    subtitle:
        'Ajouter une méthode de double authentification pour générer vos codes de sauvegarde. Les codes de sauvegarde sont utilisés lorsque vous n\'avez plus accès à votre appareil de double authentification.',
    icon: const IconModal(
      icon: Icon(
        BootstrapIcons.shield_lock_fill,
        color: AppColors.blue700,
        size: 17,
      ),
      type: ModalType.info,
    ),
    footer: Buttons(
      variant: Variant.primary,
      size: SizeButton.md,
      msg: const Text('Activer l\'authentification'),
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder<void>(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) {
              return DoubleAuthentication(
                refreshAccount: refreshAccount,
              );
            },
          ),
        );
      },
    ),
  );
}
