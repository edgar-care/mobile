import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo/full-width-white-edgar-logo.png",
                width: 164),
            const SizedBox(height: 20),
            Image.asset("assets/images/logo/edgar-high-five.png", width: 82),
            const SizedBox(height: 100),
            EmptyButton(text: "Enregistrez-vous", onPressed: () {
              Navigator.pushNamed(context, '/register');
            
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class EmptyButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const EmptyButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        side: const BorderSide(color: AppColors.lightBlue, width: 2),
        minimumSize: const Size(180, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }
}
