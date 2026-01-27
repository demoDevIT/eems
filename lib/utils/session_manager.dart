import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Timer? _timer;
  static void startSessionTimer(BuildContext context) {
    _timer?.cancel();
    _timer = Timer(const Duration(minutes: 20), () {
      _showLogoutDialog(context);
    });
  }

  static void resetTimer(BuildContext context) {
    _timer?.cancel();
    startSessionTimer(context);
  }

  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing dialog without action
      builder: (context) => AlertDialog(
        title: const Text("Session Expired"),
        content: const Text("Session Timed Out, Please login again."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              logout(context); // Logout
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  static Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Navigator.of(context).push(RightToLeftRoute(page: LoginScreen(), duration: const Duration(milliseconds: 500), startOffset: const Offset(0.0, 1.0),));
  }
}
