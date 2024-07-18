import 'package:Edgar/widget/navbarplus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:edgar/colors.dart';

class CustomBottomBar extends StatefulWidget {
  final void Function(int) onItemTapped;
  final int selectedIndex;
  const CustomBottomBar(
      {super.key, required this.onItemTapped, required this.selectedIndex});

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
        padding: const EdgeInsets.all(8),
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
                  ? AppColors.blue200
                  : Colors.transparent,
              icon: "assets/images/utils/Home.svg",
              onTap: () {
                widget.onItemTapped(0);
              },
            ),
            NavBarItem(
              color: widget.selectedIndex == 1
                  ? AppColors.blue200
                  : Colors.transparent,
              icon: "assets/images/utils/Agenda.svg",
              onTap: () {
                widget.onItemTapped(1);
              },
            ),
            NavBarItem(
              color: widget.selectedIndex == 2
                  ? AppColors.blue200
                  : Colors.transparent,
              icon: "assets/images/utils/Medic.svg",
              onTap: () {
                widget.onItemTapped(2);
              },
            ),
            NavBarItem(
              color: widget.selectedIndex == 3
                  ? AppColors.blue200
                  : Colors.transparent,
              icon: "assets/images/utils/Document.svg",
              onTap: () {
                widget.onItemTapped(3);
              },
            ),
            NavBarItem(
              color: Colors.transparent,
              icon: "assets/images/utils/More.svg",
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder<void>(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return NavbarPLus(
                        onItemTapped: widget.onItemTapped,
                        context: context,
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

  const NavBarItem({
    super.key,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: SvgPicture.asset(
            icon,
            // ignore: deprecated_member_use
            color: AppColors.blue800,
            height: 24,
            width: 24,
          )),
    );
  }
}
