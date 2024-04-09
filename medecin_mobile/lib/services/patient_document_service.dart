import 'package:shared_preferences/shared_preferences.dart';

Future<int> getDocument(int id) {
  return Future(() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('document_$id') ?? 0;
  }); // c'est nul ça faut tout enlever
}