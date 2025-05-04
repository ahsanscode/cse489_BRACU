import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bangladesh_map_app/models/entity.dart';
import 'package:bangladesh_map_app/services/theme_service.dart';
import 'package:bangladesh_map_app/utils/app_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EntityInfoWindow extends StatelessWidget {
  final Entity entity;
  final VoidCallback onTap;
  final String imageUrl;

  const EntityInfoWindow({
    Key? key,
    required this.entity,
    required this.onTap,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeService>(context).isDarkMode;
    final theme = Theme.of(context);
    
    // Theme-appropriate colors
    final coordinatesColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];
    final detailsColor = theme.colorScheme.primary;
    final arrowColor = isDarkMode ? Colors.grey[400] : Colors.grey;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image if available
              if (entity.imagePath != null && entity.imagePath!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(
                          Icons.error, 
                          size: 30,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ),
              
              // Spacing
              if (entity.imagePath != null && entity.imagePath!.isNotEmpty)
                const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      entity.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleMedium?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Coordinates
                    Text(
                      AppUtils.formatCoordinates(entity.lat, entity.lon),
                      style: TextStyle(
                        fontSize: 14,
                        color: coordinatesColor,
                      ),
                    ),
                    
                    // Tap for more
                    const SizedBox(height: 8),
                    Text(
                      'Tap for details',
                      style: TextStyle(
                        fontSize: 12,
                        color: detailsColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: arrowColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}