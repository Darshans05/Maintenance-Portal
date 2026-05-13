class PlantItem {
  final String plantId;
  final String code;
  final String name;
  final String location;

  PlantItem({
    required this.plantId,
    required this.code,
    required this.name,
    required this.location,
  });

  factory PlantItem.fromJson(Map<String, dynamic> json) {
    final plantId = json['Werks'] ?? json['Plant'] ?? json['PlantId'] ?? '';
    final code = json['PlantCode'] ?? plantId;
    final name = json['Name1'] ?? json['PlantDesc'] ?? json['Description'] ?? json['Name'] ?? '';
    final location = json['Ort01'] ?? json['Location'] ?? '';

    return PlantItem(
      plantId: plantId.toString(),
      code: code.toString(),
      name: name.toString(),
      location: location.toString(),
    );
  }

  String get displayName => name.isNotEmpty ? name : code;
}
