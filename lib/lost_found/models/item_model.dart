class ItemModel {
  final String id;
  final String title;
  final String category;
  final String location;
  final String status; // 'Lost', 'Found', 'Claimed'
  final String description;
  final String postedBy;

  ItemModel({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.status,
    required this.description,
    required this.postedBy,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ItemModel(
      id: documentId,
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
      status: map['status'] ?? 'Lost',
      description: map['description'] ?? '',
      postedBy: map['postedBy'] ?? 'Anonymous',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'location': location,
      'status': status,
      'description': description,
      'postedBy': postedBy,
    };
  }
}