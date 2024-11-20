import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/patient_info_service.dart';
import 'package:edgar_pro/services/web_socket_services.dart';
import 'package:edgar/colors.dart';
import 'package:edgar_pro/widgets/Chat/chat_page_patient.dart';
import 'package:edgar_pro/widgets/Chat/chat_utils.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_pro/widgets/custom_nav_patient_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatPatient extends StatefulWidget {
  String id;
  final Function setPages;
  final Function setId;
  WebSocketService? webSocketService;
  // ignore: prefer_final_fields
  ScrollController scrollController;
  final List<Chat> chats;
  ChatPatient({
    super.key,
    required this.id,
    required this.setPages,
    required this.setId,
    required this.chats,
    required this.webSocketService,
    required this.scrollController,
  });

  @override
  // ignore: library_private_types_in_public_api
  ChatPatientState createState() => ChatPatientState();
}

class ChatPatientState extends State<ChatPatient> {
  Map<String, dynamic> patientInfo = {};
  String idDoctor = '';
  String id = "";

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: use_build_context_synchronously
    getPatientById(widget.id, context).then((value) => setState(() {
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
        // catch clauses
      }
    } else {}
  }

  Future<bool> checkData() async {
    if (widget.chats.isNotEmpty && patientInfo.isNotEmpty) {
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
                key: const ValueKey("Header"),
                decoration: BoxDecoration(
                  color: AppColors.blue700,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(children: [
                    Image.asset(
                      "assets/images/logo/edgar-high-five.png",
                      height: 40,
                      width: 37,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      "Mes Patients",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: AppColors.white),
                    ),
                  ]),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
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
                                navigationPatient(context, patientInfo,
                                    widget.setPages, widget.setId)
                              ],
                            );
                          },
                        );
                      },
                    );
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
                          '${patientInfo['Prenom']} ${patientInfo['Nom']}',
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
                  controller: widget.scrollController,
                  webSocketService: widget.webSocketService,
                  chat: widget.chats.firstWhere(
                    (chat) => (chat.recipientIds.first.id == widget.id ||
                        chat.recipientIds.first.id == idDoctor &&
                            (chat.recipientIds.last.id == widget.id ||
                                chat.recipientIds.last.id == idDoctor)),
                  ),
                  patientName: '${patientInfo['Prenom']} ${patientInfo['Nom']}',
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

  Widget navigationPatient(BuildContext context, Map<String, dynamic> patient,
      Function setPages, Function setId) {
    return ModalContainer(
      title: '${patient['Prenom']} ${patient['Nom']}',
      subtitle: "Veuillez choisir une catégorie",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.person,
          size: 18,
        ),
        type: ModalType.info,
      ),
      body: [
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
            text: 'Ordonnance',
            icon: BootstrapIcons.capsule,
            setPages: setPages,
            pageTo: 9,
            id: patient['id'],
            setId: setId),
        const SizedBox(height: 4),
        CustomNavPatientCard(
            text: 'Messagerie',
            icon: BootstrapIcons.chat_dots_fill,
            setPages: setPages,
            pageTo: 10,
            id: patient['id'],
            setId: setId),
        const SizedBox(height: 12),
        Container(height: 2, color: AppColors.blue200),
        const SizedBox(height: 12),
      ],
      footer: Buttons(
          variant: Variant.primary,
          size: SizeButton.sm,
          msg: const Text(
            'Revenir à la patientèle',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          onPressed: () {
            setPages(1);
            Navigator.pop(context);
          }),
    );
  }
}
