import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bangladesh_map_app/constants/api_constants.dart';
import 'package:bangladesh_map_app/services/theme_service.dart';
import 'package:bangladesh_map_app/widgets/section_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // App theme
          const SectionHeader(
            title: 'Appearance',
            icon: Icons.palette_outlined,
            hasDivider: false,
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle dark theme for the app'),
            value: themeService.isDarkMode,
            onChanged: (value) {
              themeService.setThemeMode(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
            secondary: Icon(
              themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          
          // About section
          const SectionHeader(
            title: 'About',
            icon: Icons.info_outline,
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('App Info'),
            subtitle: Text('Version ${AppConstants.appVersion}'),
            onTap: () => _showAboutDialog(context),
          ),
          
          // Help section
          const SectionHeader(
            title: 'Help & Support',
            icon: Icons.help_outline,
          ),
          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('How to Use'),
            onTap: () => _showHelpDialog(context),
          ),
        ],
      ),
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

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpSection(
                'Map View',
                'The map displays all entities as markers. Tap a marker to '
                'view its details. Tap the + button to add a new entity.',
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                'Adding Entities',
                'Fill in the title and coordinates. You can use your current '
                'location or manually enter coordinates. Optionally add an image.',
              ),
              const SizedBox(height: 16),
              _buildHelpSection(
                'Editing & Deleting',
                'Tap an entity on the map or in the list view, then use the edit '
                'or delete buttons to modify or remove it.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}