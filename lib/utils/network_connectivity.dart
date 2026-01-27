import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkConnectivity {
  NetworkConnectivity._();
  static final _instance = NetworkConnectivity._();
  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;
  // 1.
  void initialise() async {
    List<ConnectivityResult> result = await _networkConnectivity.checkConnectivity();
    _checkStatus(result);
    _networkConnectivity.onConnectivityChanged.listen((result) {
      debugPrint(result[0].name);
      _checkStatus(result);
    });
  }
// 2.
  void _checkStatus(List<ConnectivityResult> result) async {
    bool isOnline = false;
    try {
      if(!kIsWeb) {
        final result = await InternetAddress.lookup('www.google.com');
        isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } else {
        final result = await http.get(Uri.parse('www.google.com'));
        if(result.statusCode==200) {
          isOnline = true;
        }
        else {
          isOnline = false;
        }
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    if(!_controller.isClosed) {
      _controller.sink.add({result: isOnline});
    }
  }
  void disposeStream() {
    _controller.stream.drain();
    _controller.close();
  }
}