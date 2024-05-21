import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/services/web_socket_services.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:edgar_pro/widgets/Chat/chat_page_patient.dart';
import 'package:edgar_pro/widgets/Chat/chat_utils.dart';
import 'package:edgar_pro/widgets/buttons.dart';
import 'package:edgar_pro/widgets/custom_nav_patient_card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

// ignore: must_be_immutable
class ChatPatient extends StatefulWidget {
  String id;
  final Function setPages;
  final Function setId;
  ChatPatient(
      {super.key,
      required this.id,
      required this.setPages,
      required this.setId});

  @override
  // ignore: library_private_types_in_public_api
  ChatPatientState createState() => ChatPatientState();
}

class ChatPatientState extends State<ChatPatient> {
  Map<String, dynamic> patientInfo = {};
  WebSocketService? _webSocketService;
  String idDoctor = '';
  List<Chat> chats = [];
  String id = "";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeWebSocketService();
    _loadInfo();
  }

  Future<void> _initializeWebSocketService() async {
    _webSocketService = WebSocketService(
      onReceiveMessage: (data) {
        setState(() {
          Chat? chatToUpdate = chats.firstWhere(
            (chat) => chat.id == data['chat_id'],
          );
          chatToUpdate.messages.add(
            Message(
              message: data['message'],
              ownerId: data['owner_id'],
              time: data['sended_time'] != null
                  ? DateTime.fromMillisecondsSinceEpoch(data['sended_time'])
                  : DateTime.now(),
            ),
          );
        });
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      },
      onReady: (data) {},
      onGetMessages: (data) {
        setState(() {
          chats = transformChats(data);
        });
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      },
      onReadMessage: (data) {},
    );
    await _webSocketService?.connect();
    _webSocketService?.sendReadyAction();
    _webSocketService?.getMessages();
  }

  @override
  void dispose() {
    super.dispose();
    _webSocketService?.disconnect();
  }

  Future<void> _loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getPatientById(widget.id).then((value) => setState(() {
          patientInfo = value;
        }));
    String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      try {
        String encodedPayload = token.split('.')[1];
        String decodedPayload =
            utf8.decode(base64.decode(base64.normalize(encodedPayload)));
        prefs.setString('id', jsonDecode(decodedPayload)['doctor']["id"]);
        setState(() {
          idDoctor = jsonDecode(decodedPayload)['doctor']["id"];
        });
      } catch (e) {
        Logger().e('Error decoding token: $e');
      }
    } else {
      Logger().w('Token is null or empty');
    }
  }

  Future<bool> checkData() async {
    if (chats.isNotEmpty && patientInfo.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == true) {
            return Column(children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.blue100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.blue200,
                    width: 2,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    WoltModalSheet.show<void>(
                        context: context,
                        pageListBuilder: (modalSheetContext) {
                          return [
                            patientNavigation(context, patientInfo,
                                widget.setPages, widget.setId),
                          ];
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 3,
                          decoration: BoxDecoration(
                            color: AppColors.green500,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${patientInfo['Nom']} ${patientInfo['Prenom']}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                        ),
                        const Spacer(),
                        const Text(
                          'Voir Plus',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          BootstrapIcons.chevron_right,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: ChatPagePatient(
                  controller: _scrollController,
                  webSocketService: _webSocketService,
                  chat: chats.firstWhere(
                    (chat) => (chat.recipientIds.first.id == widget.id ||
                        chat.recipientIds.first.id == idDoctor &&
                            (chat.recipientIds.last.id == widget.id ||
                                chat.recipientIds.last.id == idDoctor)),
                  ),
                  patientName: '${patientInfo['Nom']} ${patientInfo['Prenom']}',
                  doctorId: idDoctor,
                ),
              ),
            ]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  SliverWoltModalSheetPage patientNavigation(BuildContext context,
      Map<String, dynamic> patient, Function setPages, Function setId) {
    return WoltModalSheetPage(
      backgroundColor: AppColors.white,
      hasTopBarLayer: false,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(children: [
            Text(
              '${patient['Nom']} ${patient['Prenom']}',
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomNavPatientCard(
                text: 'Dossier médical',
                icon: BootstrapIcons.postcard_heart_fill,
                setPages: setPages,
                pageTo: 6,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 4),
            CustomNavPatientCard(
                text: 'Rendez-vous',
                icon: BootstrapIcons.calendar2_week_fill,
                setPages: setPages,
                pageTo: 7,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 4),
            CustomNavPatientCard(
                text: 'Documents',
                icon: BootstrapIcons.file_earmark_text_fill,
                setPages: setPages,
                pageTo: 8,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 4),
            CustomNavPatientCard(
                text: 'Messagerie',
                icon: BootstrapIcons.chat_dots_fill,
                setPages: setPages,
                pageTo: 9,
                id: patient['id'],
                setId: setId),
            const SizedBox(height: 12),
            Container(height: 2, color: AppColors.blue200),
            const SizedBox(height: 12),
            Buttons(
                variant: Variante.primary,
                size: SizeButton.sm,
                msg: const Text(
                  'Revenir à la patientèle',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                onPressed: () {
                  setPages(1);
                  Navigator.pop(context);
                }),
          ]),
        ),
      ),
    );
  }
}
