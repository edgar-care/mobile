import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_app/services/websocket.dart';
import 'package:edgar_app/utils/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';

// ignore: must_be_immutable
class ChatPageConversation extends StatefulWidget {
  Function(bool, Chat?) onClick;
  WebSocketService? webSocketService;
  String doctorName;
  Chat chat;
  String patientId;
  ScrollController controller;
  ChatPageConversation(
      {super.key,
      required this.patientId,
      required this.onClick,
      this.webSocketService,
      required this.doctorName,
      required this.controller,
      required this.chat});

  @override
  State<ChatPageConversation> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPageConversation> {
  @override
  initState() {
    super.initState();
    widget.webSocketService!.readMessage(widget.chat.id);
    widget.webSocketService!.getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            widget.onClick(false, widget.chat);
          },
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/utils/arrowNavbar.svg',
                height: 12,
              ),
              const SizedBox(width: 8),
              const Text(
                "Revenir en arrière",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.blue200, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Center(
                  child: Text(
                    widget.doctorName,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: widget.chat.messages.length,
                    physics: const BouncingScrollPhysics(),
                    controller: widget.controller,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (index == 0 ||
                              widget.chat.messages[index - 1].time.day !=
                                  widget.chat.messages[index].time.day) ...[
                            Container(
                              color: AppColors.blue100,
                              height: 2,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DateFormat('EEEE d MMMM yyyy', 'fr_FR')
                                  .format(widget.chat.messages[index].time),
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          CardMessages(
                            message: widget.chat.messages[index].message,
                            isMe: widget.chat.messages[index].ownerId ==
                                    widget.patientId
                                ? true
                                : false,
                            date: widget.chat.messages[index].time,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomFieldSearch(
                  onlyOnValidate: true,
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return;
                    }
                    widget.webSocketService!.sendMessage(widget.chat.id, value);
                    Future.delayed(const Duration(milliseconds: 200), () {
                      widget.controller.animateTo(
                        widget.controller.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                      );
                    });
                    widget.controller.animateTo(
                      widget.controller.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    );
                  },
                  label: 'Ecrire votre message ici...',
                  onOpen: () {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      widget.controller.animateTo(
                        widget.controller.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                      );
                    });
                  },
                  icon: const Icon(
                    BootstrapIcons.send_fill,
                    color: AppColors.black,
                    size: 16,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class CardMessages extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime date;
  const CardMessages(
      {super.key,
      required this.message,
      required this.isMe,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isMe) ...[
          Text(
            DateFormat('HH:mm', 'fr').format(date),
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.66,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isMe ? AppColors.blue200 : AppColors.green100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: IntrinsicWidth(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            )),
        if (!isMe) ...[
          const SizedBox(width: 8),
          Text(
            DateFormat('HH:mm', 'fr').format(date),
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
