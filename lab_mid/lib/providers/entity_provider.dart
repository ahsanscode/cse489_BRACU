import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:bangladesh_map_app/models/entity.dart';
import 'package:bangladesh_map_app/services/api_service.dart';
import 'package:bangladesh_map_app/services/image_service.dart';

enum EntityStatus { initial, loading, success, error }

class EntityProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final ImageService _imageService = ImageService();
  
  List<Entity> _entities = [];
  List<Entity> get entities => _entities;
  
  Entity? _selectedEntity;
  Entity? get selectedEntity => _selectedEntity;
  
  EntityStatus _status = EntityStatus.initial;
  EntityStatus get status => _status;
  
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  
  // Fetch all entities from API
  Future<void> fetchEntities() async {
    try {
      _status = EntityStatus.loading;
      notifyListeners();
      
      _entities = await _apiService.getEntities();
      _status = EntityStatus.success;
    } catch (e) {
      _status = EntityStatus.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
  
  // Create a new entity
  Future<bool> createEntity(Entity entity, File? imageFile) async {
    try {
      _status = EntityStatus.loading;
      notifyListeners();
      
      File? processedImage;
      if (imageFile != null) {
        processedImage = await _imageService.compressImage(imageFile);
      }
      
      final int id = await _apiService.createEntity(entity, processedImage);
      
      // Add the new entity to the list with the returned ID
      _entities.add(entity.copyWith(id: id));
      
      _status = EntityStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = EntityStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Update an existing entity
  Future<bool> updateEntity(Entity entity, File? imageFile) async {
    try {
      _status = EntityStatus.loading;
      notifyListeners();
      
      File? processedImage;
      if (imageFile != null) {
        processedImage = await _imageService.compressImage(imageFile);
      }
      
      final bool success = await _apiService.updateEntity(entity, processedImage);
      
      if (success) {
        // Update the entity in the list
        final index = _entities.indexWhere((e) => e.id == entity.id);
        if (index != -1) {
          _entities[index] = entity;
        }
        
        _status = EntityStatus.success;
      } else {
        _status = EntityStatus.error;
        _errorMessage = 'Failed to update entity';
      }
      
      notifyListeners();
      return success;
    } catch (e) {
      _status = EntityStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Delete an entity
  Future<bool> deleteEntity(int id) async {
    try {
      _status = EntityStatus.loading;
      notifyListeners();
      
      final bool success = await _apiService.deleteEntity(id);
      
      if (success) {
        // Remove the entity from the list
        _entities.removeWhere((entity) => entity.id == id);
        
        // Clear selected entity if it was deleted
        if (_selectedEntity?.id == id) {
          _selectedEntity = null;
        }
        
        _status = EntityStatus.success;
      } else {
        _status = EntityStatus.error;
        _errorMessage = 'Failed to delete entity';
      }
      
      notifyListeners();
      return success;
    } catch (e) {
      _status = EntityStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Set selected entity
  void selectEntity(Entity entity) {
    _selectedEntity = entity;
    notifyListeners();
  }
  
  // Clear selected entity
  void clearSelectedEntity() {
    _selectedEntity = null;
    notifyListeners();
  }
  
  // Get full image URL
  String getFullImageUrl(String? imagePath) {
    return _apiService.getFullImageUrl(imagePath);
  }
  
  // Reset status
  void resetStatus() {
    _status = EntityStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }
}