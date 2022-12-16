import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:prototype_1/widget/button.dart';
import '../widget/appbar.dart';
import '../widget/text.dart';
import '../providers/rendez_vous.dart';

class LogedHomePage extends StatefulWidget {
  const LogedHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LogedHomePage> createState() => _LogedHomePageState();
}

class _LogedHomePageState extends State<LogedHomePage> {
  List<RendezVousMedecin> rdvList = [
    RendezVousMedecin('Dr.Raould', DateTime(1999, 12, 12, 12, 40), true)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppbarCustomLoged('home', context),
        body: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 1.0,
                  width: 360.0,
                  color: AppColors.blue700,
                ),
              ),
              const SizedBox(height: 48),
              TextWhithGradiant(
                [
                  TextGradiant('Welcome'),
                  TextGradiant('Lucas COX', isGrandiant: true),
                ],
                const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: AppColors.blue100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Container(
                  height: 60,
                  width: 360.0,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextWhithGradiant(
                      [
                        TextGradiant('Vous avez'),
                        TextGradiant('0', isGrandiant: true),
                        TextGradiant('analyse(s) en cours')
                      ],
                      const TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Vos evènements du jour',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              for (var rdv in rdvList) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    width: 360.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.blue700),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWhithGradiant(
                            [
                              TextGradiant('${rdv.medecins} à '),
                              TextGradiant(
                                  '${rdv.date.hour} h ${rdv.date.minute}',
                                  isGrandiant: true),
                            ],
                            const TextStyle(
                              color: AppColors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  rdv.notif = !rdv.notif;
                                });
                              },
                              icon: rdv.notif == true
                                  ? const FaIcon(FontAwesomeIcons.bell,
                                      color: AppColors.blue700)
                                  : const FaIcon(FontAwesomeIcons.bellSlash,
                                      color: AppColors.blue700))
                        ],
                      ),
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
          child: PrimaryButton(
              'Commencez un diagnostique',
              'info',
              const TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              context),
        ));
  }
}
