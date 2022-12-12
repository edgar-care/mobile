import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../styles/colors.dart';

class AppBarCustom extends PreferredSize {
  AppBarCustom(String title, BuildContext context, {super.key})
      : super(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
              centerTitle: true,
              flexibleSpace: Container(),
              automaticallyImplyLeading:
                  title == 'StartTheAnalyseNoLoged' ? false : true,
              title: Image.asset(
                'assets/images/logo/logo-full-color.png',
                height: 40,
              ),
              leading: title == 'StartTheAnalyseNoLoged'
                  ? null
                  : Center(
                      child: IconButton(
                          onPressed: (() {
                            if (title == 'chat') {
                              Navigator.pushNamed(context, '/info');
                            } else if (title == 'info') {
                              Navigator.pushNamed(context, '/');
                            } else if (title == 'doctors') {
                              Navigator.pushNamed(context, '/chat');
                            }
                          }),
                          icon: const FaIcon(FontAwesomeIcons.circleArrowLeft,
                              color: AppColors.blue700, size: 24)),
                    )),
        );
}

class AppbarCustomLoged extends AppBar {
  AppbarCustomLoged(String localisation, BuildContext context, {super.key})
      : super(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  icon: localisation == 'home'
                      ? Image.asset(
                          'assets/images/logo/logo-full-color.png',
                          height: 32,
                        )
                      : Image.asset(
                          'assets/images/logo/logo-full-color.png',
                          height: 32,
                        )),
              const SizedBox(
                width: 30,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/LogedUserPage');
                  },
                  icon: localisation == 'user'
                      ? const FaIcon(
                          FontAwesomeIcons.userAlt,
                          color: AppColors.blue700,
                          size: 24,
                        )
                      : const FaIcon(
                          FontAwesomeIcons.user,
                          color: AppColors.blue700,
                          size: 24,
                        )),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/LogedCalendarPage');
                  },
                  icon: localisation == 'calendar'
                      ? const FaIcon(
                          FontAwesomeIcons.calendarAlt,
                          color: AppColors.blue700,
                          size: 24,
                        )
                      : const FaIcon(
                          FontAwesomeIcons.calendar,
                          color: AppColors.blue700,
                          size: 24,
                        )),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/LogedFilePage');
                  },
                  icon: localisation == 'file'
                      ? const FaIcon(
                          FontAwesomeIcons.fileAlt,
                          color: AppColors.blue700,
                          size: 24,
                        )
                      : const FaIcon(
                          FontAwesomeIcons.file,
                          color: AppColors.blue700,
                          size: 24,
                        )),
            ],
          ),
        );
}
