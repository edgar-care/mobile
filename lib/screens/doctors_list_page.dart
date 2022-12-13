import 'package:flutter/material.dart';
import 'package:prototype_1/widget/text.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../widget/appbar.dart';
import '../styles/colors.dart';

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

class _ChildBody extends StatelessWidget {
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
          const SizedBox(height: 64),
          const MedecinBlock(drName: 'Dr.', distance: ' km de votre position'),
          const SizedBox(height: 20),
          const MedecinBlock(drName: 'Dr.', distance: ' km de votre position'),
          const SizedBox(height: 20),
          const MedecinBlock(drName: 'Dr.', distance: ' km de votre position'),
          const SizedBox(height: 20),
          const MedecinBlock(drName: 'Dr.', distance: ' km de votre position'),
          const SizedBox(height: 20),
          const MedecinBlock(drName: 'Dr.', distance: ' km de votre position'),
        ],
      ),
    );
  }
}

class MedecinBlock extends StatefulWidget {
  const MedecinBlock({Key? key, required this.drName, required this.distance})
      : super(key: key);
  final String drName;
  final String distance;

  @override
  State<MedecinBlock> createState() => _MedecinBlockState();
}

class _MedecinBlockState extends State<MedecinBlock> {
  int selectedButton = 0;

  void onButtonPressed(int index) {
    setState(() {
      selectedButton = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/home');
      },
      child: Container(
        height: 48,
        width: 360,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: AppColors.blue200, width: 2)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                widget.drName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Text(
                widget.distance,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
