import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String title;
  final String author;
  final int copies;
  final int available;

  Book({
    required this.title,
    required this.author,
    required this.copies,
    required this.available,
    });

  factory Book.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Book(
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      copies: (data['copies'] as num?)?.toInt() ?? 0,
      available: (data['available'] as num?)?.toInt() ?? 0,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'copies': copies,
      'available': available,
    };
  }
  bool get isNotAvailable => available == 0; //not available wali cheez
}

