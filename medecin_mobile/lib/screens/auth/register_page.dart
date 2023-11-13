import 'package:flutter/material.dart';
import 'package:medecin_mobile/widgets/buttons.dart';

class Register extends StatelessWidget {
  final Function(int) callback;
  const Register({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo/small-width-blue-edgar-logo.png', width: 200),
            const SizedBox(height: 128),
            Buttons(
              variant: Variante.secondary,
              size: SizeButton.md,
              msg: const Text("Change to Login page!"),
              onPressed: () {
                callback(0);
              },
            ),
          ],
        ),
      ),
    ));
  }
}