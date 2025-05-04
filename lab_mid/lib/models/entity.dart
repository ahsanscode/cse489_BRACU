class Entity {
  final int? id;
  final String title;
  final double lat;
  final double lon;
  final String? imagePath;

  Entity({
    this.id,
    required this.title,
    required this.lat,
    required this.lon,
    this.imagePath,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      id: json['id'],
      title: json['title'],
      lat: double.parse(json['lat'].toString()),
      lon: double.parse(json['lon'].toString()),
      imagePath: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lat': lat,
      'lon': lon,
      'image': imagePath,
    };
  }

  // For updating an entity (excludes image which is handled separately)
  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'title': title,
      'lat': lat,
      'lon': lon,
    };
  }

  Entity copyWith({
    int? id,
    String? title,
    double? lat,
    double? lon,
    String? imagePath,
  }) {
    return Entity(
      id: id ?? this.id,
      title: title ?? this.title,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}