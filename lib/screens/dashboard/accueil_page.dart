import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:prototype_1/widget/plain_button.dart';
import 'package:prototype_1/widget/pdf_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map<String, Object> info = {
        'nom': 'Noé',
        'next_rdv_date': '7 mai 2022',
        'next_rdv_horraire': '14 h 15',
        'd': ''
    };

  // ignore: unused_field
 

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Text(
                'Bonjour ${info['nom']}',
                style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(width: 10),
              Image.asset(
                'assets/images/logo/edgar-high-five.png',
                width: 30,
              ),
              const Spacer(),
              IconButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColors.grey200),
                ),
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width * 0.9,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Prochain rendez-vous le',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${info['next_rdv_date']} ',
                          style: const TextStyle(
                            color: Color(0xFF5AAF33),
                            fontSize: 28,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const TextSpan(
                          text: ' à ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '${info['next_rdv_horraire']}',
                          style: const TextStyle(
                            color: Color(0xFF5AAF33),
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
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
            color: Color(0xFF1E2B4D),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        GreenPlainButton(
          text: 'Prendre un rendez-vous',
          onPressed: () {
            Navigator.pushNamed(context, '/warning');
          },
        ),
        const Text(
          'Vos dernier documents recu',
          style: TextStyle(
            color: Color(0xFF1E2B4D),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PDFCard(
              text: 'Document 1',
              pdfUrl:
                  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
            ),
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
}
