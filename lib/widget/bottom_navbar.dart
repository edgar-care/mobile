import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> with TickerProviderStateMixin{
  AnimationController? _animationController;
  Animation<double>? _animation;
  final icons = [
    const Icon(Icons.home),
    const Icon(Icons.calendar_today),
    const Icon(Icons.file_copy),
    const Icon(Icons.person),
    const Icon(Icons.settings),
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onTap(widget.selectedIndex);
      }
    });
  }

  void _onIconTapped(int index) {
    widget.onTap(index);
    _animationController!.forward().whenComplete(() {
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
        // Ajoutez d'autres cas pour les pages supplémentaires
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14.0, left: 14.0, right: 14.0),
      child: 
      Container(
        width: MediaQuery.of(context).size.width * 0.90,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: icons.map((icon) {
            final isSelected = widget.selectedIndex == icons.indexOf(icon);
            final color = isSelected ? Colors.white : AppColors.blue700;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              width: isSelected ? 53.167 : 45,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.blue700 : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
              child: GestureDetector(
                onTap: () => _onIconTapped(icons.indexOf(icon)),
                child: Icon(icon.icon, color: color),
              ),
            );
          }).toList(),
        ),
      ),
  );
  }
}