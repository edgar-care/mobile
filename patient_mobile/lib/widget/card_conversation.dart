import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';
import 'package:intl/intl.dart';


class CardConversation extends StatefulWidget {
  final String name;
  final String lastMsg;
  final DateTime time;
  final int unread;
  const CardConversation({super.key, required this.name, required this.lastMsg, required this.unread, required this.time});

  @override
  State<CardConversation> createState() => _CardConversationState();
}

class _CardConversationState extends State<CardConversation> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/dashboard/chat',
            arguments: {'name': widget.name});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.blue200, width: 2),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(BootstrapIcons.circle_fill, color: AppColors.green300, size: 28),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name, style: const TextStyle(fontSize: 14, color: AppColors.black, fontFamily: 'Poppins', fontWeight: FontWeight.w700)),
                Text(widget.lastMsg, style: const TextStyle(fontSize: 12, color: AppColors.grey500, fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontStyle: FontStyle.italic), overflow: TextOverflow.clip,),
              ],
            ),
            const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${DateFormat('d MMM').format(widget
                        .time)}.", // Use DateFormat for locale-aware formatting
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey500,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                  widget.unread > 0
                      ? Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.blue700,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Center(child: Text(
                            widget.unread.toString(),
                            style: const TextStyle(
                                fontSize: 8,
                                color: AppColors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400),
                          ),
                          ),
                        )
                      : const SizedBox(),
                ],
            ),
          ],
        )
      ),
    );
  }
}