import 'package:flutter/material.dart';
import 'package:bangladesh_map_app/constants/api_constants.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.map,
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(height: 10),
                Text(
                  AppConstants.appName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'v${AppConstants.appVersion}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Map menu item
          _buildDrawerItem(
            context: context,
            icon: Icons.map,
            title: AppConstants.navMap,
            route: '/map',
            isSelected: currentRoute == '/map',
          ),
          
          // Add entity menu item
          _buildDrawerItem(
            context: context,
            icon: Icons.add_location_alt,
            title: AppConstants.navForm,
            route: '/form',
            isSelected: currentRoute == '/form',
          ),
          
          // Entity list menu item
          _buildDrawerItem(
            context: context,
            icon: Icons.list,
            title: AppConstants.navList,
            route: '/list',
            isSelected: currentRoute == '/list',
          ),
          
          const Divider(),
          
          // Settings menu item
          _buildDrawerItem(
            context: context,
            icon: Icons.settings,
            title: 'Settings',
            route: '/settings',
            isSelected: currentRoute == '/settings',
          ),
          
          // About menu item
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: 'v${AppConstants.appVersion}',
      applicationIcon: const Icon(
        Icons.map,
        size: 50,
        color: Colors.green,
      ),
      children: [
        const SizedBox(height: 24),
        const Text(
          'A Flutter application for managing geographic entities on a map centered on Bangladesh.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        const Text(
          'Features:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildFeatureItem('View, add, edit, and delete entities on the map'),
        _buildFeatureItem('Take photos or choose from gallery'),
        _buildFeatureItem('Use current location for coordinates'),
        _buildFeatureItem('List view of all entities'),
        const SizedBox(height: 16),
        const Text(
          '© 2025 Bangladesh Map Project',
          style: TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}