import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
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
                  fontWeight: FontWeight.w600,
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
            border: Border.all(
              color: AppColors.blue200,
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 8),
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
                              const CustomText(
                                txt: 'Mon dossier médical',
                                txtStyles: TxtStyles.md,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const CustomText(
                              txt: "Informations personnelles et médicales",
                              txtStyles: TxtStyles.sm)
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
                              const CustomText(
                                txt: 'Mes traitements',
                                txtStyles: TxtStyles.md,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const CustomText(
                              txt: "Traitements en cours et passés",
                              txtStyles: TxtStyles.sm)
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
                              const CustomText(
                                txt: 'Mes documents',
                                txtStyles: TxtStyles.md,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const CustomText(
                              txt: "Documents personnels et médicaux",
                              txtStyles: TxtStyles.sm)
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
                              const CustomText(
                                txt: 'Ma messagerie',
                                txtStyles: TxtStyles.md,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const CustomText(
                              txt: "Echangez avec les personnels de santé",
                              txtStyles: TxtStyles.sm)
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
