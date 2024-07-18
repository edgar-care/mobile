import 'package:Edgar/services/websocket.dart';
import 'package:edgar/colors.dart';
import 'package:Edgar/utils/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ChatCard extends StatelessWidget {
  String doctorName;
  Chat chat;
  int unread;
  WebSocketService service;
  Function(bool, Chat) onClick;
  ChatCard({
    required this.onClick,
    required this.doctorName,
    required this.unread,
    required this.chat,
    required this.service,
    super.key,
  });

  String patientId = '';
  String doctorId = '';
  String lastMessage = '';
  String unreadString = '';

  @override
  Widget build(BuildContext context) {
    if (unread < 10) {
      unreadString = unread.toString();
    } else {
      unreadString = '+';
    }
    return Container(
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
            onClick(true, chat);
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 28,
                        width: 28,
                        child: BoringAvatars(
                          name: doctorName,
                          colors: const [
                            AppColors.green600,
                            AppColors.green200,
                            AppColors.green500,
                          ],
                          type: BoringAvatarsType.beam,
                        )),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctorName,
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
                            chat.messages.last.message,
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
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${DateFormat('d MMMM', 'fr_FR').format(chat.messages.last.time)}.',
                          style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              color: AppColors.grey500),
                        ),
                        if (unread > 0)
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
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ))),
    );
  }
}
