import 'package:edgar_pro/widgets/navbarplus.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter_svg/svg.dart';

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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.blue200,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 48,
          children: <Widget>[
            NavBarItem(
              color: widget.selectedIndex == 0 ? true : false,
              icon: "assets/images/utils/calendar-week-fill.svg",
              onTap: () {
                widget.onItemTapped(0);
              },
              text: "Agenda",
            ),
            NavBarItem(
              color: widget.selectedIndex == 1 ? true : false,
              icon: "assets/images/utils/calendar2-check-fill.svg",
              onTap: () {
                widget.onItemTapped(1);
              },
              text: "Rdv",
            ),
            NavBarItem(
              color: (widget.selectedIndex == 2 ||
                      widget.selectedIndex == 3 ||
                      widget.selectedIndex == 4 ||
                      widget.selectedIndex == 5)
                  ? true
                  : false,
              icon: "assets/images/utils/clipboard2-pulse-fill.svg",
              onTap: () {
                widget.onItemTapped(2);
              },
              text: "Services",
            ),
            NavBarItem(
              color: false,
              icon: "assets/images/utils/person-fill.svg",
              text: "Profil",
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
  final bool color;
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
        child: Column(children: [
          SvgPicture.asset(
            icon,
            // ignore: deprecated_member_use
            color: color == true ? AppColors.blue800 : AppColors.grey500,
            height: 25,
            width: 25,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            text,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: color == true ? AppColors.blue800 : AppColors.grey500),
          )
        ]));
  }
}
