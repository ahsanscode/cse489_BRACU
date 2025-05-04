import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:bangladesh_map_app/constants/api_constants.dart';
import 'package:bangladesh_map_app/models/entity.dart';
import 'package:bangladesh_map_app/providers/entity_provider.dart';
import 'package:bangladesh_map_app/screens/entity_detail_screen.dart';
import 'package:bangladesh_map_app/services/theme_service.dart';
import 'package:bangladesh_map_app/widgets/custom_marker.dart';
import 'package:bangladesh_map_app/widgets/entity_info_window.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  Entity? _selectedEntity;

  @override
  void initState() {
    super.initState();
    _fetchEntities();
  }

  Future<void> _fetchEntities() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EntityProvider>(context, listen: false).fetchEntities();
    });
  }

  void _onMarkerTap(Entity entity) {
    setState(() {
      _selectedEntity = entity;
    });

    // Center the map on the selected entity
    _mapController.move(
      LatLng(entity.lat, entity.lon),
      _mapController.camera.zoom,
    );
  }

  void _onInfoWindowTap(Entity entity) {
    // Navigate to entity detail screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntityDetailScreen(entity: entity),
      ),
    );
  }

  void _clearSelection() {
    setState(() {
      _selectedEntity = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final isDarkMode = themeService.isDarkMode;

    return Scaffold(
      body: Consumer<EntityProvider>(
        builder: (context, provider, child) {
          if (provider.status == EntityStatus.loading && provider.entities.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.status == EntityStatus.error && provider.entities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchEntities,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Map
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng(
                    MapConstants.bangladeshLatitude,
                    MapConstants.bangladeshLongitude,
                  ),
                  initialZoom: MapConstants.defaultZoom,
                  onTap: (_, __) => _clearSelection(),
                  backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
                ),
                children: [
                  TileLayer(
                    // Use different tile layers based on theme mode
                    urlTemplate: isDarkMode
                        ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png'
                        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.bangladesh_map_app',
                    maxZoom: 19,
                    // Use default tile animation behavior
                  ),
                  // Entity markers
                  MarkerLayer(
                    markers: provider.entities.map((entity) {
                      return Marker(
                        width: 40.0,
                        height: 40.0,
                        point: LatLng(entity.lat, entity.lon),
                        child: GestureDetector(
                          onTap: () => _onMarkerTap(entity),
                          child: CustomMarker(
                            isSelected: _selectedEntity?.id == entity.id,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              // Info window for selected entity
              if (_selectedEntity != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: EntityInfoWindow(
                    entity: _selectedEntity!,
                    onTap: () => _onInfoWindowTap(_selectedEntity!),
                    imageUrl: provider.getFullImageUrl(_selectedEntity!.imagePath),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/form');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}