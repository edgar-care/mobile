import 'package:flutter/material.dart';
import 'package:edgar/screens/dashboard/accueil_page.dart';
import 'package:edgar/screens/dashboard/information_personnel.dart';
import 'package:edgar/screens/dashboard/gestion_rendez_vous.dart';
import 'package:edgar/screens/dashboard/file_page.dart';
import 'package:edgar/widget/custom_navbar.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;

  final List<Widget> pages = <Widget>[
    const HomePage(),
    const InformationPersonnel(),
    const GestionRendezVous(),
    const FilePage(),
  ];

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int getSelectedIndex() {
    return _selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 80,
                    ),
                    child: pages[_selectedIndex],
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Navbar(
                      callback: updateSelectedIndex,
                      getSelected: getSelectedIndex,
                    )),
              ],
            )),
      ),
    );
  }
}
