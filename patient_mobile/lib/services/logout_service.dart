import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("token")) prefs.remove("token");
  // ignore: use_build_context_synchronously
  Navigator.popUntil(context, (route) => route.isFirst);
}
