// ignore_for_file: file_names, use_build_context_synchronously
import "package:flutter/material.dart";
import 'package:edgar_app/services/request.dart';

Future<String> initiateConversation(BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.post,
    endpoint: 'diagnostic/initiate',
    needsToken: true,
  );
  if (response.statusCode != null) {
    return response["sessionId"];
  } else {
    return "";
  }
}

Future<Object> getResponseMessage(
    BuildContext context, String msg, String idConversation) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.post,
    endpoint: 'diagnostic/diagnose',
    needsToken: true,
    body: {"id": idConversation, "sentence": msg},
  );

  if (response != null) {
    return response;
  } else {
    return {};
  }
}
