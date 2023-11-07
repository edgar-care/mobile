import 'package:flutter/material.dart';
import 'package:prototype_1/widget/bottom_navbar.dart';
import 'package:prototype_1/screens/dashboard/accueil_page.dart';
import 'package:prototype_1/screens/dashboard/information_personnel.dart';
import 'package:prototype_1/screens/dashboard/gestion_rendez_vous.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});


  @override
  // ignore: library_private_types_in_public_api
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  // ignore: unused_field
  late AnimationController _animationControllers;

  @override
  void initState() {
    super.initState();
    _animationControllers = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(),
      bottomNavigationBar: CustomBottomNavigationBars(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          if (index == 4) {
            setState(() {
              _selectedIndex = index;
            });
            
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _buildPageContent() {
    final pageOptions = [
      const HomePage(),
      const GestionRendezVous(),
      const FilePage(),
      const InformationPersonnel(),
      const SettingsPage(),
    ];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: pageOptions[_selectedIndex],
    );
  }
}


class FilePage extends StatelessWidget {
  const FilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Text('File Page'),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Settings Page');
  }
}
// Ajoutez d'autres classes de page ici