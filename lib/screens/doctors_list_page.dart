import 'package:flutter/material.dart';
import 'package:prototype_1/widget/text.dart';
import '../widget/appbar.dart';
import '../widget/cards.dart';

class DocotorsDistance {
  final String name;
  final String distance;

  DocotorsDistance(this.name, this.distance);
}

class DoctorsListPage extends StatelessWidget {
  const DoctorsListPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title, context),
      body: _ChildBody(),
      backgroundColor: Colors.white,
    );
  }
}

class _ChildBody extends StatefulWidget {
  @override
  State<_ChildBody> createState() => _ChildBodyState();
}

class _ChildBodyState extends State<_ChildBody> {
  List<DocotorsDistance> doctors = [
    DocotorsDistance('Dr. Raould', '1.2'),
    DocotorsDistance('Dr. Raould', '1.2'),
    DocotorsDistance('Dr. Raould', '1.2'),
    DocotorsDistance('Dr. Raould', '1.2'),
    DocotorsDistance('Dr. Raould', '1.2'),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextWhithGradiant(
            [
              TextGradiant('Merci pour cet'),
              TextGradiant('échange.', isGrandiant: true),
            ],
            const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
              "Nous avons besoin d'un médecin pour examiner votre analyse :",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                for (var doctor in doctors) ...[
                  MedecinBlock(
                    drName: doctor.name,
                    distance: '${doctor.distance} km',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
