import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';
import '../widget/appbar.dart';
import '../widget/text.dart';

class LogedHomePage extends StatefulWidget {
  const LogedHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LogedHomePage> createState() => _LogedHomePageState();
}

class _LogedHomePageState extends State<LogedHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarCustomLoged('home', context),
      body: SingleChildScrollView(
        dragStartBehavior: DragStartBehavior.down,
        physics: const BouncingScrollPhysics(),
        child: Column(
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
            TextWhithGradiant(
              [
                TextGradiant('Welcome'),
                TextGradiant('Lucas COX', isGrandiant: true),
              ],
              const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: AppColors.blue100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Container(
                height: 60,
                width: 360.0,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextWhithGradiant(
                    [
                      TextGradiant('Vous avez'),
                      TextGradiant('0', isGrandiant: true),
                      TextGradiant('analyse(s) en cours')
                    ],
                    const TextStyle(
                      color: AppColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
