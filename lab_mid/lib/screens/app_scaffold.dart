import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bangladesh_map_app/constants/api_constants.dart';
import 'package:bangladesh_map_app/screens/entity_form_screen.dart';
import 'package:bangladesh_map_app/screens/entity_list_screen.dart';
import 'package:bangladesh_map_app/screens/map_screen.dart';
import 'package:bangladesh_map_app/screens/settings_screen.dart';
import 'package:bangladesh_map_app/services/theme_service.dart';
import 'package:bangladesh_map_app/widgets/app_drawer.dart';

class AppScaffold extends StatelessWidget {
  final String currentRoute;

  const AppScaffold({
    Key? key,
    required this.currentRoute,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: [
          // Only show theme toggle button in main screens, not settings
          if (currentRoute != '/settings')
            IconButton(
              icon: Icon(
                themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () {
                themeService.toggleTheme();
              },
              tooltip: themeService.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            ),
        ],
      ),
      drawer: AppDrawer(currentRoute: currentRoute),
      body: child,
    );
  }

  String _getTitle() {
    switch (currentRoute) {
      case '/map':
        return AppConstants.navMap;
      case '/form':
        return AppConstants.navForm;
      case '/list':
        return AppConstants.navList;
      case '/settings':
        return 'Settings';
      default:
        return AppConstants.appName;
    }
  }

  static MaterialPageRoute route({
    required String routeName,
    Widget? screen,
  }) {
    Widget screenWidget;
    
    switch (routeName) {
      case '/map':
        screenWidget = const MapScreen();
        break;
      case '/form':
        screenWidget = const EntityFormScreen();
        break;
      case '/list':
        screenWidget = const EntityListScreen();
        break;
      case '/settings':
        screenWidget = const SettingsScreen();
        break;
      default:
        screenWidget = const MapScreen();
    }
    
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => AppScaffold(
        currentRoute: routeName,
        child: screen ?? screenWidget,
      ),
    );
  }
}