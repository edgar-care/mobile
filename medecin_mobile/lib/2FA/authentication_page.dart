import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/doctor_services.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_modal.dart';
import 'package:edgar_pro/widgets/devices_tab.dart';
import 'package:edgar_pro/widgets/navbarplus.dart';
import 'package:edgar_pro/widgets/number_list_2fa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoubleAuthentication extends StatefulWidget {
  const DoubleAuthentication({super.key});

  @override
  State<DoubleAuthentication> createState() => _DoubleAuthenticationState();
}

class _DoubleAuthenticationState extends State<DoubleAuthentication> {

  Map<String, dynamic> infoMedical = {};
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    loadInfo();  
  }

  void loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    List<dynamic> doctorList = await getAllDoctor();
    for (var doctor in doctorList) {
      if (doctor['id'] == id) {
        infoMedical = doctor;
      }
    }
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
                            const Text('Double Authentification',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),),
                              const SizedBox(),
                            ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text('Méthode de double authentification', style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w600),),
                                Text('Paramétrez vos méthodes de double authentification', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.blue200,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    NavbarPLusTab(
                                      title: 'Email',
                                      isActive: isActive,
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
                                                    isActive? modal2FAEmailDesactivate(infoMedical['email']) : modal2FAEmail(infoMedical['email']),
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
                                    NavbarPLusTab(
                                      title: 'Application edgar',
                                      isActive: false,
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
                                                    isActive? modalEdgarAppDesactivate() : modalEdgarApp1(context),
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
                                    NavbarPLusTab(
                                      title: 'Application tierce',
                                      isActive: true,
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
                                                    // isActive? modalDesactivateTierApp() : modalTierApp(),
                                                    modalDesactivateTierApp(),
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
                        ],
                      )
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

Widget modal2FAEmail(String email) {
    return ModalContainer(
      title: 'Activer la double authentification par email ?',
      subtitle: 'L\'adresse mail: $email sera utilisée comme méthode de double authentification.',
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
            variant: Variante.primary,
            size: SizeButton.md,
            msg: const Text('Activer l\'authentification'),
            onPressed: () {},
          ),
          const SizedBox(height: 8,),
          Buttons(
            variant: Variante.secondary,
            size: SizeButton.md,
            msg: const Text('Annuler'),
            onPressed: () {},
          ),
        ],
      ),
    );
}

Widget modal2FAEmailDesactivate(String email) {
    return ModalContainer(
      title: 'Désactiver la double authentification par email ?',
      subtitle: 'L\'adresse mail: $email ne sera plus utilisée comme méthode de double authentification.',
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.shield_slash_fill,
          color: AppColors.blue700,
          size: 17,
        ),
        type: ModalType.info,
      ),
      footer: Column(
        children: [
          Buttons(
            variant: Variante.delete,
            size: SizeButton.md,
            msg: const Text('Désactiver l\'authentification'),
            onPressed: () {},
          ),
          const SizedBox(height: 8,),
          Buttons(
            variant: Variante.secondary,
            size: SizeButton.md,
            msg: const Text('Annuler'),
            onPressed: () {},
          ),
        ],
      ),
    );
}

Widget modalEdgarApp1(BuildContext context) {
  return ModalContainer(
    title: 'Activer la double authentification avec edgar',
    subtitle: 'Sélectionner un appareil ci-dessous, afin d\'activer la double authentification sur celui-ci.',
    icon: const Icon(
          BootstrapIcons.shield_lock_fill,
          color: AppColors.blue700,
          size: 17,
        ),
    body: [
      Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.blue200,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            DeviceTab(
              icon: 'Phone',
              title: 'Téléphone 1',
              subtitle: 'Lyon, Rhône, France',
              info: 'Dernière connexion: 12/12/2021',
              onTap: () {},
              type: 'Top',
              outlineIcon: SvgPicture.asset(
                'assets/images/utils/chevron-right.svg',
              )
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.blue100,
                    width: 1,
                  ),
                ),
              )
            ),
            DeviceTab(
              icon: 'Phone',
              title: 'Téléphone 1',
              subtitle: 'Lyon, Rhône, France',
              info: 'Dernière connexion: 12/12/2021',
              onTap: () {},
              type: 'Top',
              outlineIcon: SvgPicture.asset(
                'assets/images/utils/chevron-right.svg',
              )
            ),
          ],
        )
      )
    ],
    footer: Column(
      children: [
        Buttons(
          variant: Variante.primary,
          size: SizeButton.md,
          msg: const Text('Activer l\'authentification'),
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
                      return ListModal(model: model, children: [
                        modalTrustDevice(context),
                      ]);
                    },
                  );
                },
              );
          },
        ),
        const SizedBox(height: 8,),
        Buttons(
          variant: Variante.secondary,
          size: SizeButton.md,
          msg: const Text('Annuler'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    )); 
}

Widget modalEdgarApp2() {
  return ModalContainer(
    title: 'La double authentification avec edgar est activée !',
    subtitle: 'Avec la double authentification activée, vous aurez besoin de ces codes de sauvegarde si vous n\'avez plus accès à votre appareil.',
    body: const [
        Text('Ces codes sont très importants, vous ne pourrez les lire qu\'une seule fois. Nous vous recommandons de les stocker dans un lieu sûr:',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500),),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
              ],
            ),
            SizedBox(width: 24),
            Column(
              children: [
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
              ],
            )
          ],
        ),
    ],
    icon: const Icon(
      BootstrapIcons.shield_lock_fill,
      color: AppColors.blue700,
      size: 17,
    ),
    footer: Buttons(
      variant: Variante.primary,
      size: SizeButton.md,
      msg: const Text('Confirmer'),
      onPressed: () {},
    )
  );
}

Widget modalTrustDevice(BuildContext context) {
  return ModalContainer(
    title: 'Double authentification avec edgar',
    subtitle: 'Consulter tous les appareils utilisés pour la double authentification avec l\'application edgar.',
    body: [
      Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.blue200,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            DeviceTab(
              icon: 'Phone',
              title: 'Téléphone 1',
              subtitle: 'Lyon, Rhône, France',
              info: 'Dernière connexion: 12/12/2021',
              onTap: () {
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
                          return ListModal(model: model, children: [
                            modalInfoDevices(),
                          ]);
                        },
                      );
                    },
                  );
              },
              type: 'Top',
              outlineIcon: SvgPicture.asset(
                'assets/images/utils/chevron-right.svg',
              )
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.blue200,
                    width: 1,
                  ),
                ),
              )
            ),
            DeviceTab(
              icon: 'Phone',
              title: 'Téléphone 1',
              subtitle: 'Lyon, Rhône, France',
              info: 'Dernière connexion: 12/12/2021',
              onTap: () {
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
                          return ListModal(model: model, children: [
                            modalInfoDevices(),
                          ]);
                        },
                      );
                    },
                  );
              },
              type: 'Top',
              outlineIcon: SvgPicture.asset(
                'assets/images/utils/chevron-right.svg',
              )
            ),
          ],
        )
      )
    ],
    icon: const Icon(
      BootstrapIcons.shield_lock_fill,
      color: AppColors.blue700,
      size: 17,
    ),
    footer: Column(
      children: [
        Buttons(
          variant: Variante.primary,
          size: SizeButton.md,
          msg: const Text('Ajouter un appareil de confiance'),
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
                      return ListModal(model: model, children: [
                        modalAddTrustDevice(context),
                      ]);
                    },
                  );
                },
              );
          },
        ),
        const SizedBox(height: 8,),
        Buttons(
          variant: Variante.deleteBordered,
          size: SizeButton.md,
          msg: const Text('Désactiver l\'authentification'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Widget modalEdgarAppDesactivate() {
  return ModalContainer(
    title: 'Désactiver la double authentification avec edgar ?',
    subtitle: 'Vous ne pourrez plus vous connecter en utilisant votre application edgar sur mobile.',
    icon: const Icon(
      BootstrapIcons.shield_slash_fill,
      color: AppColors.blue700,
      size: 17,
    ),
    footer: Column(
      children: [
        Buttons(
          variant: Variante.delete,
          size: SizeButton.md,
          msg: const Text('Désactiver l\'authentification'),
          onPressed: () {},
        ),
        const SizedBox(height: 8,),
        Buttons(
          variant: Variante.secondary,
          size: SizeButton.md,
          msg: const Text('Annuler'),
          onPressed: () {},
        ),
      ],
    )
  );
}

Widget modalAddTrustDevice(BuildContext context) {
  return ModalContainer(
    title: 'Ajouter un appareil de confiance',
    subtitle: 'Sélectionner un appareil ci-dessous, afin d\'ajouter la double authentification sur celui-ci.',
    icon: const Icon(
      BootstrapIcons.shield_lock_fill,
      color: AppColors.blue700,
      size: 17,
    ),
    body: [
      Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.blue200,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            DeviceTab(
              icon: 'Phone',
              title: 'Téléphone 1',
              subtitle: 'Lyon, Rhône, France',
              info: 'Dernière connexion: 12/12/2021',
              onTap: () {
              },
              type: 'Top',
              outlineIcon: SvgPicture.asset(
                'assets/images/utils/chevron-right.svg',
              )
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.blue200,
                    width: 1,
                  ),
                ),
              )
            ),
            DeviceTab(
              icon: 'Phone',
              title: 'Téléphone 1',
              subtitle: 'Lyon, Rhône, France',
              info: 'Dernière connexion: 12/12/2021',
              onTap: () {},
              type: 'Top',
              outlineIcon: SvgPicture.asset(
                'assets/images/utils/chevron-right.svg',
              )
            ),
          ],
        )
      )
    ],
    footer: Column(
      children: [
        Buttons(
          variant: Variante.primary,
          size: SizeButton.md,
          msg: const Text('Activer l\'authentification'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 8,),
        Buttons(
          variant: Variante.secondary,
          size: SizeButton.md,
          msg: const Text('Annuler'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    )
  );
}

Widget modalTierApp(){
  return ModalContainer(
    title: 'Activer la double authentification avec une application tierce ?',
    subtitle: 'Ouvrer votre application de double authentification et renseigner le code secret ci-dessous.',
    body: [
      Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            const Text('4535 6798 7894', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
            GestureDetector(
              onTap: () {
                Clipboard.setData(const ClipboardData(text: '4535 6798 7894'));
              },
              child: const Icon(
                Icons.copy,
                color: AppColors.blue700,
                size: 17,
              ), 
            )
            ]
          )
        ],
      )
    ],
    icon: const Icon(
      BootstrapIcons.shield_lock_fill,
      color: AppColors.blue700,
      size: 17,
    ),
    footer: Column(
      children: [
        Buttons(
          variant: Variante.primary,
          size: SizeButton.md,
          msg: const Text('Continuer'),
          onPressed: () {},
        ),
        const SizedBox(height: 8,),
        Buttons(
          variant: Variante.secondary,
          size: SizeButton.md,
          msg: const Text('Annuler'),
          onPressed: () {},
        ),
      ],
    )
  );
}

Widget modalTierApp2() {
  return ModalContainer(
    title: 'Aciter la double authentification avec une application tierce ?',
    subtitle: 'Pour s\'assurer du bon fonctionnement, renseigner le code que votre application d\'authentification affiche.',
    body: const [
      FieldNumberList2FA()
    ],
    icon: const Icon(
      BootstrapIcons.shield_lock_fill,
      color: AppColors.blue700,
      size: 17,
    ),
    footer: Column(
      children: [
        Buttons(
          variant: Variante.primary,
          size: SizeButton.md,
          msg: const Text('Continuer'),
          onPressed: () {},
        ),
        const SizedBox(height: 8,),
        Buttons(
          variant: Variante.secondary,
          size: SizeButton.md,
          msg: const Text('Annuler'),
          onPressed: () {},
        ),
      ],
    )
  );
}

Widget modalBackupTierApp() {
  return ModalContainer(
    title: 'La double authentification avec une application tierce est activée !',
    subtitle: 'Avec la double authentification activée, vous aurez besoin de ces codes de sauvegarde si vous n\'avez plus accès à votre appareil.',
    icon: const Icon(
      BootstrapIcons.shield_lock_fill,
      color: AppColors.blue700,
      size: 17,
    ),
    body: const [
      Text('Ces codes sont très importants, vous ne pourrez les lire qu\'une seule fois. Nous vous recommandons de les stocker dans un lieu sûr:',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500),),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
              ],
            ),
            SizedBox(width: 24),
            Column(
              children: [
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                SizedBox(height: 8),
                Text('3J4K5L6M7N8O9P0', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
              ],
            )
          ],
        ),
    ],
    footer: Buttons(
      variant: Variante.primary,
      size: SizeButton.md,
      msg: const Text('Confirmer'),
      onPressed: () {},
    )
  );
}

Widget modalDesactivateTierApp() {
  return ModalContainer(
    title: 'Désactiver la double authentification avec une application tierce ?',
    subtitle: 'Vous ne pourrez plus vous connecter en utilisant votre application de double authentification.',
    icon: const Icon(
      BootstrapIcons.shield_slash_fill,
      color: AppColors.blue700,
      size: 17,
    ),
    footer: Column(
      children: [
        Buttons(
          variant: Variante.delete,
          size: SizeButton.md,
          msg: const Text('Désactiver l\'authentification'),
          onPressed: () {},
        ),
        const SizedBox(height: 8,),
        Buttons(
          variant: Variante.secondary,
          size: SizeButton.md,
          msg: const Text('Annuler'),
          onPressed: () {},
        ),
      ],
    ),
  );
}

Widget modalInfoDevices() {
  return ModalContainer(
    title: 'Téléphone 1',
    subtitle: 'Connecté à votre compte edgar.',
    icon: const Icon(
      BootstrapIcons.phone_fill,
      color: AppColors.blue700,
      size: 17,
    ),
    body: const [
      Column(
        children: [
          Row(
            children: [
              Text('Dernière connexion: ', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
              Text('12/12/2021', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text('Localisation: ', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
              Text('Lyon, Rhône, France', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
            ],
          ),
        ],
      )
    ],
    footer: Buttons(
      variant: Variante.deleteBordered,
      size: SizeButton.md,
      msg: const Text('Déconnecter l\'appareil'),
      onPressed: () {},
    )
  );
}