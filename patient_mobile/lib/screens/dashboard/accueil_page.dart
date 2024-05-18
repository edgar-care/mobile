// ignore_for_file: use_build_context_synchronously

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/services/get_information_patient.dart';
import 'package:edgar/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/plain_button.dart';
import 'package:edgar/widget/pdf_card.dart';
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> infoMedical = {};

  final List<Map<String, String>> rdv = [];

  Future<void> fetchData() async {
    await getMedicalFolder().then((value) {
      if (value.isNotEmpty) {
        infoMedical = value;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
            message: "Error on fetching name", context: context));
      }
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.blue700,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Erreur lors du chargement des données'),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    'Bonjour ${infoMedical['name']}',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/images/logo/edgar-high-five.png',
                    width: 40,
                  ),
                  const Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(AppColors.grey200),
                    ),
                    icon: const Icon(
                      BootstrapIcons.bell,
                      color: AppColors.blue950,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.9,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Prochain rendez-vous le',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Jeudi 12 Août',
                                style: TextStyle(
                                  color: Color(0xFF5AAF33),
                                  fontSize: 24,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: '  à  ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: '14 h 30',
                                style: TextStyle(
                                  color: Color(0xFF5AAF33),
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Text(
                'Vous voulez prendre un nouveau\nrendez-vous ?',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
                textAlign: TextAlign.center,
              ),
              GreenPlainButton(
                text: 'Prendre un rendez-vous',
                onPressed: () {
                  Navigator.pushNamed(context, '/simulation/intro');
                },
              ),
              const Text(
                'Vos dernier documents reçus',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PDFCard(
                    text: 'Document 1',
                    pdfUrl:
                        'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                  ),
                  SizedBox(width: 10),
                  PDFCard(
                    text: 'Document 2',
                    pdfUrl:
                        'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
