import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_pro/services/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Desactivate extends StatelessWidget {
  const Desactivate({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      // Wrapper pour gérer le retour natif
      onWillPop: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/');
        return false; // On retourne false pour empêcher le comportement par défaut
      },
      child: Scaffold(
        backgroundColor: AppColors.blue700,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/images/utils/DesactivateIcon.svg',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Votre compte est désactivé',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const Text(
                    "Afin d'accéder à votre espace patient, vous devez réactiver votre compte.",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 64),
                  Buttons(
                    variant: Variant.primary,
                    size: SizeButton.md,
                    msg: Text("Activer mon compte"),
                    onPressed: () async {
                      await enableAccount(context).then((value) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, '/dashboard');
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Buttons(
                    variant: Variant.secondary,
                    size: SizeButton.md,
                    msg: Text("Garder mon compte désactivé"),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('token');
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                  Spacer(),
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/logo/logoFullColorWithNAmeApp.svg',
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
