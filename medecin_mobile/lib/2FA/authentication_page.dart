// ignore_for_file: use_build_context_synchronously, deprecated_member_use, must_be_immutable

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/devices_services.dart';
import 'package:edgar_pro/services/doctor_services.dart';
import 'package:edgar_pro/services/multiplefa_services.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_pro/widgets/devices_tab.dart';
import 'package:edgar_pro/widgets/navbarplus.dart';
import 'package:edgar_pro/widgets/number_list_2fa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DoubleAuthentication extends StatefulWidget {
  Function refreshAccount;
  DoubleAuthentication({super.key, required this.refreshAccount});

  @override
  State<DoubleAuthentication> createState() => _DoubleAuthenticationState();
}

class _DoubleAuthenticationState extends State<DoubleAuthentication> {
  Map<String, dynamic> infoMedical = {};
  bool emailActive = false;
  bool thirdActive = false;
  bool mobileActive = false;
  bool secret = false;
  String trustDevice = '';

  @override
  void initState() {
    super.initState();
    loadInfo();
    load2fa();
  }

  @override
  void dispose() {
    super.dispose();
    widget.refreshAccount();
  }

  void load2fa() async {
    setState(() {
      emailActive = false;
      thirdActive = false;
      mobileActive = false;
      secret = false;
    });
    getEnable2fa(context).then((value) {
      if (value['secret'].isNotEmpty) {
        setState(() {
          secret = true;
        });
      }
      for (var method in value['methods']) {
        if (method == 'EMAIL') {
          setState(() {
            emailActive = true;
          });
        } else if (method == 'AUTHENTIFICATOR') {
          setState(() {
            thirdActive = true;
          });
        } else if (method == 'MOBILE') {
          setState(() {
            mobileActive = true;
          });
        }
      }
    });
  }

  void loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    List<dynamic> doctorList = await getAllDoctor(context);
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
                            color: AppColors.black,
                            height: 16,
                          ),
                          const Text(
                            'Double Authentification',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
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
                            Text(
                              'Méthode de double authentification',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Paramétrez vos méthodes de double authentification',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grey600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                isActive: emailActive,
                                onTap: () {
                                  final model = Provider.of<BottomSheetModel>(
                                      context,
                                      listen: false);
                                  model.resetCurrentIndex();
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Consumer<BottomSheetModel>(
                                        builder: (context, model, child) {
                                          return ListModal(
                                              model: model,
                                              children: [
                                                emailActive
                                                    ? modal2FAEmailDesactivate(
                                                        infoMedical['email'],
                                                        context,
                                                        load2fa)
                                                    : modal2FAEmail(
                                                        infoMedical['email'],
                                                        context,
                                                        load2fa,
                                                        secret),
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
                                isActive: mobileActive,
                                onTap: () {
                                  final model = Provider.of<BottomSheetModel>(
                                      context,
                                      listen: false);
                                  model.resetCurrentIndex();
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Consumer<BottomSheetModel>(
                                        builder: (context, model, child) {
                                          return ListModal(
                                              model: model,
                                              children: [
                                                mobileActive
                                                    ? ModalTrustDevices(
                                                        load2fa: load2fa,
                                                      )
                                                    : ModalEdgarApp1(
                                                        load2fa: load2fa,
                                                        secret: secret,
                                                      ),
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
                                title: 'Application tierce',
                                isActive: thirdActive,
                                onTap: () {
                                  final model = Provider.of<BottomSheetModel>(
                                      context,
                                      listen: false);
                                  model.resetCurrentIndex();
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Consumer<BottomSheetModel>(
                                        builder: (context, model, child) {
                                          return ListModal(
                                              model: model,
                                              children: [
                                                thirdActive
                                                    ? modalDesactivateTierApp(
                                                        context, load2fa)
                                                    : ModalTierApp(
                                                        load2fa: load2fa,
                                                        secret: secret,
                                                      ),
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
                            ],
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

Widget modal2FAEmail(
    String email, BuildContext context, Function load2fa, bool secret) {
  return ModalContainer(
    title: 'Activer la double authentification par email ?',
    subtitle:
        'L\'adresse mail: $email sera utilisée comme méthode de double authentification.',
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
          variant: Variant.primary,
          size: SizeButton.md,
          msg: const Text('Activer l\'authentification'),
          onPressed: () {
            enable2FAEmail(context).then((value) {
              load2fa();
              if (secret != true) {
                Navigator.pop(context);
                final model =
                    Provider.of<BottomSheetModel>(context, listen: false);
                model.resetCurrentIndex();
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) {
                    return Consumer<BottomSheetModel>(
                      builder: (context, model, child) {
                        return ListModal(model: model, children: [
                          ModalBackupEmail(
                            load2fa: load2fa,
                          )
                        ]);
                      },
                    );
                  },
                );
              } else {
                Navigator.pop(context);
              }
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Buttons(
          variant: Variant.secondary,
          size: SizeButton.md,
          msg: const Text('Annuler'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Widget modal2FAEmailDesactivate(
    String email, BuildContext context, Function load2fa) {
  return ModalContainer(
    title: 'Désactiver la double authentification par email ?',
    subtitle:
        'L\'adresse mail: $email ne sera plus utilisée comme méthode de double authentification.',
    icon: const IconModal(
      icon: Icon(
        BootstrapIcons.shield_slash_fill,
        color: AppColors.blue700,
        size: 17,
      ),
      type: ModalType.info,
    ),
    footer: Column(
      children: [
        Buttons(
          variant: Variant.delete,
          size: SizeButton.md,
          msg: const Text('Désactiver l\'authentification'),
          onPressed: () {
            delete2faMethod('EMAIL', context).then((value) {
              if (value == 200) {
                load2fa();
                Navigator.pop(context);
              }
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Buttons(
          variant: Variant.secondary,
          size: SizeButton.md,
          msg: const Text('Annuler'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

class ModalEdgarApp1 extends StatefulWidget {
  final Function load2fa;
  final bool secret;
  const ModalEdgarApp1(
      {super.key, required this.load2fa, required this.secret});

  @override
  State<ModalEdgarApp1> createState() => ModalEdgarApp1State();
}

class ModalEdgarApp1State extends State<ModalEdgarApp1> {
  List<dynamic> devices = [];
  int selected = -1;
  @override
  void initState() {
    super.initState();
    getDevices();
  }

  Future<void> getDevices() async {
    List<dynamic> temp = await getAllDevices(context);
    setState(() {
      devices = temp;
    });
  }

  String devicesFormatTime(int time) {
    var seconds =
        ((DateTime.now().millisecondsSinceEpoch - time) / 1000).round();
    List<Map<String, dynamic>> intervals = [
      {'label': 'année', 'seconds': 31536000},
      {'label': 'mois', 'seconds': 2592000},
      {'label': 'jour', 'seconds': 86400},
      {'label': 'heure', 'seconds': 3600},
      {'label': 'minute', 'seconds': 60},
      {'label': 'seconde', 'seconds': 1},
    ];

    for (var i = 0; i < intervals.length; i += 1) {
      var interval = intervals[i];
      var count = (seconds / interval['seconds']).round();
      if (count > 0) {
        return 'Il y a $count ${interval['label']}${count > 1 ? 's' : ''}';
      }
    }
    return 'Il y a quelques secondes';
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
        title: 'Activer la double authentification avec edgar',
        subtitle:
            'Sélectionner un appareil ci-dessous, afin d\'activer la double authentification sur celui-ci.',
        icon: const IconModal(
          icon: Icon(
            BootstrapIcons.shield_lock_fill,
            color: AppColors.blue700,
            size: 17,
          ),
          type: ModalType.info,
        ),
        body: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  for (var index = 0; index < devices.length; index++) ...[
                    DeviceTab(
                        icon: devices[index]['type'] == 'iPhone' ||
                                devices[index]['type'] == 'Android'
                            ? 'PHONE'
                            : 'PC',
                        info: devicesFormatTime(devices[index]['date'] * 1000),
                        subtitle:
                            "${devices[index]['city']}, ${devices[index]['country']}",
                        title:
                            "${devices[index]['device_type']} - ${devices[index]['browser']}",
                        onTap: () {
                          setState(() {
                            selected = index;
                          });
                        },
                        type: "Only",
                        selected: selected == index,
                        outlineIcon: SvgPicture.asset(
                          'assets/images/utils/chevron-right.svg',
                        )),
                  ]
                ],
              ))
        ],
        footer: Column(
          children: [
            Buttons(
              variant: Variant.primary,
              size: SizeButton.md,
              msg: const Text('Activer l\'authentification'),
              onPressed: () {
                enable2FAMobile(devices[selected]['id'], context).then((value) {
                widget.load2fa();
                  if (widget.secret != true) {
                    Navigator.pop(context);
                    final model =
                        Provider.of<BottomSheetModel>(context, listen: false);
                    model.resetCurrentIndex();
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) {
                        return Consumer<BottomSheetModel>(
                          builder: (context, model, child) {
                            return ListModal(model: model, children: [
                              ModalEdgarApp2(
                                load2fa: widget.load2fa,
                              ),
                            ]);
                          },
                        );
                      },
                    );
                  } else {
                    Navigator.pop(context);
                  }
                });
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Buttons(
              variant: Variant.secondary,
              size: SizeButton.md,
              msg: const Text('Annuler'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }
}

class ModalBackupEmail extends StatefulWidget {
  final Function load2fa;
  const ModalBackupEmail({super.key, required this.load2fa});

  @override
  State<ModalBackupEmail> createState() => _ModalBackupEmailState();
}

class _ModalBackupEmailState extends State<ModalBackupEmail> {
  List<dynamic> backupCodes = [];

  Future<bool> getbackup() async {
    backupCodes = await generateBackupCode(context);
    widget.load2fa();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getbackup(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == true) {
            return ModalContainer(
                title: 'La double authentification avec un email est activée !',
                subtitle:
                    'Avec la double authentification activée, vous aurez besoin de ces codes de sauvegarde si vous n\'avez plus accès à votre appareil.',
                body: [
                  const Text(
                    'Ces codes sont très importants, vous ne pourrez les lire qu\'une seule fois. Nous vous recommandons de les stocker dans un lieu sûr:',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            backupCodes[0].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[1].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[2].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[3].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[4].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Column(
                        children: [
                          Text(
                            backupCodes[5].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[6].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[7].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[8].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[9].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
                icon: const IconModal(
                  icon: Icon(
                    BootstrapIcons.shield_lock_fill,
                    color: AppColors.blue700,
                    size: 17,
                  ),
                  type: ModalType.info,
                ),
                footer: Buttons(
                  variant: Variant.primary,
                  size: SizeButton.md,
                  msg: const Text('Confirmer'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ));
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.blue700,
            ));
          }
        });
  }
}

class ModalEdgarApp2 extends StatefulWidget {
  final Function load2fa;
  const ModalEdgarApp2({super.key, required this.load2fa});

  @override
  State<ModalEdgarApp2> createState() => _ModalEdgarApp2State();
}

class _ModalEdgarApp2State extends State<ModalEdgarApp2> {
  List<dynamic> backupCodes = [];

  Future<bool> getbackup() async {
    backupCodes = await generateBackupCode(context);
    widget.load2fa();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getbackup(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == true) {
            return ModalContainer(
                title: 'La double authentification avec edgar est activée !',
                subtitle:
                    'Avec la double authentification activée, vous aurez besoin de ces codes de sauvegarde si vous n\'avez plus accès à votre appareil.',
                body: [
                  const Text(
                    'Ces codes sont très importants, vous ne pourrez les lire qu\'une seule fois. Nous vous recommandons de les stocker dans un lieu sûr:',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            backupCodes[0].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[1].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[2].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[3].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[4].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Column(
                        children: [
                          Text(
                            backupCodes[5].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[6].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[7].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[8].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[9].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
                icon: const IconModal(
                  icon: Icon(
                    BootstrapIcons.shield_lock_fill,
                    color: AppColors.blue700,
                    size: 17,
                  ),
                  type: ModalType.info,
                ),
                footer: Buttons(
                  variant: Variant.primary,
                  size: SizeButton.md,
                  msg: const Text('Confirmer'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ));
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.blue700,
            ));
          }
        });
  }
}

class ModalTrustDevices extends StatefulWidget {
  Function load2fa;
  ModalTrustDevices({super.key, required this.load2fa});

  @override
  State<ModalTrustDevices> createState() => _ModalTrustDevicesState();
}

class _ModalTrustDevicesState extends State<ModalTrustDevices> {
  List<dynamic> devices = [];
  @override
  void initState() {
    super.initState();
    getDevices();
  }

  Future<void> getDevices() async {
    List<dynamic> temp = await getTrustedDevices(context);
    setState(() {
      devices = temp;
    });
  }

  String devicesFormatTime(int time) {
    var seconds =
        ((DateTime.now().millisecondsSinceEpoch - time) / 1000).round();
    List<Map<String, dynamic>> intervals = [
      {'label': 'année', 'seconds': 31536000},
      {'label': 'mois', 'seconds': 2592000},
      {'label': 'jour', 'seconds': 86400},
      {'label': 'heure', 'seconds': 3600},
      {'label': 'minute', 'seconds': 60},
      {'label': 'seconde', 'seconds': 1},
    ];

    for (var i = 0; i < intervals.length; i += 1) {
      var interval = intervals[i];
      var count = (seconds / interval['seconds']).round();
      if (count > 0) {
        return 'Il y a $count ${interval['label']}${count > 1 ? 's' : ''}';
      }
    }
    return 'Il y a quelques secondes';
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: 'Double authentification avec edgar',
      subtitle:
          'Consulter tous les appareils utilisés pour la double authentification avec l\'application edgar.',
      body: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                for (var index = 0; index < devices.length; index++) ...[
                  DeviceTab(
                      icon: devices[index]['type'] == 'iPhone' ||
                              devices[index]['type'] == 'Android'
                          ? 'PHONE'
                          : 'PC',
                      info: devicesFormatTime(devices[index]['date'] * 1000),
                      subtitle:
                          "${devices[index]['city']}, ${devices[index]['country']}",
                      title:
                          "${devices[index]['device_type']} - ${devices[index]['browser']}",
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) {
                            return Consumer<BottomSheetModel>(
                              builder: (context, model, child) {
                                return ListModal(model: model, children: [
                                  modalInfoTrustDevices(
                                      "${devices[index]['device_type']} - ${devices[index]['browser']}",
                                      DateFormat('dd/MM/yyyy').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              devices[index]['date'] * 1000)),
                                      devicesFormatTime(
                                          devices[index]['date'] * 1000),
                                      devices[index]['id'],
                                      devices[index]['type'] == 'iPhone' ||
                                              devices[index]['type'] ==
                                                  'Android'
                                          ? 'PHONE'
                                          : 'PC',
                                      context,
                                      widget.load2fa)
                                ]);
                              },
                            );
                          },
                        );
                      },
                      type: "Top",
                      selected: false,
                      outlineIcon: SvgPicture.asset(
                        'assets/images/utils/chevron-right.svg',
                      )),
                ]
              ],
            ))
      ],
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
            variant: Variant.primary,
            size: SizeButton.md,
            msg: const Text('Ajouter un appareil de confiance'),
            onPressed: () {
              Navigator.pop(context);
              final model =
                  Provider.of<BottomSheetModel>(context, listen: false);
              model.resetCurrentIndex();
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) {
                  return Consumer<BottomSheetModel>(
                    builder: (context, model, child) {
                      return ListModal(model: model, children: const [
                        ModalAddTrustDevice(),
                      ]);
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: 8,
          ),
          Buttons(
            variant: Variant.deleteBordered,
            size: SizeButton.md,
            msg: const Text('Désactiver l\'authentification'),
            onPressed: () {
              Navigator.pop(context);
              final model =
                  Provider.of<BottomSheetModel>(context, listen: false);
              model.resetCurrentIndex();
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) {
                  return Consumer<BottomSheetModel>(
                    builder: (context, model, child) {
                      return ListModal(model: model, children: [
                        modalEdgarAppDesactivate(widget.load2fa, context)
                      ]);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget modalEdgarAppDesactivate(Function load2fa, BuildContext context) {
  return ModalContainer(
      title: 'Désactiver la double authentification avec edgar ?',
      subtitle:
          'Vous ne pourrez plus vous connecter en utilisant votre application edgar sur mobile.',
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
            variant: Variant.delete,
            size: SizeButton.md,
            msg: const Text('Désactiver l\'authentification'),
            onPressed: () {
              delete2faMethod('MOBILE', context).then((value) {
                if (value == 200) {
                  load2fa();
                  Navigator.pop(context);
                }
              });
            },
          ),
          const SizedBox(
            height: 8,
          ),
          Buttons(
            variant: Variant.secondary,
            size: SizeButton.md,
            msg: const Text('Annuler'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ));
}

class ModalAddTrustDevice extends StatefulWidget {
  const ModalAddTrustDevice({super.key});

  @override
  State<ModalAddTrustDevice> createState() => _ModalAddTrustDeviceState();
}

class _ModalAddTrustDeviceState extends State<ModalAddTrustDevice> {
  List<dynamic> devices = [];
  int selected = -1;
  @override
  void initState() {
    super.initState();
    getDevices();
  }

  Future<void> getDevices() async {
    List<dynamic> temp = await getAllDevices(context);
    for (int i = 0; i < temp.length; i++) {
      if (temp[i]['trust_device'] == false) {
        setState(() {
          devices.add(temp[i]);
        });
      }
    }
  }

  String devicesFormatTime(int time) {
    var seconds =
        ((DateTime.now().millisecondsSinceEpoch - time) / 1000).round();
    List<Map<String, dynamic>> intervals = [
      {'label': 'année', 'seconds': 31536000},
      {'label': 'mois', 'seconds': 2592000},
      {'label': 'jour', 'seconds': 86400},
      {'label': 'heure', 'seconds': 3600},
      {'label': 'minute', 'seconds': 60},
      {'label': 'seconde', 'seconds': 1},
    ];

    for (var i = 0; i < intervals.length; i += 1) {
      var interval = intervals[i];
      var count = (seconds / interval['seconds']).round();
      if (count > 0) {
        return 'Il y a $count ${interval['label']}${count > 1 ? 's' : ''}';
      }
    }
    return 'Il y a quelques secondes';
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
        title: 'Ajouter un appareil de confiance',
        subtitle:
            'Sélectionner un appareil ci-dessous, afin d\'ajouter la double authentification sur celui-ci.',
        icon: const IconModal(
          icon: Icon(
            BootstrapIcons.shield_lock_fill,
            color: AppColors.blue700,
            size: 17,
          ),
          type: ModalType.info,
        ),
        body: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  for (var index = 0; index < devices.length; index++) ...[
                    DeviceTab(
                        icon: devices[index]['type'] == 'iPhone' ||
                                devices[index]['type'] == 'Android'
                            ? 'PHONE'
                            : 'PC',
                        info: devicesFormatTime(devices[index]['date'] * 1000),
                        subtitle:
                            "${devices[index]['city']}, ${devices[index]['country']}",
                        title:
                            "${devices[index]['device_type']} - ${devices[index]['browser']}",
                        onTap: () {
                          setState(() {
                            selected = index;
                          });
                        },
                        type: "Only",
                        selected: selected == index,
                        outlineIcon: SvgPicture.asset(
                          'assets/images/utils/chevron-right.svg',
                        )),
                  ]
                ],
              ))
        ],
        footer: Column(
          children: [
            Buttons(
              variant: Variant.primary,
              size: SizeButton.md,
              msg: const Text('Activer l\'authentification'),
              onPressed: () {
                addTrustDevices(devices[selected]['id'], context).then((value) {
                  Navigator.pop(context);
                });
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Buttons(
              variant: Variant.secondary,
              size: SizeButton.md,
              msg: const Text('Annuler'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }
}

class ModalTierApp extends StatefulWidget {
  final bool secret;
  final Function load2fa;
  const ModalTierApp({super.key, required this.secret, required this.load2fa});

  @override
  State<ModalTierApp> createState() => _ModalTierAppState();
}

class _ModalTierAppState extends State<ModalTierApp> {
  Map<String, dynamic> infoGenerate = {};
  int skip = 0;

  Future<void> generateThirdParty() async {
    if (skip == 0) {
      infoGenerate = await enable2FA3party(context);
      skip = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: generateThirdParty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ModalContainer(
                title:
                    'Activer la double authentification avec une application tierce ?',
                subtitle:
                    'Ouvrer votre application de double authentification et renseigner le code secret ci-dessous.',
                body: [
                  Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              infoGenerate['base32'],
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: infoGenerate['base32']));
                              },
                              child: const Icon(
                                Icons.copy,
                                color: AppColors.blue700,
                                size: 17,
                              ),
                            ),
                          ]),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          const Text(
                            'Ou scanner le QR code:',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          QrImageView(
                            data: infoGenerate['otpauth_url'],
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        ],
                      )
                    ],
                  )
                ],
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
                      variant: Variant.primary,
                      size: SizeButton.md,
                      msg: const Text('Continuer'),
                      onPressed: () {
                        Navigator.pop(context);
                        final model = Provider.of<BottomSheetModel>(context,
                            listen: false);
                        model.resetCurrentIndex();
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) {
                            return Consumer<BottomSheetModel>(
                              builder: (context, model, child) {
                                return ListModal(model: model, children: [
                                  ModalTierApp2(
                                      load2fa: widget.load2fa,
                                      secret: widget.secret),
                                ]);
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Buttons(
                      variant: Variant.secondary,
                      size: SizeButton.md,
                      msg: const Text('Annuler'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ));
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.blue700,
              ),
            );
          }
        });
  }
}

class ModalTierApp2 extends StatefulWidget {
  final bool secret;
  final Function load2fa;
  const ModalTierApp2({super.key, required this.secret, required this.load2fa});

  @override
  State<ModalTierApp2> createState() => _ModalTierApp2State();
}

class _ModalTierApp2State extends State<ModalTierApp2> {
  String _code = '';

  void setCode(String action, String code) {
    if (action == 'ADD') {
      setState(() {
        _code += code;
      });
    } else if (action == 'DELETE') {
      setState(() {
        _code = _code.substring(0, _code.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
        title:
            'Activer la double authentification avec une application tierce ?',
        subtitle:
            'Pour s\'assurer du bon fonctionnement, renseigner le code que votre application d\'authentification affiche.',
        body: [
          FieldNumberList2FA(
            addCode: setCode,
          )
        ],
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
              variant: Variant.primary,
              size: SizeButton.md,
              msg: const Text('Continuer'),
              onPressed: () {
                checkTierAppCode(_code, context).then((value) {
                  if (value['otp_verified'] == true) {
                    widget.load2fa();
                    if (widget.secret != true) {
                      Navigator.pop(context);
                      final model =
                          Provider.of<BottomSheetModel>(context, listen: false);
                      model.resetCurrentIndex();
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) {
                          return Consumer<BottomSheetModel>(
                            builder: (context, model, child) {
                              return ListModal(model: model, children: [
                                ModalBackupTierApp(
                                  load2fa: widget.load2fa,
                                ),
                              ]);
                            },
                          );
                        },
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      ErrorSnackBar(
                        message: 'Le code est incorrect',
                        context: context,
                      ),
                    );
                  }
                });
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Buttons(
              variant: Variant.secondary,
              size: SizeButton.md,
              msg: const Text('Annuler'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }
}

class ModalBackupTierApp extends StatefulWidget {
  final Function load2fa;
  const ModalBackupTierApp({super.key, required this.load2fa});

  @override
  State<ModalBackupTierApp> createState() => _ModalBackupTierAppState();
}

class _ModalBackupTierAppState extends State<ModalBackupTierApp> {
  List<dynamic> backupCodes = [];

  Future<bool> getbackup() async {
    backupCodes = await generateBackupCode(context);
    widget.load2fa();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getbackup(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == true) {
            return ModalContainer(
                title:
                    'La double authentification avec une application tierce est activée !',
                subtitle:
                    'Avec la double authentification activée, vous aurez besoin de ces codes de sauvegarde si vous n\'avez plus accès à votre appareil.',
                icon: const IconModal(
                  icon: Icon(
                    BootstrapIcons.shield_lock_fill,
                    color: AppColors.blue700,
                    size: 17,
                  ),
                  type: ModalType.info,
                ),
                body: [
                  const Text(
                    'Ces codes sont très importants, vous ne pourrez les lire qu\'une seule fois. Nous vous recommandons de les stocker dans un lieu sûr:',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            backupCodes[0].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[1].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[2].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[3].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[4].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Column(
                        children: [
                          Text(
                            backupCodes[5].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[6].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[7].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[8].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            backupCodes[9].toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
                footer: Buttons(
                  variant: Variant.primary,
                  size: SizeButton.md,
                  msg: const Text('Confirmer'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ));
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.blue700,
            ));
          }
        });
  }
}

Widget modalDesactivateTierApp(BuildContext context, Function load2fa) {
  return ModalContainer(
    title:
        'Désactiver la double authentification avec une application tierce ?',
    subtitle:
        'Vous ne pourrez plus vous connecter en utilisant votre application de double authentification.',
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
            variant: Variant.delete,
            size: SizeButton.md,
            msg: const Text('Désactiver l\'authentification'),
            onPressed: () {
              delete2faMethod('AUTHENTIFICATOR', context).then((value) {
                if (value == 200) {
                  load2fa();
                  Navigator.pop(context);
                }
              });
            }),
        const SizedBox(
          height: 8,
        ),
        Buttons(
          variant: Variant.secondary,
          size: SizeButton.md,
          msg: const Text('Annuler'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Widget modalInfoTrustDevices(String name, String date, String location,
    String id, String type, BuildContext context, Function load2fa) {
  return ModalContainer(
      title: name,
      subtitle: 'Connecté à votre compte edgar.',
      icon: IconModal(
        icon: type == 'Phone'
            ? SvgPicture.asset(
                'assets/images/utils/phone-fill.svg',
                color: AppColors.blue700,
              )
            : SvgPicture.asset(
                'assets/images/utils/laptop-fill.svg',
                color: AppColors.blue700,
              ),
        type: ModalType.info,
      ),
      body: [
        Column(
          children: [
            Row(
              children: [
                const Text(
                  'Dernière connexion: ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  date,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Localisation: ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  location,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        )
      ],
      footer: Buttons(
        variant: Variant.deleteBordered,
        size: SizeButton.md,
        msg: const Text('Déconnecter l\'appareil'),
        onPressed: () {
          removeTrustDevice(id, context).then((name) {
            load2fa();
            Navigator.pop(context);
          });
        },
      ));
}
