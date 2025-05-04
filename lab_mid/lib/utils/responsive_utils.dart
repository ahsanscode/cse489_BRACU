import 'package:flutter/material.dart';

// Device types - moved outside the class as enums can't be declared inside classes
enum DeviceType { mobile, tablet, desktop }

class ResponsiveUtils {
  // Singleton pattern
  static final ResponsiveUtils _instance = ResponsiveUtils._internal();
  factory ResponsiveUtils() => _instance;
  ResponsiveUtils._internal();

  // Get device type based on screen width
  DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return DeviceType.mobile;
    } else if (width < 1200) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  // Check if the device is a mobile
  bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  // Check if the device is a tablet
  bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  // Check if the device is a desktop
  bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  // Get screen width
  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Get screen height
  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Calculate responsive font size
  double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return baseFontSize;
      case DeviceType.tablet:
        return baseFontSize * 1.2;
      case DeviceType.desktop:
        return baseFontSize * 1.4;
    }

    // Default fallback (should never reach here)
    return baseFontSize;
  }

  // Calculate responsive spacing
  double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return baseSpacing;
      case DeviceType.tablet:
        return baseSpacing * 1.5;
      case DeviceType.desktop:
        return baseSpacing * 2;
    }

    // Default fallback (should never reach here)
    return baseSpacing;
  }

  // Calculate responsive height
  double getResponsiveHeight(BuildContext context, double percentageOfScreen) {
    return getScreenHeight(context) * (percentageOfScreen / 100);
  }

  // Calculate responsive width
  double getResponsiveWidth(BuildContext context, double percentageOfScreen) {
    return getScreenWidth(context) * (percentageOfScreen / 100);
  }

  // Get safe area padding
  EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // Create a responsive widget that adapts to different screen sizes
  Widget responsiveWidget({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }

    // Default fallback (should never reach here)
    return mobile;
  }
}