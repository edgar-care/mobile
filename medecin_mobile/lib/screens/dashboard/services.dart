import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/colors.dart';
import 'package:flutter/material.dart';

class Services extends StatefulWidget {
  final Function tapped;
  const Services({super.key, required this.tapped});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          key: const ValueKey("Header"),
          decoration: BoxDecoration(
            color: AppColors.blue700,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(children: [
              Image.asset(
                "assets/images/logo/edgar-high-five.png",
                height: 40,
                width: 37,
              ),
              const SizedBox(
                width: 16,
              ),
              const Text(
                "Mes services",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: AppColors.white),
              ),
            ]),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.blue200, width: 1)),
          child: Column(
            children: [
              BarItem(
                  title: "Mes patients",
                  bottomText: "Toutes les informations de vos patients",
                  icon: BootstrapIcons.capsule,
                  ontap: () {
                    widget.tapped(3);
                  }),
              const Divider(
                thickness: 1,
                color: AppColors.blue100,
              ),
              BarItem(
                  title: "Mes diagnostics",
                  bottomText: "Diagnostics en attente de validation",
                  icon: BootstrapIcons.file_earmark_text_fill,
                  ontap: () {
                    widget.tapped(4);
                  }),
              const Divider(
                thickness: 1,
                color: AppColors.blue100,
              ),
              BarItem(
                  title: "Ma messagerie",
                  bottomText: "Echangez avec vos patients",
                  icon: BootstrapIcons.chat_dots_fill,
                  ontap: () {
                    widget.tapped(5);
                  }),
            ],
          ),
        ),
      ],
    );
  }
}

class BarItem extends StatelessWidget {
  const BarItem(
      {super.key,
      required this.title,
      required this.bottomText,
      required this.icon,
      required this.ontap});

  final String bottomText;
  final IconData? icon;
  final Function() ontap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
            onTap: ontap,
            child: Container(
              color: AppColors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            icon,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            title,
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        bottomText,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      )
                    ],
                  ),
                  const Icon(
                    BootstrapIcons.chevron_right,
                    size: 16,
                  ),
                ],
              ),
            )));
  }
}
