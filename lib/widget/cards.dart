import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';

class PrimaryCard extends Card {
  PrimaryCard(List<String> text, TextStyle textstyle, {super.key})
      : super(
          margin: const EdgeInsets.all(15),
          child: SizedBox(
              height: 100,
              width: 450,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < text.length; i++)
                    Text(
                      text[i],
                      style: textstyle,
                    ),
                ],
              ))),
          color: AppColors.purple100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        );
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
