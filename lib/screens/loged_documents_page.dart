import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    MedecinDocuments('Dr.Roger', [
      Document(DateTime(2021, 10, 10), 'Analyse', 'Analyse de sang',
          'Analyse de sang de Mr. Roger'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppbarCustomLoged('documents', context),
        body: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          physics: const BouncingScrollPhysics(),
          controller: ScrollController(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                      decoration: BoxDecoration(
                        color: AppColors.blue100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.blue700,
                          width: 1,
                        ),
                      ),
                      width: 360.0,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(documentslist[i].medecin,
                                    style: const TextStyle(
                                      color: AppColors.blue700,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    documentslist[i].isExpanded =
                                        !documentslist[i].isExpanded;
                                  });
                                },
                                icon: documentslist[i].isExpanded
                                    ? const FaIcon(
                                        FontAwesomeIcons.arrowUp,
                                        color: AppColors.blue700,
                                      )
                                    : const FaIcon(FontAwesomeIcons.arrowDown,
                                        color: AppColors.blue700),
                              ),
                            ],
                          ),
                          if (documentslist[i].isExpanded) ...[
                            const SizedBox(height: 10),
                            for (var j = 0;
                                j < documentslist[i].documents.length;
                                j++) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.white,
                                    border: Border.all(
                                      color: AppColors.blue700,
                                      width: 1,
                                    ),
                                  ),
                                  width: 360.0,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                documentslist[i]
                                                    .documents[j]
                                                    .title,
                                                style: const TextStyle(
                                                  color: AppColors.blue700,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () {},
                                            icon: const FaIcon(
                                              FontAwesomeIcons.download,
                                              color: AppColors.blue700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            documentslist[i]
                                                .documents[j]
                                                .description,
                                            style: const TextStyle(
                                              color: AppColors.blue700,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            documentslist[i]
                                                .documents[j]
                                                .date
                                                .toString(),
                                            style: const TextStyle(
                                              color: AppColors.blue700,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ));
  }
}
