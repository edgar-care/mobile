import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      Warning4(updateSelectedIndex: updateSelectedIndex),
      Warning5(updateSelectedIndex: updateSelectedIndex),
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
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: const EdgeInsets.only(top: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/images/logo/newLogosvg.svg',
                  width: 200,
                  height: 60,
                ),
                SvgPicture.asset(
                  'assets/images/utils/Edgar_cut.svg',
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: pages[_selectedIndex],
          ),
        ],
      )),
    );
  }
}

class Warnig extends StatelessWidget {
  final Function(int) updateSelectedIndex;
  const Warnig({super.key, required this.updateSelectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32, top: 16),
      height: MediaQuery.of(context).size.height * 0.5 - 28,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Bienvenue dans votre simulation. Je m’appelle Edgar et je serai votre assistant tout au long de cette simulation.',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    fontFamily: 'Poppins'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              GestureDetector(
                onTap: () {
                  updateSelectedIndex(1);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.blue700,
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
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        BootstrapIcons.arrow_right_circle_fill,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Warning2 extends StatelessWidget {
  final Function(int) updateSelectedIndex;
  const Warning2({super.key, required this.updateSelectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32, top: 16),
      height: MediaQuery.of(context).size.height * 0.5 - 28,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Avant de commencer votre simulation, notez que cette simulation n’a pas pour but de diagnostiquer une maladie.',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    fontFamily: 'Poppins'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              GestureDetector(
                onTap: () {
                  updateSelectedIndex(2);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.blue700,
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
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        BootstrapIcons.arrow_right_circle_fill,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Warning3 extends StatelessWidget {
  final Function(int) updateSelectedIndex;
  const Warning3({super.key, required this.updateSelectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32, top: 16),
      height: MediaQuery.of(context).size.height * 0.5 - 28,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'A l’issue de la simulation, notre échange sera transmis à un médecin afin d’être examiné.',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    fontFamily: 'Poppins'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              GestureDetector(
                onTap: () {
                  updateSelectedIndex(3);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.blue700,
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
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        BootstrapIcons.arrow_right_circle_fill,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Warning4 extends StatelessWidget {
  final Function(int) updateSelectedIndex;
  const Warning4({super.key, required this.updateSelectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32, top: 16),
      height: MediaQuery.of(context).size.height * 0.5 - 28,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Si votre rendez-vous n’est pas utile alors il sera annulé par le médecin et il vous conseillera des méthodes de soins.',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    fontFamily: 'Poppins'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              GestureDetector(
                onTap: () {
                  updateSelectedIndex(4);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.blue700,
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
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        BootstrapIcons.arrow_right_circle_fill,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Warning5 extends StatelessWidget {
  final Function(int) updateSelectedIndex;
  const Warning5({super.key, required this.updateSelectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32, top: 16),
      height: MediaQuery.of(context).size.height * 0.5 - 28,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Voilà, tout est prêt pour moi. Vous pouvez dès maintenant commencer votre simulation.',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    fontFamily: 'Poppins'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/chat');
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.blue700,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Commencer',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        BootstrapIcons.arrow_right_circle_fill,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
