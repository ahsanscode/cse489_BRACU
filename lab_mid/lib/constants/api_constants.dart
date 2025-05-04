class ApiConstants {
  static const String baseUrl = 'https://labs.anontech.info/cse489/t3/api.php';
  static const String imageBaseUrl = 'https://labs.anontech.info/cse489/t3/';
  
  // Main endpoints
  static const String createEntityEndpoint = baseUrl;
  static const String getEntitiesEndpoint = baseUrl;
  static const String updateEntityEndpoint = baseUrl;
  static const String deleteEntityEndpoint = baseUrl;
  
  // Request methods
  static const String methodPost = 'POST';
  static const String methodGet = 'GET';
  static const String methodPut = 'PUT';
  static const String methodDelete = 'DELETE';
}

class MapConstants {
  // Bangladesh coordinates (center point)
  static const double bangladeshLatitude = 23.6850;
  static const double bangladeshLongitude = 90.3563;
  static const double defaultZoom = 7.0;
}

class AppConstants {
  static const String appName = 'Bangladesh Map';
  static const String appVersion = '1.0.0';
  
  // Navigation drawer items
  static const String navMap = 'Map';
  static const String navForm = 'Add Entity';
  static const String navList = 'Entity List';
  
  // Entity form labels
  static const String createEntity = 'Create New Entity';
  static const String editEntity = 'Edit Entity';
  static const String title = 'Title';
  static const String latitude = 'Latitude';
  static const String longitude = 'Longitude';
  static const String getCurrentLocation = 'Get Current Location';
  static const String image = 'Image';
  static const String takePhoto = 'Take Photo';
  static const String chooseImage = 'Choose Image';
  static const String imagePreview = 'Image Preview';
  static const String save = 'Save';
  static const String update = 'Update';
  
  // Entity list & details
  static const String noEntitiesFound = 'No entities found';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String deleteConfirmation = 'Are you sure you want to delete this entity?';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String coordinates = 'Coordinates: Lat: %s, Lon: %s';
  
  // Error messages
  static const String errorTitle = 'Error';
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNoInternet = 'No internet connection. Please check your connection and try again.';
  static const String errorInvalidData = 'Please provide valid data for all fields.';
  static const String errorImageUpload = 'Failed to upload image. Please try again.';
  static const String errorLocationPermission = 'Location permission is required for this feature.';
}