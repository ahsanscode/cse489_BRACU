import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bangladesh_map_app/services/theme_service.dart';

class CustomMarker extends StatelessWidget {
  final bool isSelected;

  const CustomMarker({
    Key? key,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeService>(context).isDarkMode;
    
    // Colors for light and dark mode
    final shadowColor = isDarkMode ? Colors.black54 : Colors.black26;
    final selectedColor = isDarkMode ? Colors.lightBlue : Colors.blue;
    final unselectedColor = isDarkMode ? Colors.redAccent : Colors.red;
    final centerDotColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final centerDotBorderColor = isSelected 
        ? (isDarkMode ? Colors.lightBlue.shade200 : Colors.blue.shade900)
        : (isDarkMode ? Colors.redAccent.shade100 : Colors.red.shade900);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Stack(
        children: [
          // Shadow
          Positioned.fill(
            child: Icon(
              Icons.location_on,
              color: shadowColor,
              size: isSelected ? 42 : 38,
            ),
          ),
          
          // Main marker
          Icon(
            Icons.location_on,
            color: isSelected ? selectedColor : unselectedColor,
            size: isSelected ? 40 : 36,
          ),
          
          // Center dot
          Positioned(
            top: isSelected ? 12 : 10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: centerDotColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: centerDotBorderColor,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}