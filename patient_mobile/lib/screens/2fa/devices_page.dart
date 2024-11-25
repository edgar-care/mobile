// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:edgar_app/services/devices.dart';
import 'package:edgar_app/widget/devices_tab.dart';
import 'package:edgar/widget.dart';
import 'package:edgar/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  List<dynamic> devices = [];
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
                          'Appareils',
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.blue200,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        for (var index = 0;
                            index < devices.length;
                            index++) ...[
                          DeviceTab(
                            icon: devices[index]['type'] == 'iPhone' ||
                                    devices[index]['type'] == 'Android'
                                ? 'PHONE'
                                : 'PC',
                            info: devicesFormatTime(
                                devices[index]['date'] * 1000),
                            subtitle:
                                "${devices[index]['city']}, ${devices[index]['country']}",
                            title:
                                "${devices[index]['device_type']} - ${devices[index]['browser']}",
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
                                  return ListModal(
                                    model: model,
                                    children: [
                                      modalInfoDevices(
                                        "${devices[index]['device_type']} - ${devices[index]['browser']}",
                                        DateFormat('dd/MM/yyyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                devices[index]['date'] * 1000)),
                                        "${devices[index]['city']}, ${devices[index]['country']}",
                                        devices[index]['id'],
                                        devices[index]['type'] == 'iPhone' ||
                                                devices[index]['type'] ==
                                                    'Android'
                                            ? 'PHONE'
                                            : 'PC',
                                        context,
                                        getDevices,
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            type:
                                devices.length > 1 && index > devices.length - 1
                                    ? 'Top'
                                    : 'Only',
                            selected: false,
                            outlineIcon: SvgPicture.asset(
                              'assets/images/utils/chevron-right.svg',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget modalInfoDevices(String name, String date, String location, String id,
    String type, BuildContext context, Function load2fa) {
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
        removeDevice(id, context).then(
          (name) {
            load2fa();
            Navigator.pop(context);
          },
        );
      },
    ),
  );
}
