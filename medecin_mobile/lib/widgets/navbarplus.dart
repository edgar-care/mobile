// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:edgar_pro/services/doctor_services.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

class NavbarPLus extends StatefulWidget {
  final void Function(int) onItemTapped;
  final BuildContext context;
  const NavbarPLus(
      {super.key, required this.onItemTapped, required this.context});

  @override
  State<NavbarPLus> createState() => _NavbarPLusState();
}

class _NavbarPLusState extends State<NavbarPLus> {
  Map<String, dynamic> infoMedical = {};
  String idDoctor = '';

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
    } else {
      if (token.isNotEmpty) {
        String encodedPayload = token.split('.')[1];
        String decodedPayload =
            utf8.decode(base64.decode(base64.normalize(encodedPayload)));
        idDoctor = jsonDecode(decodedPayload)['doctor']["id"];
      }
      fetchData();
    }
  }

  Future<void> fetchData() async {
    await getAllDoctor().then((value) {
      setState(() {
        infoMedical = value.where((element) {
          return element['id'] == idDoctor;
        }).first;
      });
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
                            const Text('Profil et paramètres',
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
                                              child: BoringAvatars(
                                                name:
                                                    "${infoMedical['firstname']} ${infoMedical['name'].toUpperCase()}",
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
                                                "${infoMedical['firstname']} ${infoMedical['name'].toUpperCase()}",
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
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text("Paramètres du compte", style: TextStyle(fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w500),),
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
                                            pageBuilder: (BuildContext context, _, __) {
                                              return const SizedBox();
                                            },
                                          ),
                                        
                                        );
                                        Navigator.pop(context);
                                      },
                                      type: 'Only',
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
                                        'assets/images/utils/arrow-right-circle-fill.svg',
                                        // ignore: deprecated_member_use
                                        color: AppColors.red600,
                                        height: 18,
                                      ),
                                      title: 'Déconnexion',
                                      onTap: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.remove('token');
                                        Navigator.pushNamed(context, '/login');
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

  const NavbarPLusTab(
      {super.key,
      this.icon,
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
