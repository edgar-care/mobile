import 'package:flutter/material.dart';
import 'package:medecin_mobile/styles/colors.dart';
import 'package:medecin_mobile/widgets/appbar.dart';


class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

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

  int getSelectedIndex(){
    return _selectedIndex;
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const Text('Agenda', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.blue950),),
      const Text('Patientèle', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.blue950)),
      const Text('Aide', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.blue950)),
      const Text("Déconnexion", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.blue950)),
    ];
    return Scaffold(
      body:SafeArea(
        child:Padding (
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Stack(
            children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 80,),
                            child : 
                              pages[_selectedIndex],
                        ),
                      ),
                      CustomAppBar(callback: updateSelectedIndex,getSelected: getSelectedIndex,),
                  ]),
        ),
      ),
    );
  }
}