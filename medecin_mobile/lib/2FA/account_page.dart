import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/2FA/authentication_page.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_modal.dart';
import 'package:edgar_pro/widgets/navbarplus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';


// ignore: must_be_immutable
class AccountPage extends StatefulWidget {
  Map<String, dynamic> infoMedical = {};
  AccountPage({super.key, required this.infoMedical});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
                            const Text('Compte',
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
                                child: Row(
                                        children: [
                                          Container(
                                              width: 48,
                                              height: 48,
                                              decoration: const BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50)),
                                              ),
                                              child: BoringAvatars(
                                                name:
                                                    "${widget.infoMedical['firstname']} ${widget.infoMedical['name'].toUpperCase()}",
                                                colors: const [
                                                  AppColors.blue700,
                                                  AppColors.blue200,
                                                  AppColors.blue500
                                                ],
                                                type: BoringAvatarsType.beam,
                                              )),
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
                                            ],
                                          ),
                                        ],
                                      )
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
                                            pageBuilder: (BuildContext context, _, __) {
                                              return const SizedBox();
                                            },
                                          ),
                                        );
                                      },
                                      type: 'Only',
                                      outlineIcon: Text(widget.infoMedical["email"], style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w400 ),)
                                    ),
                                    NavbarPLusTab(
                                      title: 'Mot de passe',
                                      onTap: () {
                                        Navigator.pop(context);
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
                              const Text('Sécurité du Compte', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500),),
                              const SizedBox(height: 4),
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
                                      title: 'Double authentification',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder<void>(
                                            opaque: false,
                                            pageBuilder: (BuildContext context, _, __) {
                                              return const DoubleAuthentication();
                                            },
                                          ),
                                        );
                                      },
                                      type: 'Only',
                                      outlineIcon: SvgPicture.asset(
                                        'assets/images/utils/chevron-right.svg',
                                      ),
                                    ),
                                    NavbarPLusTab(
                                      title: 'Codes de sauvegarde',
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
                                                    modalGenerateBackup()
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
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

Widget modalReNewBackup() {
    return ModalContainer(
      title: 'Vos codes de sauvegarde',
      subtitle: 'Vous avez déjà consulté vos codes de sauvegarde. Par sourcis de sécurité vous ne pouvez consulter vos code de sauvegarde qu\'une seule fois, lors de la génération de ceux-ci.',
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.shield_lock_fill,
          color: AppColors.blue700,
          size: 17,
        ),
        type: ModalType.info,
      ),
      footer:
          Buttons(
            variant: Variante.primary,
            size: SizeButton.md,
            msg: const Text('Générer de nouveaux codes'),
            onPressed: () {},
          ),
    );
}

Widget modalGenerateBackup() {
  return ModalContainer(
    title: 'Vos codes de sauvegarde',
    subtitle: 'Avec la double authentification activée, vous aurez besoin de ces codes de sauvegarde si vous n\'avez plus accès à votre appareil.',
    icon: const IconModal(
        icon: Icon(
          BootstrapIcons.shield_lock_fill,
          color: AppColors.blue700,
          size: 17,
        ),
        type: ModalType.info,
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

Widget modalRedirect2FA() {
  return ModalContainer(
    title: 'Vos codes de sauvegarde',
    subtitle: 'Ajouter une méthode de double authentification pour générer vos codes de sauvegarde. Les codes de sauvegarde sont utilisés lorsque vous n\'avez plus accès à votre appareil de double authentification.',
    icon: const IconModal(
        icon: Icon(
          BootstrapIcons.shield_lock_fill,
          color: AppColors.blue700,
          size: 17,
        ),
        type: ModalType.info,
      ),
    footer: Buttons(
            variant: Variante.primary,
            size: SizeButton.md,
            msg: const Text('Activer l\'authentification'),
            onPressed: () {},
          ),
    );
} 