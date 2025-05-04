# Bangladesh Map App

A Flutter application for managing geographic entities on a map centered on Bangladesh with CRUD operations via REST API.

## Features

- Interactive map of Bangladesh using flutter_map
- View, add, edit, and delete geographic entities
- Take photos or select from gallery to attach to entities
- Use current location for adding new entities
- Entity list view for easy browsing
- Offline image caching for better performance
- Error handling and connectivity monitoring

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0.0 or higher)
- Dart SDK (version 3.0.0 or higher)
- Android Studio / VS Code with Flutter plugins
- Android emulator or physical device for testing

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:
   ```
   flutter pub get
   ```
4. Run the app:
   ```
   flutter run
   ```

## Project Structure

```
lib/
├── constants/
│   └── api_constants.dart  # API endpoints and app constants
├── models/
│   └── entity.dart         # Data model for geographic entities
├── providers/
│   └── entity_provider.dart # State management using Provider
├── screens/
│   ├── app_scaffold.dart   # Main app scaffold with drawer
│   ├── entity_detail_screen.dart # Entity details display
│   ├── entity_form_screen.dart   # Form for creating/editing entities
│   ├── entity_list_screen.dart   # List view of all entities
│   └── map_screen.dart     # Main map screen
├── services/
│   ├── api_service.dart    # API communication
│   ├── image_service.dart  # Image handling (camera, gallery)
│   └── location_service.dart # Location services
├── utils/
│   ├── app_utils.dart      # Common utility functions
│   └── connectivity_utils.dart # Network connectivity handling
├── widgets/
│   ├── app_drawer.dart     # Navigation drawer
│   ├── custom_marker.dart  # Custom map marker
│   └── entity_info_window.dart # Info window for selected entity
└── main.dart              # Main application entry point
```

## API Endpoints

The app communicates with a REST API at `https://labs.anontech.info/cse489/t3/api.php` with the following operations:

- GET: Retrieve all entities
- POST: Create a new entity
- PUT: Update an existing entity
- DELETE: Remove an entity

## Technical Details

- **State Management**: Provider pattern
- **Map Integration**: flutter_map with OpenStreetMap
- **HTTP Clients**: Both http and dio packages for different request types
- **Image Handling**: image_picker for camera/gallery, flutter_image_compress for optimization
- **Location Services**: geolocator package for current location
- **Network Caching**: cached_network_image for efficient image loading

## Permissions

The application requires the following permissions:

- Internet access
- Location (fine and coarse)
- Camera
- Storage (for image picking/saving)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- flutter_map and OpenStreetMap for mapping services
- The Flutter team for the awesome framework