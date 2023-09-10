import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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


// class BottomNavBar extends StatelessWidget {
//   const BottomNavBar({Key? key}) : super(key: key);

//    void index(int index, BuildContext context) {
//     switch (index) {
//       case 0:
//         Navigator.pushNamed(context, '/accueil-page');
//         break;
//       case 1:
//         Navigator.pushNamed(context, '/agenda');
//         break;
//       case 2:
//         Navigator.pushNamed(context, '/file');
//         break;
//       case 3:
//         Navigator.pushNamed(context, '/persona');
//         break;
//       case 4:
//         Navigator.pushNamed(context, '/parametre');
//         break;
//     }
//   }

//  @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14.0, left: 14.0, right: 14.0),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.80, // 95% de la largeur de l'écran
//         height: 70,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(50), // rayon de la bordure
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               spreadRadius: 2,
//               blurRadius: 4,
//               offset: const Offset(0, 0), // change la position de l'ombre
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           elevation: 30,
//           type: BottomNavigationBarType.fixed,
//           currentIndex: 0,
//           onTap: (int index) => this.index(index, context),
//           backgroundColor: Colors.transparent, // le rend transparent
//           items: const  <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//               icon: SizedBox(
//                 width: 50,
//                 height: 60,
//                 child: Icon(Icons.home, color: AppColors.blue700),
//               ),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon:  SizedBox(
//                 width: 50,
//                 height: 60,
//                 child: Icon(Icons.calendar_today, color: AppColors.blue700),
//               ),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: SizedBox(
//                 width: 50,
//                 height: 60,
//                 child: Icon(Icons.file_copy, color: AppColors.blue700),
//               ),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: SizedBox(
//                 width: 50,
//                 height: 60,
//                 child:  Icon(Icons.person_outline, color: AppColors.blue700),
//               ),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: SizedBox(
//                 width: 50,
//                 height: 60,
//                 child: Icon(Icons.settings, color: AppColors.blue700),
//               ),
//               label: '',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


