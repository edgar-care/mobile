import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/services/web_socket_services.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/Chat/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ignore: must_be_immutable
class ChatCard extends StatefulWidget {
  String patientId;
  Chat chat;
  int unread;
  WebSocketService service;
  Function(bool, Chat, String?) onClick;
  ChatCard({
    required this.onClick,
    required this.patientId,
    required this.unread,
    required this.chat,
    required this.service,
    super.key});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {

  String patientName = '';
  String doctorId = '';
  String lastMessage = '';
  String unreadString = '';
  bool enable = true;

  Future<void> loadInfo() async{
    getPatientById(widget.patientId).then((value) => {
      setState(() {
      patientName = "${value["Prenom"]} ${value["Nom"]}";
      enable = false;
      }),
    });
  }

  @override
  void initState() {
    super.initState();
    loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.unread) {
      case < 10:
        unreadString = widget.unread.toString();
        break;
      case >= 10:
        unreadString = '+';
    }

    return Skeletonizer(
      enabled: enable,
      child: Container(
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: AppColors.blue200,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GestureDetector(
          onTap: () {
            widget.onClick(true, widget.chat, patientName);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: IntrinsicHeight(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: 28,
                    width: 28,
                    child: BoringAvatars(
                      name: patientName,
                      colors: const [
                        AppColors.blue700,
                        AppColors.blue200,
                        AppColors.blue500
                      ],
                      type: BoringAvatarsType.beam,
                    )),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Text(
                        widget.chat.messages.last.message,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${DateFormat('d MMM').format(widget.chat.messages.last.time)}.',
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            color: AppColors.grey500),
                      ),
                      if (widget.unread > 0)
                        Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: AppColors.blue700,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Center(
                              child: Text(
                                unreadString,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            )),
                    ],
                  ),
                ),
              ],
            ),
          )),
      ),
    ));
  }
}