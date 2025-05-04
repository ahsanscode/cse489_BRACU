import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:bangladesh_map_app/constants/api_constants.dart';

class ConnectivityUtils {
  // Singleton pattern
  static final ConnectivityUtils _instance = ConnectivityUtils._internal();
  factory ConnectivityUtils() => _instance;
  ConnectivityUtils._internal();

  final Connectivity _connectivity = Connectivity();

  // Check current connectivity status
  Future<bool> isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Listen for connectivity changes
  Stream<ConnectivityResult> get connectivityStream => _connectivity.onConnectivityChanged;

  // Show no internet dialog
  Future<void> showNoInternetDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppConstants.errorTitle),
          content: const Text(AppConstants.errorNoInternet),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Stream builder widget that handles connectivity changes
  Widget connectivityStreamBuilder({
    required Widget child,
    required Widget noInternetWidget,
  }) {
    return StreamBuilder<ConnectivityResult>(
      stream: connectivityStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data!;
          if (result == ConnectivityResult.none) {
            return noInternetWidget;
          }
        }
        return child;
      },
    );
  }
}