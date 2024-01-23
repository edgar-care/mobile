
import 'package:edgar_pro/widgets/rdv/custom_modif_card.dart';
import 'package:flutter/material.dart';

class ModifList extends StatefulWidget {
  const ModifList({super.key});
  @override
  // ignore: library_private_types_in_public_api
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
          return const Column(children: [
            CustomModifCard(),
            SizedBox(height: 8,)
            ]);
    }));
  }
}