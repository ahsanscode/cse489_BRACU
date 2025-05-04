import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bangladesh_map_app/constants/api_constants.dart';
import 'package:bangladesh_map_app/models/entity.dart';
import 'package:bangladesh_map_app/providers/entity_provider.dart';
import 'package:bangladesh_map_app/screens/entity_detail_screen.dart';
import 'package:bangladesh_map_app/utils/app_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EntityListScreen extends StatefulWidget {
  const EntityListScreen({Key? key}) : super(key: key);

  @override
  State<EntityListScreen> createState() => _EntityListScreenState();
}

class _EntityListScreenState extends State<EntityListScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entity List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchEntities,
          ),
        ],
      ),
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

          if (provider.entities.isEmpty) {
            return const Center(
              child: Text(AppConstants.noEntitiesFound),
            );
          }

          return RefreshIndicator(
            onRefresh: _fetchEntities,
            child: ListView.builder(
              itemCount: provider.entities.length,
              itemBuilder: (context, index) {
                final entity = provider.entities[index];
                return _buildEntityListItem(entity, provider);
              },
            ),
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

  Widget _buildEntityListItem(Entity entity, EntityProvider provider) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntityDetailScreen(entity: entity),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image if available
            if (entity.imagePath != null && entity.imagePath!.isNotEmpty)
              SizedBox(
                height: 150,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: provider.getFullImageUrl(entity.imagePath),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    entity.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Coordinates
                  Text(
                    AppUtils.formatCoordinates(entity.lat, entity.lon),
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  // Actions
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 8,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            // Navigate to the map screen and select this entity
                            provider.selectEntity(entity);
                            Navigator.pushReplacementNamed(context, '/map');
                          },
                          icon: const Icon(Icons.map, size: 18),
                          label: const Text('Map'),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            // Navigate to the detail screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EntityDetailScreen(entity: entity),
                              ),
                            );
                          },
                          icon: const Icon(Icons.info_outline, size: 18),
                          label: const Text('Details'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}