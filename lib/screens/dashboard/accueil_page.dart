// ignore_for_file: use_build_context_synchronously

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prototype_1/services/get_appointement.dart';
import 'package:prototype_1/services/get_information_patient.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:prototype_1/widget/plain_button.dart';
import 'package:prototype_1/widget/pdf_card.dart';
import 'package:logger/logger.dart';
import 'package:intl/date_symbol_data_local.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    fetchData(context);
  }
  Map<String, Object>? infoMedical = {};

  final List<Map<String, String>> rdv = [];

  Map<String, Object> info = {
        'd': '',
        'nom': 'Noé',
        'next_rdv_date': 'Lundi 24 octobre',
        'next_rdv_horraire': '14 h 30',
    };

  Future<void> fetchData(BuildContext context) async {
    infoMedical = await getInformationPersonnel(context);
    final Map<String, dynamic>? rdvs = await getAppointement(context);
    if (rdvs != null) {
      final uniqueRdv = <Map<String, String>>{}; // Utiliser un Set pour stocker les rendez-vous uniques
      rdvs['rdv'].forEach((dynamic rdv) {
        final rendezVous = {
          'date': DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(rdv['start_date'] * 1000)),
          'heure': DateFormat('HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(rdv['start_date'] * 1000)),
          'fin': DateFormat('HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(rdv['end_date'] * 1000)),
          'medecin': 'Dr. ${rdv['doctor_id'] as String}',
          'adresse': '123 Rue de la Santé, Paris',
        };
        uniqueRdv.add(rendezVous); // Ajouter le rendez-vous au Set
      });
      rdv.addAll(uniqueRdv.toList()); // Convertir le Set en une liste et l'ajouter à rdv
    } else {
      throw Exception('Failed to fetch data');
    }
    final logger = Logger(
      filter: null, // Use the default LogFilter (-> only log in debug mode)
      printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
      output: null, // Use the default LogOutput (-> send everything to console)
    );
    initializeDateFormatting('fr_FR', null);
    final lastRdv = rdv.isNotEmpty ? rdv.last : null;
    if (lastRdv != null) {
      logger.i('Voici le rdv $lastRdv');
      final rdvDate = DateFormat('dd/MM/yyyy').parse(lastRdv['date']!);
      final rdvHour = lastRdv['heure']!.substring(0, lastRdv['heure']!.length - 3).replaceAll(':', ' h ');
      info['next_rdv_date'] = DateFormat('d MMMM yyyy', 'fr_FR').format(rdvDate);
      logger.i('Voici le rdv ${info['next_rdv_date']}');
      info['next_rdv_horraire'] = rdvHour;
      logger.i('Voici le rdv ${info['next_rdv_horraire']}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: fetchData(context), builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Afficher le loader
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.green400,
          ),
        );
      } else if (snapshot.hasError) {
        // Afficher un message d'erreur en cas d'échec
        return const Center(
          child: Text('Erreur lors du chargement des données'),
        );
      } else {
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
                    width: 40,
                  ),
                  const Spacer(),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.grey200),
                    ),
                    icon: const Icon(
                      BootstrapIcons.bell,
                      color: AppColors.blue950,
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
                                fontSize: 24,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const TextSpan(
                              text: ' à  ',
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
                                fontWeight: FontWeight.w600,
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
                letterSpacing: 0.1,
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
              'Vos dernier documents reçus',
              style: TextStyle(
                color: Color(0xFF1E2B4D),
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
    });
  }
}
