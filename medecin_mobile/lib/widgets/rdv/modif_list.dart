
import 'package:edgar_pro/widgets/rdv/custom_modif_card.dart';
import 'package:flutter/material.dart';

class ModifList extends StatefulWidget {
  const ModifList({super.key});
  @override
  _ModifListState createState() => _ModifListState();
}

class _ModifListState extends State<ModifList> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return Column(children: [
            CustomModifCard(),
            const SizedBox(height: 8,)
            ]);
    }));
  }
}