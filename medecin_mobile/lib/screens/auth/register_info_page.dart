// ignore_for_file: must_be_immutable

import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_pro/services/login_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

String name = "";
String lastname = "";
String adress = "";
String city = "";
String postalCode = "";
String country = "";

class Register2 extends StatefulWidget {
  final Function(int) updateSelectedIndex;
  String email;
  String password;
  Register2({required this.updateSelectedIndex, required this.email, required this.password, super.key});

  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr', null);
  }

  final DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue700,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child:SafeArea(child: Container(
          padding: const EdgeInsets.all(8),
          child:
          Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                children: [
                  Image.asset('assets/images/utils/edgar-simple-smile.png',
                      height: 64, width: 74,),
                  const SizedBox(width: 24),
                  const Flexible(
                    child: 
                  Text('Afin de créer votre compte médecin, j\'aurai besoin de certaines de vos informations.', style: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w500, color: AppColors.white), textAlign: TextAlign.center),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 153,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            const Text(
              'Votre prénom',
              style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            CustomField(
              label: 'Edgar',
              value: name,
              action: TextInputAction.next,
              onChanged: (value) => name = value.trim(),
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            const Text(
              'Votre nom',
              style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            CustomField(
              label: "L'assistant numerique",
              value: lastname,
              action: TextInputAction.next,
              onChanged: (value) {
                lastname = value.trim();
              },
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            const Text(
              'Adresse du cabinet',
              style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            CustomField(
              label: "1 rue du medecin",
              value: adress,
              action: TextInputAction.next,
              onChanged: (value) {
                adress = value.trim();
              },
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ville',
                        style: TextStyle(
                            color: AppColors.black,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      CustomField(
                        label: 'Lyon',
                        action: TextInputAction.next,
                        value: city,
                        onChanged: (value) => city = value.trim(),
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Code postal',
                        style: TextStyle(
                            color: AppColors.black,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      CustomField(
                        label: '69000',
                        value: postalCode,
                        action: TextInputAction.next,
                        onChanged: (value) => postalCode = value.trim(),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Pays',
              style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            CustomField(
              label: "France",
              value: country,
              action: TextInputAction.next,
              onChanged: (value) {
                country = value.trim();
              },
              keyboardType: TextInputType.name,
            ),
            const Spacer(),
            Column(
          children: [
            Buttons(
              variant: Variant.primary,
              size: SizeButton.md,
              msg: const Text("S'inscrire"),
              onPressed: () async {
                if (name != "" &&
                    lastname != "" &&
                    adress != "" &&
                    city != "" &&
                    postalCode != "" &&
                    country != "") {
                  register(Map.from({
                    'firstname': name,
                    'name': lastname,
                    'adress': adress,
                    'city': city,
                    'postalCode': postalCode,
                    'country': country,
                    'email': widget.email,
                    'password': widget.password
                  }), context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                      message: "Compléter tous les champs", context: context));
                }
              },
            ),
            const SizedBox(height: 8),
            Buttons(
              variant: Variant.secondary,
              size: SizeButton.md,
              msg: const Text('Précedent'),
              onPressed: () {
                widget.updateSelectedIndex(1);
              },
            ),
          ],
            )
          ],
        ),
    )
          ]),
      ))));
  }
}