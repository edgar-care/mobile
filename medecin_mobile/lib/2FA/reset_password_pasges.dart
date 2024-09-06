import 'package:edgar_pro/services/login_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/field_custom.dart';
import 'package:edgar_pro/widgets/login_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  String newEmail = '';
  String repeatEmail = '';
  String actualEmail = '';
  List<dynamic> devices = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: AppColors.blue50,
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            'assets/images/utils/arrowChat.svg',
                            // ignore: deprecated_member_use
                            color: AppColors.black,
                            height: 16,
                          ), 
                            const Text('Mot de passe',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),),
                              const SizedBox(),
                            ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text('Mise à jour de votre mot de passe', style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w600),),
                                Text('Saisiser votre mot de passe actuel ainsi que votre nouveau mot de passe.', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.grey600),),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text('Votre mot de passe actuel', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                          const SizedBox(height: 4),
                          CustomField(
                            startUppercase: false,
                            keyboardType: TextInputType.text,
                            label: '',
                            onChanged: (value) {
                              setState(() {
                                actualEmail = value;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          const Text('Votre nouveau mot de passe actuel', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                          const SizedBox(height: 4,),
                          CustomField(
                            startUppercase: false,
                            keyboardType: TextInputType.text,
                            label: 'Minimum 8 caractères',
                            onChanged: (value) {
                              setState(() {
                                newEmail = value;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          const Text('Confirmer votre nouveau mot de passe actuel', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                          const SizedBox(height: 4,),
                          CustomField(
                            startUppercase: false,
                            keyboardType: TextInputType.text,
                            label: 'Minimum 8 caractères',
                            onChanged: (value) {
                              setState(() {
                                repeatEmail = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Buttons(
                            variant: Variante.primary,
                            size: SizeButton.md,
                            msg: const Text("Changer le mot de passe"),
                            onPressed: () {
                              if (newEmail != repeatEmail) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  ErrorLoginSnackBar(
                                    context: context,
                                    message: 'Les mots de passe ne correspondent pas',
                                  ),
                                );
                              } else {
                                resetPassword(newEmail);
                              }
                            }
                          )
                        ],
                      ),
                  ],
                )
              )
          )
        )
      )
    );
  }
}