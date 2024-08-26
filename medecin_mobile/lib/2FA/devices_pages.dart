import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/devices_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
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
                          DeviceTab(
                            icon: 'Phone',
                            info: 'Il y a 2 jours',
                            subtitle: 'Lyon, Rhône, France',
                            title: 'Iphone de matteo',
                            onTap: () {},
                            type: 'Top',
                            outlineIcon: SvgPicture.asset(
                              'assets/images/utils/chevron-right.svg',
                            ),),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.blue100,
                                  width: 1,
                                ),
                              ),
                            )
                          ),
                          DeviceTab(
                            icon: 'PC',
                            info: 'Il y a 3 heures',
                            subtitle: 'Lyon, Rhône, France',
                            title: 'DESKTOP-GKTP1F',
                            onTap: () {},
                            type: 'Bottom',
                            outlineIcon: SvgPicture.asset(
                              'assets/images/utils/chevron-right.svg',
                            ),),
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