import 'package:edgar_app/services/websocket.dart';
import 'package:edgar_app/utils/chat_utils.dart';
import 'package:edgar_app/widget/navbarplus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:edgar/colors.dart';

// ignore: must_be_immutable
class CustomBottomBar extends StatefulWidget {
  final void Function(int) onItemTapped;
  final int selectedIndex;
  WebSocketService? webSocketService;
  // ignore: prefer_final_fields
  ScrollController scrollController;
  bool isChatting;
  final List<Chat> chats;
  void Function(bool) updateIsChatting;
  CustomBottomBar(
      {super.key,
      required this.onItemTapped,
      required this.selectedIndex,
      required this.chats,
      required this.webSocketService,
      required this.isChatting,
      required this.scrollController,
      required this.updateIsChatting});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.only(left: 26, right: 26, top: 16, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.blue200,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            NavBarItem(
              color: widget.selectedIndex == 0
                  ? AppColors.blue800
                  : AppColors.grey500,
              icon: "assets/images/utils/Home.svg",
              onTap: () {
                widget.onItemTapped(0);
              },
              text: 'Accueil',
            ),
            NavBarItem(
              color: widget.selectedIndex == 1
                  ? AppColors.blue800
                  : AppColors.grey500,
              icon: "assets/images/utils/Agenda.svg",
              onTap: () {
                widget.onItemTapped(1);
              },
              text: 'Agenda',
            ),
            NavBarItem(
              color: widget.selectedIndex == 2 ||
                      widget.selectedIndex == 5 ||
                      widget.selectedIndex == 6 ||
                      widget.selectedIndex == 3 ||
                      widget.selectedIndex == 4
                  ? AppColors.blue800
                  : AppColors.grey500,
              icon: "assets/images/utils/sante.svg",
              onTap: () {
                widget.onItemTapped(2);
              },
              text: 'Santé',
            ),
            NavBarItem(
              color: AppColors.grey500,
              icon: "assets/images/utils/profil.svg",
              text: 'Profil',
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder<void>(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return NavbarPLus(
                        onItemTapped: widget.onItemTapped,
                        context: context,
                        webSocketService: widget.webSocketService,
                        isChatting: widget.isChatting,
                        chats: widget.chats,
                        scrollController: widget.scrollController,
                        updateIsChatting: widget.updateIsChatting,
                      );
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const curve = Curves.easeInOut;
                      return FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(parent: animation, curve: curve)),
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final Color color;
  final String icon;
  final VoidCallback onTap;
  final String text;

  const NavBarItem({
    super.key,
    required this.color,
    required this.icon,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: SvgPicture.asset(
              icon,
              // ignore: deprecated_member_use
              color: color,
              height: 20,
              width: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
