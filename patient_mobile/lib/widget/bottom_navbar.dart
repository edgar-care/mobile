import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class CustomBottomNavigationBars extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const CustomBottomNavigationBars({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomNavigationBarsState createState() =>
      _CustomBottomNavigationBarsState();
}

class _CustomBottomNavigationBarsState extends State<CustomBottomNavigationBars>
    with TickerProviderStateMixin {
  final icons = [
    const Icon(BootstrapIcons.house),
    const Icon(BootstrapIcons.calendar),
    const Icon(BootstrapIcons.file_text),
    const Icon(BootstrapIcons.person),
    const Icon(BootstrapIcons.gear),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14.0, left: 14.0, right: 14.0),
      child: Container(
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
          children: icons.asMap().entries.map((entry) {
            final index = entry.key;
            final icon = entry.value;
            final isSelected = widget.selectedIndex == index;
            final color = isSelected ? Colors.white : AppColors.blue700;

            return GestureDetector(
              onTap: () {
                widget.onTap(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                width: isSelected ? 53.167 : 45,
                height: 60,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.blue700 : Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(icon.icon, color: color),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}