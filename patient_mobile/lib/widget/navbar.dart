import 'package:flutter/material.dart';

import 'package:prototype_1/styles/colors.dart';
import 'package:prototype_1/widget/plain_button.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.blue700,
      title: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/');
        },
        child: Container(
          margin: const EdgeInsets.only(left: 42),
          child: Image.asset(
            'assets/images/logo/full-width-white-edgar-logo.png',
            height: 42, // center navbar height to 10% of screen height
          ),
        ),
      ),
      actions: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 42),
              child: PlainBorderButton(
                text: 'Espace patient',
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(60); // center navbar height to 10% of screen height
}
