import 'dart:io';

import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/field_custom.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/widget/card_document.dart';

class FilePage extends StatefulWidget {
  const FilePage({super.key});

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  @override
  void initState() {
    super.initState();
    fetchData(context);
  }

  Future<void> fetchData(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: 50),
                      width: 120,
                      child: Image.asset(
                          'assets/images/logo/full-width-colored-edgar-logo.png'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.blue700,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(children: [
                      Image.asset(
                        'assets/images/logo/edgar-high-five.png',
                        width: 40,
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Mes Documents',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  CustomField(
                    label: 'Nom du document ou du médecin',
                    icon: BootstrapIcons.search,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  CardDocument(
                    typeDeDocument: TypeDeDocument.RADIO,
                    nomDocument: 'Radio du genou',
                    dateDocument: DateTime.now(),
                    nameDoctor: 'Dr. Jean Dupont',
                    file: File('assets/images/logo/edgar-high-five.png'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
