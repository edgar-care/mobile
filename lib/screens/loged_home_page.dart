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
  List<RendezVous> listRdv = [
    RendezVous(
        nameDoc: 'Dr.Robert',
        date: DateTime(12, 12, 13, 12, 54, 10),
        isDrRdvRappel: false),
    RendezVous(
        nameDoc: 'Dr.RAOULD',
        date: DateTime(12, 12, 13, 17, 32, 10),
        isDrRdvRappel: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppbarCustomLoged('home', context),
        body: SingleChildScrollView(
          controller: ScrollController(),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 1.0,
                  width: 380.0,
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
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  height: 60,
                  width: 360.0,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextWhithGradiant(
                      [
                        TextGradiant('Vous avez'),
                        TextGradiant('0', isGrandiant: true),
                        TextGradiant('diagnostique en cours')
                      ],
                      const TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                'Vos rendez-vous de la journée :',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              for (var rdv in listRdv) ...[
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  height: 72,
                  width: 360.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(
                      color: AppColors.blue700,
                      width: 1.0,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWhithGradiant(
                          [
                            TextGradiant('${rdv.nameDoc} à'),
                            TextGradiant(
                                '${rdv.date.hour} h ${rdv.date.minute}',
                                isGrandiant: true),
                          ],
                          const TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              rdv.isDrRdvRappel = !rdv.isDrRdvRappel;
                            });
                          },
                          icon: rdv.isDrRdvRappel == false
                              ? const FaIcon(FontAwesomeIcons.bell)
                              : const FaIcon(FontAwesomeIcons.bellSlash),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
        bottomSheet: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: PrimaryButton(
              'Commmercer un nouveau diagnostique',
              'info',
              const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              context),
        ));
  }
}
