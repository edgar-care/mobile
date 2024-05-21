import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/services/doctor.dart';
import 'package:edgar/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  @override
  initState() {
    super.initState();
    fetchdata();
  }

  String doctorId = '';
  String doctorName = '';
  String startDate = '';
  String endDate = '';
  String day = '';
  List<dynamic> doctors = [];

  Future<void> fetchdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    doctors = await getAllDoctor();
    setState(() {
      doctorId = prefs.getString('appointment_doctor_id')!;
      doctorName = doctors
              .firstWhere((element) => element['id'] == doctorId)['name'] +
          ' ' +
          doctors
              .firstWhere((element) => element['id'] == doctorId)['firstname']
              .toUpperCase();
      startDate = prefs.getString('appointment_start_date')!;
      endDate = prefs.getString('appointment_end_date')!;
      day =
          '${DateTime.fromMillisecondsSinceEpoch(int.parse(startDate) * 1000, isUtc: true).day.toString().padLeft(2, '0')}/${DateTime.fromMillisecondsSinceEpoch(int.parse(startDate) * 1000, isUtc: true).month.toString().padLeft(2, '0')}/${DateTime.fromMillisecondsSinceEpoch(int.parse(startDate) * 1000, isUtc: true).year}';
      startDate =
          '${DateTime.fromMillisecondsSinceEpoch(int.parse(startDate) * 1000, isUtc: true).hour.toString().padLeft(2, '0')}h${DateTime.fromMillisecondsSinceEpoch(int.parse(startDate) * 1000, isUtc: true).minute.toString().padLeft(2, '0')}';
      endDate =
          '${DateTime.fromMillisecondsSinceEpoch(int.parse(endDate) * 1000, isUtc: true).hour.toString().padLeft(2, '0')}h${DateTime.fromMillisecondsSinceEpoch(int.parse(endDate) * 1000, isUtc: true).minute.toString().padLeft(2, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue700,
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: const EdgeInsets.only(top: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/images/logo/newLogosvg.svg',
                  width: 200,
                  height: 60,
                ),
                SvgPicture.asset(
                  'assets/images/utils/Edgar_cut.svg',
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 32, right: 32, bottom: 32, top: 16),
            height: MediaQuery.of(context).size.height * 0.5 - 28,
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                'Merci pour cet échange. Votre rendez-vous chez le Dr $doctorName le ',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          TextSpan(
                            text: day,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.green400,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const TextSpan(
                            text: ' de ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          TextSpan(
                            text: startDate,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.green400,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const TextSpan(
                            text: ' à',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          TextSpan(
                            text: ' $endDate ',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.green400,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const TextSpan(
                            text: 'a bien été validé.',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/dashboard');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.blue700,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Espace patient',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(width: 16),
                            Icon(
                              BootstrapIcons.arrow_right_circle_fill,
                              color: AppColors.white,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
