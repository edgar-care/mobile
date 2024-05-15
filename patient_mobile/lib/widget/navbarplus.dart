import 'package:edgar/models/dashboard.dart';
import 'package:edgar/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavbarPLus extends StatefulWidget {
  final void Function(int) onItemTapped;
  final BuildContext context;
  const NavbarPLus(
      {super.key, required this.onItemTapped, required this.context});

  @override
  State<NavbarPLus> createState() => _NavbarPLusState();
}

class _NavbarPLusState extends State<NavbarPLus> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder<void>(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return const DashBoardPage();
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const curve = Curves.easeInOut;
                              return FadeTransition(
                                opacity: Tween<double>(begin: 0.0, end: 1.0)
                                    .animate(CurvedAnimation(
                                        parent: animation, curve: curve)),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back_ios,
                              color: Colors.black, size: 16),
                          SizedBox(width: 8),
                          Text('Revenir en arrière',
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
                                    ),
                                    const SizedBox(width: 16),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'John Doe',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                        Text(
                                          'Né le 23/04/2024',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
                                      icon: const Icon(Icons.medical_services,
                                          color: AppColors.black, size: 16),
                                      title: 'Dossier médical',
                                      onTap: () {
                                        widget.onItemTapped(4);
                                        Navigator.pop(context);
                                      },
                                      type: 'Middle',
                                    ),
                                    NavbarPLusTab(
                                      icon: const Icon(
                                          Icons.chat_bubble_rounded,
                                          color: AppColors.black,
                                          size: 16),
                                      title: 'Messagerie',
                                      onTap: () {
                                        widget.onItemTapped(5);
                                        Navigator.pop(context);
                                      },
                                      type: 'Bottom',
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
                                      icon: const Icon(
                                          Icons.arrow_circle_right_rounded,
                                          color: AppColors.black,
                                          size: 16),
                                      title: 'Deconnexion',
                                      onTap: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.remove('token');
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(widget.context);
                                      },
                                      type: 'Bottom',
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
  final Widget icon;
  final String title;
  final Function onTap;
  final String type; // Ajout de la propriété type
  final Widget? outlineIcon;
  final Color? color;

  const NavbarPLusTab(
      {super.key,
      required this.icon,
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
            bottom: widget.type == 'Bottom'
                ? const BorderSide(color: Colors.transparent, width: 1)
                : const BorderSide(color: AppColors.blue200, width: 1),
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: widget.type == 'Bottom'
                ? const Radius.circular(18)
                : const Radius.circular(0),
            bottomRight: widget.type == 'Bottom'
                ? const Radius.circular(18)
                : const Radius.circular(0),
          ),
        ),
        child: Row(
          children: [
            widget.icon,
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
