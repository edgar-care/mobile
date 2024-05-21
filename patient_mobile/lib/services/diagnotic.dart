import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> initiateDiagnostic() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}diagnostic/initiate';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    final body = response.body;
    return jsonDecode(body)["sessionId"];
  } else {
    Logger().e(response.body);
    return "";
  }
}

Future<Map<String, dynamic>> getDiagnostic(
    String sessionId, String sentence) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}diagnostic/diagnose';
  var body = jsonEncode({"id": sessionId, "sentence": sentence});
  final response = await http.post(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
    body: body,
  );
  if (response.statusCode == 200) {
    final body = response.body;
    return jsonDecode(body);
  } else {
    Logger().e(response.body);
    return {};
  }
}
