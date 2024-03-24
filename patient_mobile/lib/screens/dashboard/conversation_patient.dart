import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ConverstationPatient extends StatefulWidget {
  const ConverstationPatient({super.key});

  @override
  State<ConverstationPatient> createState() => _ConverstationPatientState();
}

class _ConverstationPatientState extends State<ConverstationPatient> {

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map?; // Allow null

    final name = args?['name'] as String?;
    Logger().d(name);
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversation avec $name"),
      ),
      body: const Column(
        children:  <Widget>[
          Center(
            child:  Text("Conversation"),
          ),
        ],
    ));
  }
}