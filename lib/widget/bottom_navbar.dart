import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';


class BottomNavBar extends StatefulWidget {
  final int index;
  const BottomNavBar({Key? key, this.index = 0}) : super(key: key);
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

    void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to the corresponding page
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/calendar');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/file');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/person');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
      // Add more cases for additional pages
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0, left: 14.0, right: 14.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.80, // 80% de la largeur de l'écran
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30), // rayon de la bordure
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 0), // change la position de l'ombre
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.home, 0),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.calendar_today, 1),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.file_copy, 2),
              label: '',
                          ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.person_outline, 3),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.settings, 4),
              label: '',
            ),
            // Ajoutez d'autres éléments ici
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData iconData, int index) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: _currentIndex == index ? AppColors.blue700 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(iconData, color: _currentIndex == index ? Colors.white :AppColors.blue700),
    );
  }
}