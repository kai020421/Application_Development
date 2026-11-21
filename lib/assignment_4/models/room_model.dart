class RoomModel {
  final String id;
  final String name;
  final int floor;
  final int capacity;

  const RoomModel({
    required this.id,
    required this.name,
    required this.floor,
    required this.capacity,
  });

  factory RoomModel.fromMap(String id, Map<String, dynamic> data) {
    return RoomModel(
      id: id,
      name: data['name'] as String? ?? '',
      floor: (data['floor'] as num?)?.toInt() ?? 1,
      capacity: (data['capacity'] as num?)?.toInt() ?? 2,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'floor': floor,
      'capacity': capacity,
    };
  }
}