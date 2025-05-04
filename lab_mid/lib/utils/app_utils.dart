import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  // Show a snackbar message
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Show a confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context, 
    String title, 
    String message,
    String confirmText,
    String cancelText,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  // Format coordinates as string
  static String formatCoordinates(double latitude, double longitude) {
    final latFormat = NumberFormat('0.0000');
    final lonFormat = NumberFormat('0.0000');
    return 'Lat: ${latFormat.format(latitude)}, Lon: ${lonFormat.format(longitude)}';
  }

  // Validate numeric input for latitude/longitude
  static bool isValidCoordinate(String value) {
    if (value.isEmpty) return false;
    
    try {
      double.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Validate latitude range
  static bool isValidLatitude(double lat) {
    return lat >= -90 && lat <= 90;
  }
  
  // Validate longitude range
  static bool isValidLongitude(double lon) {
    return lon >= -180 && lon <= 180;
  }
}