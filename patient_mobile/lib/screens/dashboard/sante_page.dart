import 'package:edgar/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SantePage extends StatefulWidget {
  final void Function(int) onItemTapped;
  const SantePage({super.key, required this.onItemTapped});

  @override
  State<SantePage> createState() => _SantePageState();
}

class _SantePageState extends State<SantePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            color: AppColors.blue700,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Image.asset(
                'assets/images/logo/edgar-high-five.png',
                width: 40,
              ),
              const SizedBox(width: 16),
              const Text(
                'Ma santé',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.white,
            border: Border.all(
              color: AppColors.blue200,
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  widget.onItemTapped(5);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/utils/MedicalFolder.svg',
                                // ignore: deprecated_member_use
                                color: AppColors.black,
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Mon dossier médical",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Informations personnelles et médicales",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      SvgPicture.asset(
                        'assets/images/utils/chevron-right.svg',
                        // ignore: deprecated_member_use
                        color: AppColors.blue800,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 1,
                color: AppColors.blue200,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  widget.onItemTapped(3);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/utils/Union-lg.svg',
                                // ignore: deprecated_member_use
                                color: AppColors.black,
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Mes traitements",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Traitements en cours et passés",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      SvgPicture.asset(
                        'assets/images/utils/chevron-right.svg',
                        // ignore: deprecated_member_use
                        color: AppColors.blue800,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 1,
                color: AppColors.blue200,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  widget.onItemTapped(4);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/utils/Document.svg',
                                // ignore: deprecated_member_use
                                color: AppColors.black,
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Mes documents",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Documents personnels et médicaux",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      SvgPicture.asset(
                        'assets/images/utils/chevron-right.svg',
                        // ignore: deprecated_member_use
                        color: AppColors.blue800,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 1,
                color: AppColors.blue200,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  widget.onItemTapped(6);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/utils/Messagerie.svg',
                                // ignore: deprecated_member_use
                                color: AppColors.black,
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Ma messagerie",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Echangez avec les personnels de santé",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      SvgPicture.asset(
                        'assets/images/utils/chevron-right.svg',
                        // ignore: deprecated_member_use
                        color: AppColors.blue800,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
