import 'package:edgar_pro/2FA/authentication_page.dart';
import 'package:edgar_pro/services/devices_services.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/custom_modal.dart';
import 'package:edgar_pro/widgets/devices_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
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
    List<dynamic> temp = await getAllDevices();
    setState(() {
      devices = temp;
    });
    Logger().d(devices);
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
                            const Text('Appareils',
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
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.blue200,
                          width: 1,
                        ),
                      ),
                      child:Column(
                        children: [
                          for (var index = 0; index < devices.length; index++) ...[
                            DeviceTab(
                              icon: devices[index]['type'] == 'iPhone' || devices[index]['type'] == 'Android' ? 'PHONE' : 'PC',
                              info: "Dernière connexion: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(devices[index]['date'] * 1000))}",
                              subtitle: "${devices[index]['city']}, ${devices[index]['country']}",
                              title: "${devices[index]['device_type']} - ${devices[index]['browser']}",
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Consumer<BottomSheetModel>(
                                        builder: (context, model, child) {
                                          return ListModal(model: model, children: [
                                            modalInfoDevices("${devices[index]['device_type']} - ${devices[index]['browser']}", DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(devices[index]['date'] * 1000)), "${devices[index]['city']}, ${devices[index]['country']}" , devices[index]['id'],devices[index]['type'] == 'iPhone' || devices[index]['type'] == 'Android' ? 'PHONE' : 'PC',  context)
                                          ]);
                                        },
                                      );
                                    },
                                  );
                              },
                              type: devices.length > 1 && index > devices.length - 1 ? 'Top' : 'Only',
                              selected: false,
                              outlineIcon: SvgPicture.asset(
                                'assets/images/utils/chevron-right.svg',)
                            ),
                          ],  
                        ],
                      )
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}