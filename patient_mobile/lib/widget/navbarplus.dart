// ignore_for_file: use_build_context_synchronously

import 'package:edgar_app/models/dashboard.dart';
import 'package:edgar_app/screens/2fa/account_page.dart';
import 'package:edgar_app/screens/2fa/devices_page.dart';
import 'package:edgar_app/services/get_information_patient.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_app/services/logout_service.dart';
import 'package:edgar_app/services/websocket.dart';
import 'package:edgar_app/utils/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

// ignore: must_be_immutable
class NavbarPLus extends StatefulWidget {
  final void Function(int) onItemTapped;
  final BuildContext context;
  WebSocketService? webSocketService;
  // ignore: prefer_final_fields
  ScrollController scrollController;
  bool isChatting;
  final List<Chat> chats;
  void Function(bool) updateIsChatting;
  NavbarPLus(
      {super.key,
      required this.onItemTapped,
      required this.context,
      required this.chats,
      required this.webSocketService,
      required this.isChatting,
      required this.scrollController,
      required this.updateIsChatting});

  @override
  State<NavbarPLus> createState() => _NavbarPLusState();
}

class _NavbarPLusState extends State<NavbarPLus> {
  Map<String, dynamic> infoMedical = {};
  String birthdate = '';

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      Navigator.pushNamed(context, '/login');
    }
  }

  Future<void> fetchData() async {
    await getMedicalFolder(context).then((value) {
      if (value.isNotEmpty) {
        infoMedical = value;
        birthdate = DateFormat('dd/MM/yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
                infoMedical['birthdate'] * 1000));
      } else {
        TopErrorSnackBar(message: "Erreur lors de la récupération des données")
            .show(context);
      }
    });
  }

  void handleBack() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder<void>(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return const DashBoardPage();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeInOut;
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: curve)),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Utilisation de PopScope au lieu de WillPopScope
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) async {
        if (didPop) return;
        handleBack();
      },
      child: Scaffold(
        // Retiré MaterialApp, gardé uniquement Scaffold
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: handleBack,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/utils/arrowNavbar.svg',
                            // ignore: deprecated_member_use
                            color: AppColors.black,
                            height: 16,
                          ),
                          const SizedBox(width: 8),
                          const Text('Revenir en arrière',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              )),
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
                                child: FutureBuilder(
                                  future: fetchData(),
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
                                                  child:
                                                      LinearProgressIndicator(
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
                                                  child:
                                                      LinearProgressIndicator(
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
                                          Container(
                                              width: 48,
                                              height: 48,
                                              decoration: const BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50)),
                                              ),
                                              child: BoringAvatar(
                                                name:
                                                    "${infoMedical['firstname']} ${infoMedical['name'].toUpperCase()}",
                                                palette: BoringAvatarPalette(
                                                  const [
                                                    AppColors.blue700,
                                                    AppColors.blue200,
                                                    AppColors.blue500
                                                  ],
                                                ),
                                                type: BoringAvatarType.beam,
                                                shape: CircleBorder(),
                                              )),
                                          const SizedBox(width: 16),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${infoMedical['firstname']} ${infoMedical['name'].toUpperCase()}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                              if (infoMedical['sex'] ==
                                                      "MALE" ||
                                                  infoMedical['sex'] ==
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
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  border: Border(
                                    left: BorderSide(
                                        color: AppColors.blue200, width: 1),
                                    right: BorderSide(
                                        color: AppColors.blue200, width: 1),
                                    bottom: BorderSide(
                                        color: AppColors.blue200, width: 1),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    NavbarPLusTab(
                                      icon: SvgPicture.asset(
                                        'assets/images/utils/proches.svg',
                                        // ignore: deprecated_member_use
                                        color: AppColors.black,
                                        height: 18,
                                      ),
                                      title: 'Mes proches',
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      type: 'Middle',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Paramètres du compte",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
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
                                    color: AppColors.blue200,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    NavbarPLusTab(
                                      icon: SvgPicture.asset(
                                        'assets/images/utils/person-fill.svg',
                                        // ignore: deprecated_member_use
                                        color: AppColors.black,
                                        height: 18,
                                      ),
                                      title: 'Compte',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder<void>(
                                            opaque: false,
                                            pageBuilder:
                                                (BuildContext context, _, __) {
                                              return AccountPage(
                                                infoMedical: infoMedical,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      type: 'Top',
                                      outlineIcon: SvgPicture.asset(
                                        'assets/images/utils/chevron-right.svg',
                                      ),
                                    ),
                                    NavbarPLusTab(
                                      icon: SvgPicture.asset(
                                        'assets/images/utils/laptop-fill.svg',
                                        // ignore: deprecated_member_use
                                        color: AppColors.black,
                                        height: 18,
                                      ),
                                      title: 'Appareils',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder<void>(
                                            opaque: false,
                                            pageBuilder:
                                                (BuildContext context, _, __) {
                                              return const DevicesPage();
                                            },
                                          ),
                                        );
                                      },
                                      type: 'Bottom',
                                      outlineIcon: SvgPicture.asset(
                                        'assets/images/utils/chevron-right.svg',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
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
                                      icon: SvgPicture.asset(
                                        'assets/images/utils/ArrowRightCircle.svg',
                                        // ignore: deprecated_member_use
                                        color: AppColors.black,
                                        height: 18,
                                      ),
                                      title: 'Déconnexion',
                                      onTap: () async {
                                        logout(context);
                                      },
                                      type: 'Only',
                                      color: AppColors.red600,
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

class NavbarPLusTab extends StatefulWidget {
  final Widget? icon;
  final String title;
  final Function onTap;
  final String type; // Ajout de la propriété type
  final Widget? outlineIcon;
  final Color? color;
  final bool? isActive;

  const NavbarPLusTab(
      {super.key,
      this.icon,
      this.isActive,
      required this.title,
      required this.onTap,
      required this.type,
      this.outlineIcon,
      this.color}); // Ajout du paramètre type

  @override
  State<NavbarPLusTab> createState() => _NavbarPLusTabState();
}

class _NavbarPLusTabState extends State<NavbarPLusTab> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(
            bottom: widget.type == 'Bottom' || widget.type == 'Only'
                ? const BorderSide(color: Colors.transparent, width: 1)
                : const BorderSide(color: AppColors.blue200, width: 1),
          ),
          borderRadius: BorderRadius.only(
            topLeft: widget.type == 'Only' || widget.type == 'Top'
                ? const Radius.circular(16)
                : const Radius.circular(0),
            topRight: widget.type == 'Only' || widget.type == 'Top'
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomLeft: widget.type == 'Bottom' || widget.type == 'Only'
                ? const Radius.circular(18)
                : const Radius.circular(0),
            bottomRight: widget.type == 'Bottom' || widget.type == 'Only'
                ? const Radius.circular(18)
                : const Radius.circular(0),
          ),
        ),
        child: Row(
          children: [
            widget.icon ?? const SizedBox.shrink(),
            const SizedBox(width: 16),
            Text(widget.title,
                style: TextStyle(
                  fontSize: 14,
                  color: widget.color ?? AppColors.black, // Ajout de la couleur
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                )),
            const Spacer(),
            if (widget.isActive != null) ...[
              widget.isActive!
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.green100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Activée",
                        style: TextStyle(
                            color: AppColors.green700,
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.red100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Désactivée",
                        style: TextStyle(
                            color: AppColors.red700,
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
              const SizedBox(width: 16),
            ],
            widget.outlineIcon ?? const SizedBox.shrink(),
          ],
        ),
      ),
      onTap: () {
        widget.onTap();
      },
    );
  }
}
