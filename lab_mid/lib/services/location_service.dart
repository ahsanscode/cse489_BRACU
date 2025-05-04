import 'package:geolocator/geolocator.dart';

class LocationService {
  // Request location permission and get current position
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, cannot request permissions');
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Calculate distance between two coordinates in kilometers
  double calculateDistance(double startLatitude, double startLongitude, 
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
      startLatitude, 
      startLongitude, 
      endLatitude, 
      endLongitude
    ) / 1000; // Convert meters to kilometers
  }

  // Check if coordinate is within Bangladesh
  bool isWithinBangladesh(double latitude, double longitude) {
    // Define Bangladesh boundaries (approximate)
    const double minLat = 20.5;
    const double maxLat = 26.5;
    const double minLng = 88.0;
    const double maxLng = 92.5;

    return (latitude >= minLat && 
            latitude <= maxLat && 
            longitude >= minLng && 
            longitude <= maxLng);
  }
}