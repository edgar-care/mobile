import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import '../styles/colors.dart';

class Navbar extends StatefulWidget {
  final Function(int) callback;
  final Function() getSelected;
  const Navbar({super.key, required this.callback, required this.getSelected});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool _isOpened = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
            color: AppColors.blue50,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.callback(0);
                        });
                      },
                      icon: const Icon(
                        BootstrapIcons.house,
                        color: AppColors.blue700,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.callback(1);
                        });
                      },
                      icon: const Icon(
                        BootstrapIcons.person,
                        color: AppColors.blue700,
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            widget.callback(23);
                          });
                        },
                        icon: const Icon(
                          BootstrapIcons.calendar,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.callback(2);
                        });
                      },
                      icon: const Icon(
                        BootstrapIcons.calendar,
                        color: AppColors.blue700,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.callback(3);
                        });
                      },
                      icon: const Icon(
                        BootstrapIcons.folder,
                        color: AppColors.blue700,
                      ),
                    ),
                  ],
                ))),
      ],
    );
  }
}
