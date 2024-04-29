import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../styles/colors.dart';

class Navbar extends StatefulWidget {
  final Function(int) callback;
  final Function() getSelected;
  const Navbar({super.key, required this.callback, required this.getSelected});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Wrap(
        children: [
          Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                border: BorderDirectional(
                    top: BorderSide(color: AppColors.blue600, width: 0.5)),
              ),
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.loose,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -30,
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isOpen = !isOpen;
                        });
                      },
                      child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: AppColors.blue700,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            isOpen
                                ? BootstrapIcons.chevron_down
                                : BootstrapIcons.chevron_up,
                            color: Colors.white,
                            size: 32,
                          )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.callback(0);
                        },
                        child: Icon(
                          BootstrapIcons.house,
                          color: widget.getSelected() == 0
                              ? AppColors.blue700
                              : AppColors.blue600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.callback(1);
                        },
                        child: Icon(
                          BootstrapIcons.file_text,
                          color: widget.getSelected() == 1
                              ? AppColors.blue700
                              : AppColors.blue600,
                        ),
                      ),
                      const SizedBox(width: 60),
                      GestureDetector(
                        onTap: () {
                          widget.callback(2);
                        },
                        child: Icon(
                          BootstrapIcons.calendar,
                          color: widget.getSelected() == 2
                              ? AppColors.blue700
                              : AppColors.blue600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.callback(3);
                        },
                        child: Icon(
                          BootstrapIcons.person,
                          color: widget.getSelected() == 3
                              ? AppColors.blue700
                              : AppColors.blue600,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          isOpen == true
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 26,
                    runSpacing: 16,
                    children: [
                      CardNavbar(
                        text: 'Vos conversation',
                        callback: widget.callback,
                        index: 4,
                        icon: const Icon(
                          BootstrapIcons.chat,
                          color: AppColors.white,
                        ),
                      ),
                      CardNavbar(
                        text: 'Déconnexion',
                        callback: widget.callback,
                        index: 0,
                        icon: const Icon(
                          BootstrapIcons.box_arrow_right,
                          color: AppColors.white,
                        ),
                        isDeconnexion: true,
                      ),
                    ],
                  ))
              : Container(),
        ],
      ),
    ));
  }
}

// ignore: must_be_immutable
class CardNavbar extends StatelessWidget {
  final String text;
  final Function(int) callback;
  final int index;
  final Icon icon;
  bool? isDeconnexion = false;
  CardNavbar({
    super.key,
    required this.text,
    required this.callback,
    required this.index,
    required this.icon,
    this.isDeconnexion,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isDeconnexion == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('token');
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, '/login');
        } else if (isDeconnexion == false || isDeconnexion == null) {
          callback(index);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blue700,
          borderRadius: BorderRadius.circular(8),
        ),
        width: MediaQuery.of(context).size.width / 2 - 32,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
