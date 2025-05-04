import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const THEME_MODE_KEY = 'theme_mode';
  static const THEME_MODE_LIGHT = 'light';
  static const THEME_MODE_DARK = 'dark';
  static const THEME_MODE_SYSTEM = 'system';
  
  ThemeMode _themeMode = ThemeMode.light;
  bool _initialized = false;
  
  ThemeService() {
    _loadThemeMode();
  }
  
  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;
  
  // Load the theme mode from shared preferences
  Future<void> _loadThemeMode() async {
    if (_initialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeMode = prefs.getString(THEME_MODE_KEY);
      
      if (savedThemeMode != null) {
        switch (savedThemeMode) {
          case THEME_MODE_LIGHT:
            _themeMode = ThemeMode.light;
            break;
          case THEME_MODE_DARK:
            _themeMode = ThemeMode.dark;
            break;
          case THEME_MODE_SYSTEM:
            _themeMode = ThemeMode.system;
            break;
        }
      }
      
      _initialized = true;
      _updateSystemUIOverlayStyle(_themeMode);
      notifyListeners();
    } catch (e) {
      // Default to light mode if there's an error
      _themeMode = ThemeMode.light;
      _initialized = true;
      _updateSystemUIOverlayStyle(_themeMode);
      notifyListeners();
    }
  }
  
  // Save the theme mode to shared preferences
  Future<void> _saveThemeMode(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String modeToSave;
      
      switch (mode) {
        case ThemeMode.light:
          modeToSave = THEME_MODE_LIGHT;
          break;
        case ThemeMode.dark:
          modeToSave = THEME_MODE_DARK;
          break;
        case ThemeMode.system:
          modeToSave = THEME_MODE_SYSTEM;
          break;
      }
      
      await prefs.setString(THEME_MODE_KEY, modeToSave);
    } catch (e) {
      // Handle error saving theme mode
      debugPrint('Error saving theme mode: $e');
    }
  }
  
  // Set the theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    await _saveThemeMode(mode);
    _updateSystemUIOverlayStyle(mode);
    notifyListeners();
  }
  
  // Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light 
      ? ThemeMode.dark 
      : ThemeMode.light;
      
    await setThemeMode(newMode);
  }
  
  // Update the system UI overlay style based on theme
  void _updateSystemUIOverlayStyle(ThemeMode mode) {
    final isDark = mode == ThemeMode.dark;
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? Colors.grey[900] : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }
  
  // Get the light theme data
  ThemeData getLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        primary: Colors.green,
        secondary: Colors.orange,
        brightness: Brightness.light,
      ),
      brightness: Brightness.light,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.green,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.green,
      ),
    );
  }
  
  // Get the dark theme data
  ThemeData getDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        primary: Colors.green,
        secondary: Colors.orange,
        brightness: Brightness.dark,
      ),
      brightness: Brightness.dark,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.grey[850],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.green,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.green,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: Colors.grey[850],
      ),
    );
  }
}