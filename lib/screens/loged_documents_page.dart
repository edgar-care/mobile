import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:prototype_1/providers/documents.dart';
import 'package:prototype_1/styles/colors.dart';
import '../widget/appbar.dart';

class LogedDocumentPage extends StatefulWidget {
  const LogedDocumentPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LogedDocumentPage> createState() => _LogedDocumentPageState();
}

class _LogedDocumentPageState extends State<LogedDocumentPage> {
  List<MedecinDocuments> documentslist = [
    MedecinDocuments(
        'Dr.Roger',
        Document(DateTime(2021, 10, 10), 'Analyse', 'Analyse de sang',
            'Analyse de sang')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppbarCustomLoged('documents', context),
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
              for (var i = 0; i < documentslist.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 360.0,
                    color: AppColors.blue700,
                  ),
                ),
              ],
            ],
          ),
        ));
  }
}
