import 'package:edgar_app/services/request.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Future<bool> getNlpUp(BuildContext context) async {
  try {
    final response = await httpRequest(
      type: RequestType.get,
      endpoint: 'nlp/status',
      context: context,
    );

    if (response != null) {
      return true;
    }
    return false;
  } catch (e) {
    Logger().e('Erreur lors de la récupération de l\'état du NLP: $e');
    return false;
  }
}
