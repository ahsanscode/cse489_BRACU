import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bangladesh_map_app/constants/api_constants.dart';
import 'package:bangladesh_map_app/models/entity.dart';
import 'package:bangladesh_map_app/providers/entity_provider.dart';
import 'package:bangladesh_map_app/services/image_service.dart';
import 'package:bangladesh_map_app/services/location_service.dart';
import 'package:bangladesh_map_app/utils/app_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EntityFormScreen extends StatefulWidget {
  final Entity? entity;

  const EntityFormScreen({Key? key, this.entity}) : super(key: key);

  @override
  State<EntityFormScreen> createState() => _EntityFormScreenState();
}

class _EntityFormScreenState extends State<EntityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  final _imageService = ImageService();
  final _locationService = LocationService();

  File? _imageFile;
  bool _isLoading = false;
  bool get _isEditMode => widget.entity != null;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (_isEditMode) {
      _titleController.text = widget.entity!.title;
      _latController.text = widget.entity!.lat.toString();
      _lonController.text = widget.entity!.lon.toString();
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final position = await _locationService.getCurrentPosition();
      setState(() {
        _latController.text = position.latitude.toString();
        _lonController.text = position.longitude.toString();
      });
    } catch (e) {
      if (mounted) {
        AppUtils.showSnackBar(
          context,
          AppConstants.errorLocationPermission,
          isError: true,
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _takePhoto() async {
    try {
      final image = await _imageService.takePhoto();
      if (image != null) {
        setState(() {
          _imageFile = image;
        });
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showSnackBar(context, e.toString(), isError: true);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final image = await _imageService.pickImage();
      if (image != null) {
        setState(() {
          _imageFile = image;
        });
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showSnackBar(context, e.toString(), isError: true);
      }
    }
  }

  Future<void> _saveEntity() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final provider = Provider.of<EntityProvider>(context, listen: false);
        final entity = Entity(
          id: _isEditMode ? widget.entity!.id : null,
          title: _titleController.text,
          lat: double.parse(_latController.text),
          lon: double.parse(_lonController.text),
          imagePath: _isEditMode ? widget.entity!.imagePath : null,
        );

        bool success;
        if (_isEditMode) {
          success = await provider.updateEntity(entity, _imageFile);
        } else {
          success = await provider.createEntity(entity, _imageFile);
        }

        if (success && mounted) {
          AppUtils.showSnackBar(
            context,
            _isEditMode
                ? 'Entity updated successfully'
                : 'Entity created successfully',
          );
          Navigator.pop(context);
        } else if (mounted) {
          AppUtils.showSnackBar(
            context,
            provider.errorMessage,
            isError: true,
          );
        }
      } catch (e) {
        if (mounted) {
          AppUtils.showSnackBar(context, e.toString(), isError: true);
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final entityProvider = Provider.of<EntityProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode
            ? AppConstants.editEntity
            : AppConstants.createEntity),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: AppConstants.title,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Latitude and Longitude
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _latController,
                            decoration: const InputDecoration(
                              labelText: AppConstants.latitude,
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (!AppUtils.isValidCoordinate(value)) {
                                return 'Invalid';
                              }
                              final lat = double.parse(value);
                              if (!AppUtils.isValidLatitude(lat)) {
                                return 'Range: -90 to 90';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _lonController,
                            decoration: const InputDecoration(
                              labelText: AppConstants.longitude,
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              if (!AppUtils.isValidCoordinate(value)) {
                                return 'Invalid';
                              }
                              final lon = double.parse(value);
                              if (!AppUtils.isValidLongitude(lon)) {
                                return 'Range: -180 to 180';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Current Location Button
                    ElevatedButton.icon(
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.my_location),
                      label: const Text(AppConstants.getCurrentLocation),
                    ),
                    const SizedBox(height: 24),
                    
                    // Image Section
                    const Text(
                      AppConstants.image,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Image Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _takePhoto,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text(AppConstants.takePhoto),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.photo_library),
                            label: const Text(AppConstants.chooseImage),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Image Preview
                    if (_imageFile != null)
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      )
                    else if (_isEditMode && widget.entity?.imagePath != null)
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: entityProvider.getFullImageUrl(widget.entity!.imagePath),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    
                    // Submit Button
                    ElevatedButton(
                      onPressed: _saveEntity,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        _isEditMode ? AppConstants.update : AppConstants.save,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }
}