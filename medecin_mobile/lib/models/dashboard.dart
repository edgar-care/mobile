import 'package:flutter/material.dart';


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

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const Center(child: Text('Home')),
      const Center(child: Text('Search')),
      const Center(child: Text('Profile')),
    ];
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 24.0),
                pages[_selectedIndex],
              ],
            ),
          ),
        ),
      ),
    );
  }
}