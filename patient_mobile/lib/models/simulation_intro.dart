import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/styles/colors.dart';
import 'package:flutter/material.dart';

class IntroSimulation extends StatefulWidget {
  const IntroSimulation({super.key});

  @override
  State<IntroSimulation> createState() => _IntroSimulatioonState();
}

class _IntroSimulatioonState extends State<IntroSimulation> {
  late final List<Widget> pages;

  int _selectedIndex = 0;

  _IntroSimulatioonState() {
    pages = <Widget>[
      Warnig(updateSelectedIndex: updateSelectedIndex),
      Warning2(updateSelectedIndex: updateSelectedIndex),
      Warning3(updateSelectedIndex: updateSelectedIndex),
    ];
  }

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue700,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 98),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: pages[_selectedIndex],
        ),
      )),
    );
  }
}

class Warnig extends StatelessWidget {
  final Function(int) updateSelectedIndex;
  const Warnig({super.key, required this.updateSelectedIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/logo/edgar-high-five.png',
          width: 240,
          height: 257,
        ),
        const Text(
          'Bienvenue dans votre simulation, je m’appelle Edgar et je serai votre assistant tout au long de cette simulation.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        GestureDetector(
            onTap: () {
              updateSelectedIndex(1);
            },
            child: IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Continuer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue700,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      BootstrapIcons.arrow_right_circle_fill,
                      color: AppColors.blue700,
                      size: 24,
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class Warning2 extends StatelessWidget {
  final Function(int) updateSelectedIndex;
  const Warning2({super.key, required this.updateSelectedIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/logo/edgar-high-five.png',
          width: 240,
          height: 257,
        ),
        const Text(
          'Afin de vous poser les bonnes questions, j’aurai besoin de connaître vos informations de santé.Pour cela, connectez-vous ou créez un compte.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        GestureDetector(
            onTap: () {
              updateSelectedIndex(2);
            },
            child: IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Continuer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue700,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      BootstrapIcons.arrow_right_circle_fill,
                      color: AppColors.blue700,
                      size: 24,
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class Warning3 extends StatelessWidget {
  final Function(int) updateSelectedIndex;
  const Warning3({super.key, required this.updateSelectedIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/logo/edgar-high-five.png',
          width: 240,
          height: 257,
        ),
        const Text(
          'Voilà, tout est prêt pour moi. Vous pouvez dès maintenant commencer votre simulation.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/chat');
            },
            child: IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Commencer ma simulation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue700,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      BootstrapIcons.arrow_right_circle_fill,
                      color: AppColors.blue700,
                      size: 24,
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
