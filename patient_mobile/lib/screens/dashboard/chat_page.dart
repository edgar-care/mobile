// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_app/screens/dashboard/conversation_patient.dart';
import 'package:edgar_app/services/doctor.dart';
import 'package:edgar_app/services/websocket.dart';
import 'package:edgar_app/utils/chat_utils.dart';
import 'package:edgar_app/widget/card_conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  WebSocketService? webSocketService;
  // ignore: prefer_final_fields
  ScrollController scrollController;
  bool isChatting;
  final List<Chat> chats;
  void Function(bool) updateIsChatting;
  ChatPage(
      {super.key,
      required this.chats,
      required this.webSocketService,
      required this.isChatting,
      required this.scrollController,
      required this.updateIsChatting});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String idPatient = '';
  List<dynamic> doctors = [];
  String doctorname = '';
  Chat? chatSelected;
  List<String> doctorName = [];
  final ValueNotifier<int> pageIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    getDoctors();
    fetchData();
  }

  Future<void> getDoctors() async {
    await getAllDoctor().then((value) {
      setState(() {
        doctors = value;
      });
    });
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      try {
        String encodedPayload = token.split('.')[1];
        String decodedPayload =
            utf8.decode(base64.decode(base64.normalize(encodedPayload)));
        setState(() {
          idPatient = jsonDecode(decodedPayload)['patient']["id"];
        });
      } catch (e) {
        // catch clauses
      }
    } else {}
  }

  void setChatting(bool value, Chat? chat) {
    if (chat != null) {
      setState(() {
        widget.updateIsChatting(value);
        chatSelected = chat;
        doctorname = getDoctorName(chat);
      });
    } else {}
  }

  String getDoctorName(Chat chat) {
    var doctor1 = doctors.firstWhere(
      (element) =>
          element['id'] == chat.recipientIds[0].id ||
          element['id'] == chat.recipientIds[1].id,
      orElse: () => {},
    );
    if (doctor1.isEmpty) {
      return 'Dr. Edgard Test';
    }

    return 'Dr. ${doctor1['name']} ${doctor1['firstname'].toUpperCase()}';
  }

  Future<void> getAllDoctorName() async {
    for (var chat in widget.chats) {
      var doctor1 = doctors.firstWhere(
        (element) =>
            element['id'] == chat.recipientIds[0].id ||
            element['id'] == chat.recipientIds[1].id,
        orElse: () => {},
      );
      if (doctor1.isEmpty) {
        doctorName.add('Dr. Edgard Test');
      } else {
        doctorName.add(
            'Dr. ${doctor1['name']} ${doctor1['firstname'].toUpperCase()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: AppColors.blue700,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(children: [
                Image.asset(
                  'assets/images/logo/edgar-high-five.png',
                  width: 40,
                ),
                const SizedBox(width: 16),
                const Text(
                  'Ma messagerie',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            if (widget.isChatting) ...[
              Expanded(
                child: ChatPageConversation(
                  doctorName: doctorname,
                  chat: widget.chats.firstWhere(
                    (chat) => chat.id == chatSelected!.id,
                  ),
                  webSocketService: widget.webSocketService,
                  controller: widget.scrollController,
                  onClick: setChatting,
                  patientId: idPatient,
                ),
              ),
            ],
            if (!widget.isChatting) ...[
              Buttons(
                variant: Variant.primary,
                size: SizeButton.md,
                msg: const Text('Commencer une conversation'),
                onPressed: () {
                  final model =
                      Provider.of<BottomSheetModel>(context, listen: false);
                  model.resetCurrentIndex();

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return Consumer<BottomSheetModel>(
                        builder: (context, model, child) {
                          return ListModal(
                            model: model,
                            children: [
                              CreateDiscusion(
                                model: model,
                                webSocketService: widget.webSocketService,
                              ),
                              CreateDiscusion2(
                                model: model,
                                webSocketService: widget.webSocketService,
                                idPatient: idPatient,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: FutureBuilder(
                  future:
                      getAllDoctorName(), // You can replace this with the actual future you want to use
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: AppColors.blue700,
                        strokeWidth: 2,
                      ); // You can replace this with a loading indicator
                    } else {
                      return ListView.separated(
                        padding: const EdgeInsets.all(0),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 4),
                        itemCount: widget.chats.length,
                        itemBuilder: (context, index) {
                          return ChatCard(
                            chat: widget.chats[index],
                            unread: getUnreadMessages(
                                widget.chats[index], idPatient),
                            service: widget.webSocketService!,
                            doctorName: getDoctorName(
                                widget.chats[index]), //doctorName[index],
                            onClick: setChatting,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

String doctorIdSelected = '';

// ignore: must_be_immutable
class CreateDiscusion extends StatefulWidget {
  WebSocketService? webSocketService;
  BottomSheetModel model;
  CreateDiscusion({
    super.key,
    required this.model,
    required this.webSocketService,
  });

  @override
  State<CreateDiscusion> createState() => _CreateDiscusionState();
}

class _CreateDiscusionState extends State<CreateDiscusion> {
  List<dynamic> doctors = [];
  List<dynamic> filtereddoctors = [];
  String nameFilter = '';

  Future<void> fetchData() async {
    await getAllDoctor().then((value) {
      doctors = value;
      filtereddoctors = value
          .where((element) =>
              element['name'].toString().contains(nameFilter) ||
              element['firstname'].toString().contains(nameFilter))
          .toList();
    });
  }

  void updateFilter(String value) {
    setState(() {
      nameFilter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "'Démarrez une nouvelle conversation'",
      subtitle: "Séléctionner un Docteur",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.chat_dots_fill,
          color: AppColors.green700,
          size: 18,
        ),
        type: ModalType.success,
      ),
      body: [
        CustomFieldSearch(
          label: 'Docteur edgar_app',
          icon: SvgPicture.asset("assets/images/utils/search.svg"),
          keyboardType: TextInputType.name,
          onValidate: (value) {
            updateFilter(value);
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue700,
                      strokeWidth: 2,
                    ),
                  ),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: filtereddoctors.length,
                  padding: const EdgeInsets.all(0),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // ignore: unused_label
                        setState(() {
                          doctorIdSelected = filtereddoctors[index]['id'];
                        });
                        widget.model.changePage(1);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.blue200,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dr. ${filtereddoctors[index]['name']} ${filtereddoctors[index]['firstname'].toUpperCase()}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${filtereddoctors[index]['address']['street'].isEmpty ? '1 rue de la france' : filtereddoctors[index]['address']['street']}, ${filtereddoctors[index]['address']['zip_code'].isEmpty ? '69000' : filtereddoctors[index]['address']['zip_code']} - ${filtereddoctors[index]['address']['city'].isEmpty ? 'Lyon' : filtereddoctors[index]['address']['city']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: AppColors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(
                              BootstrapIcons.chevron_right,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
      footer: Buttons(
        variant: Variant.secondary,
        size: SizeButton.md,
        msg: const Text('Annuler'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class CreateDiscusion2 extends StatefulWidget {
  WebSocketService? webSocketService;
  BottomSheetModel model;
  String idPatient;
  CreateDiscusion2({
    super.key,
    required this.idPatient,
    required this.model,
    required this.webSocketService,
  });

  @override
  State<CreateDiscusion2> createState() => _CreateDiscusion2State();
}

class _CreateDiscusion2State extends State<CreateDiscusion2> {
  String message = '';

  Future<void> fetchData() async {}

  void updateData(String value) {
    setState(() {
      message = value;
    });
    widget.webSocketService?.createChat(message, [
      doctorIdSelected,
      widget.idPatient,
    ]);
    Future.delayed(const Duration(milliseconds: 200), () {
      widget.webSocketService?.getMessages();
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Démarrez une nouvelle conversation",
      subtitle: "Veuiller rentrer votre message",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.chat_dots_fill,
          color: AppColors.green700,
          size: 18,
        ),
        type: ModalType.success,
      ),
      body: [
        CustomFieldSearchMaxLines(
          label: 'Votre message',
          maxLines: 5,
          keyboardType: TextInputType.name,
          icon: const Icon(
            BootstrapIcons.send_fill,
            size: 18,
          ),
          onlyOnValidate: true,
          onValidate: (value) {
            updateData(value);
          },
        ),
      ],
      footer: Buttons(
        variant: Variant.secondary,
        size: SizeButton.md,
        msg: const Text('Annuler'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
