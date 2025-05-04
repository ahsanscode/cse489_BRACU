import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bangladesh_map_app/constants/api_constants.dart';
import 'package:bangladesh_map_app/models/entity.dart';
import 'package:bangladesh_map_app/providers/entity_provider.dart';
import 'package:bangladesh_map_app/screens/entity_form_screen.dart';
import 'package:bangladesh_map_app/utils/app_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EntityDetailScreen extends StatelessWidget {
  final Entity entity;

  const EntityDetailScreen({Key? key, required this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final entityProvider = Provider.of<EntityProvider>(context);
    final imageUrl = entityProvider.getFullImageUrl(entity.imagePath);

    Future<void> _deleteEntity() async {
      final shouldDelete = await AppUtils.showConfirmationDialog(
        context,
        AppConstants.deleteConfirmation,
        'Are you sure you want to delete "${entity.title}"?',
        AppConstants.yes,
        AppConstants.no,
      );

      if (shouldDelete) {
        final result = await entityProvider.deleteEntity(entity.id!);
        if (result && context.mounted) {
          AppUtils.showSnackBar(context, 'Entity deleted successfully');
          Navigator.pop(context);
        } else if (context.mounted) {
          AppUtils.showSnackBar(
            context,
            entityProvider.errorMessage,
            isError: true,
          );
        }
      }
    }

    void _editEntity() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EntityFormScreen(entity: entity),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(entity.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editEntity,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteEntity,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (entity.imagePath != null && entity.imagePath!.isNotEmpty)
              SizedBox(
                height: 250,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error, size: 50),
                  ),
                ),
              ),

            // Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    entity.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Coordinates
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                AppUtils.formatCoordinates(entity.lat, entity.lon),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Map button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Return to map and center on this entity
                        entityProvider.selectEntity(entity);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.map),
                      label: const Text('View on Map'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
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