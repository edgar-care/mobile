import 'package:edgar_pro/screens/dashboard/agenda_page.dart';
import 'package:edgar_pro/screens/dashboard/patientele_page.dart';
import 'package:edgar_pro/screens/dashboard/rdv_page.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/appbar.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedIndex = 0;

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int getSelectedIndex() {
    return _selectedIndex;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const Agenda(),
      const Patient(),
      const Rdv(),
      const Text('Aide',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: AppColors.blue950)),
    ];
    return Scaffold(
      backgroundColor: AppColors.blue50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Stack(children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 80,
                ),
                child: pages[_selectedIndex],
              ),
            ),
            CustomAppBar(
              callback: updateSelectedIndex,
              getSelected: getSelectedIndex,
            ),
          ]),
        ),
      ),
    );
  }
}
