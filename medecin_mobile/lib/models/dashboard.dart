import 'package:edgar_pro/screens/dashboard/agenda_page.dart';
import 'package:edgar_pro/screens/dashboard/document_page.dart';
import 'package:edgar_pro/screens/dashboard/patient_list_page.dart';
import 'package:edgar_pro/screens/dashboard/diagnostic_page.dart';
import 'package:edgar_pro/screens/dashboard/patientele_page.dart';
import 'package:edgar_pro/screens/dashboard/rdv_page.dart';
import 'package:edgar_pro/screens/dashboard/rdv_patient_page.dart';
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
  String _id = "";

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int getSelectedIndex() {
    return _selectedIndex;
  }

  void updateId(String id) {
    setState(() {
      _id = id;
    });
  }

  String getId() {
    return _id;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const Agenda(),
      Patient(
        setPages: updateSelectedIndex, setId: updateId
      ),
      const Rdv(),
      const Diagnostic(),
      const Text('Aide',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: AppColors.blue950)),
      Text('Dossier médical: ${getId()}',style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: AppColors.blue950)),
      PatientPageRdv(id: getId(), setPages: updateSelectedIndex, setId: updateId,),
      DocumentPage(id: _id, setPages: updateSelectedIndex, setId: updateId,),
      Text('Messagerie: $_id',style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: AppColors.blue950)),
      const Text('Aide',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.blue950)),
      PatientPage(id: getId(), setPages: updateSelectedIndex, setId: updateId),
      PatientPageRdv(
        id: getId(),
        setPages: updateSelectedIndex,
        setId: updateId,
      ),
      DocumentPage(
        id: _id,
        setPages: updateSelectedIndex,
        setId: updateId,
      ),
      Text('Messagerie: $_id',
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.blue950)),
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
