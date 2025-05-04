import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bangladesh_map_app/constants/api_constants.dart';
import 'package:bangladesh_map_app/providers/entity_provider.dart';
import 'package:bangladesh_map_app/screens/app_scaffold.dart';
import 'package:bangladesh_map_app/screens/entity_detail_screen.dart';
import 'package:bangladesh_map_app/screens/entity_form_screen.dart';
import 'package:bangladesh_map_app/screens/entity_list_screen.dart';
import 'package:bangladesh_map_app/screens/error_screen.dart';
import 'package:bangladesh_map_app/screens/map_screen.dart';
import 'package:bangladesh_map_app/screens/settings_screen.dart';
import 'package:bangladesh_map_app/screens/splash_screen.dart';
import 'package:bangladesh_map_app/services/theme_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initial system UI overlay style (will be updated based on theme)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EntityProvider()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: themeService.getLightTheme(),
            darkTheme: themeService.getDarkTheme(),
            themeMode: themeService.themeMode,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                    builder: (_) => const SplashScreen(),
                  );
                  
                case '/map':
                  return AppScaffold.route(routeName: '/map');
                
                case '/form':
                  // Check if we're editing an entity
                  if (settings.arguments != null && settings.arguments is Map) {
                    final args = settings.arguments as Map;
                    if (args.containsKey('entity')) {
                      return MaterialPageRoute(
                        settings: const RouteSettings(name: '/form'),
                        builder: (context) => AppScaffold(
                          currentRoute: '/form',
                          child: EntityFormScreen(entity: args['entity']),
                        ),
                      );
                    }
                  }
                  return AppScaffold.route(routeName: '/form');
                
                case '/list':
                  return AppScaffold.route(routeName: '/list');
                
                case '/settings':
                  return MaterialPageRoute(
                    settings: const RouteSettings(name: '/settings'),
                    builder: (context) => AppScaffold(
                      currentRoute: '/settings',
                      child: const SettingsScreen(),
                    ),
                  );
                
                case '/details':
                  if (settings.arguments != null && settings.arguments is Map) {
                    final args = settings.arguments as Map;
                    if (args.containsKey('entity')) {
                      return MaterialPageRoute(
                        settings: const RouteSettings(name: '/details'),
                        builder: (context) => EntityDetailScreen(entity: args['entity']),
                      );
                    }
                  }
                  // Fallback to map if no entity provided
                  return AppScaffold.route(routeName: '/map');
                
                default:
                  return AppScaffold.route(routeName: '/map');
              }
            },
            // Error handling for the entire app
            builder: (context, widget) {
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                return ErrorScreen(
                  errorMessage: errorDetails.exception.toString(),
                  onRetry: () => Navigator.pushReplacementNamed(context, '/map'),
                );
              };
              
              // Add error handling for any unhandled exceptions in widgets
              if (widget == null) {
                return const ErrorScreen(
                  errorMessage: 'Unknown error occurred',
                );
              }
              
              return widget;
            },
          );
        },
      ),
    );
  }
}