import 'dart:convert';
import 'dart:io';

import 'package:bangladesh_map_app/constants/api_constants.dart';
import 'package:bangladesh_map_app/models/entity.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final http.Client _client = http.Client();

  // Get all entities
  Future<List<Entity>> getEntities() async {
    try {
      final response = await _client.get(Uri.parse(ApiConstants.getEntitiesEndpoint));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Entity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load entities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load entities: $e');
    }
  }

  // Create a new entity
  Future<int> createEntity(Entity entity, File? imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        'title': entity.title,
        'lat': entity.lat,
        'lon': entity.lon,
      });

      if (imageFile != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(imageFile.path),
          ),
        );
      }

      final response = await _dio.post(
        ApiConstants.createEntityEndpoint,
        data: formData,
      );

      if (response.statusCode == 200) {
        if (response.data is Map && response.data.containsKey('id')) {
          return response.data['id'];
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to create entity: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create entity: $e');
    }
  }

  // Update an existing entity
  Future<bool> updateEntity(Entity entity, File? imageFile) async {
    try {
      FormData formData = FormData.fromMap(entity.toUpdateJson());

      if (imageFile != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(imageFile.path),
          ),
        );
      }

      final response = await _dio.put(
        ApiConstants.updateEntityEndpoint,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to update entity: $e');
    }
  }

  // Delete an entity
  Future<bool> deleteEntity(int id) async {
    try {
      final response = await _dio.delete(
        ApiConstants.deleteEntityEndpoint,
        queryParameters: {'id': id},
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to delete entity: $e');
    }
  }

  // Get full image URL from image path
  String getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }
    
    // If the image path already includes the full URL, return it as is
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    
    return '${ApiConstants.imageBaseUrl}$imagePath';
  }
}