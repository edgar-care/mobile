// ignore: file_names
// ignore: file_names
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Object?> getAppointement(BuildContext context) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString('token');
  final url = '${dotenv.env['URL']}apointments';

  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    final body = response.body;
    return body;
  } else {
    final scaffoldContext = context;
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      const SnackBar(
        content: Text('Une erreur est survenue'),
      ),
    );
    return null;
  }
}