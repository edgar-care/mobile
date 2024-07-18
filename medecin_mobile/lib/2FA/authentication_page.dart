import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/doctor_services.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_modal.dart';
import 'package:edgar_pro/widgets/navbarplus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoubleAuthentication extends StatefulWidget {
  const DoubleAuthentication({super.key});

  @override
  State<DoubleAuthentication> createState() => _DoubleAuthenticationState();
}

class _DoubleAuthenticationState extends State<DoubleAuthentication> {

  Map<String, dynamic> infoMedical = {};
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    loadInfo();  
  }

  void loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    List<dynamic> doctorList = await getAllDoctor();
    for (var doctor in doctorList) {
      if (doctor['id'] == id) {
        infoMedical = doctor;
      }
    }
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
                            const Text('Double Authentification',
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
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text('Méthode de double authentification', style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w600),),
                                Text('Paramétrez vos méthodes de double authentification', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500),),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.blue200,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    NavbarPLusTab(
                                      title: 'Email',
                                      isActive: isActive,
                                      onTap: () {
                                        final model = Provider.of<BottomSheetModel>(context, listen: false);
                                        model.resetCurrentIndex();
                                        showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return Consumer<BottomSheetModel>(
                                                builder: (context, model, child) {
                                                  return ListModal(model: model, children: [
                                                    isActive? modal2FAEmailDesactivate(infoMedical['email']) : modal2FAEmail(infoMedical['email']),
                                                  ]);
                                                },
                                              );
                                            },
                                          );
                                      },
                                      type: 'Only',
                                      outlineIcon: SvgPicture.asset(
                                        'assets/images/utils/chevron-right.svg',
                                      ),
                                    ),
                                    NavbarPLusTab(
                                      title: 'Application edgar',
                                      isActive: false,
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      type: 'Only',
                                      outlineIcon: SvgPicture.asset(
                                        'assets/images/utils/chevron-right.svg',
                                      ),
                                    ),
                                    NavbarPLusTab(
                                      title: 'Application tierce',
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      type: 'Only',
                                      outlineIcon: SvgPicture.asset(
                                        'assets/images/utils/chevron-right.svg',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ],
                      )
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

Widget modal2FAEmail(String email) {
    return ModalContainer(
      title: 'Activer la double authentification par email ?',
      subtitle: 'L\'adresse mail: $email sera utilisée comme méthode de double authentification.',
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.shield_lock_fill,
          color: AppColors.blue700,
          size: 17,
        ),
        type: ModalType.info,
      ),
      footer: Column(
        children: [
          Buttons(
            variant: Variante.primary,
            size: SizeButton.md,
            msg: const Text('Activer l\'authentification'),
            onPressed: () {},
          ),
          const SizedBox(height: 8,),
          Buttons(
            variant: Variante.secondary,
            size: SizeButton.md,
            msg: const Text('Annuler'),
            onPressed: () {},
          ),
        ],
      ),
    );
}

Widget modal2FAEmailDesactivate(String email) {
    return ModalContainer(
      title: 'Désactiver la double authentification par email ?',
      subtitle: 'L\'adresse mail: $email ne sera plus utilisée comme méthode de double authentification.',
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.shield_lock_fill,
          color: AppColors.blue700,
          size: 17,
        ),
        type: ModalType.info,
      ),
      footer: Column(
        children: [
          Buttons(
            variant: Variante.delete,
            size: SizeButton.md,
            msg: const Text('Désactiver l\'authentification'),
            onPressed: () {},
          ),
          const SizedBox(height: 8,),
          Buttons(
            variant: Variante.secondary,
            size: SizeButton.md,
            msg: const Text('Annuler'),
            onPressed: () {},
          ),
        ],
      ),
    );
}