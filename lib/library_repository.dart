import 'package:cloud_firestore/cloud_firestore.dart';
import 'library.dart';

class LibraryRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionPath = 'books';

  CollectionReference<Map<String, dynamic>> get _booksRef =>
      _db.collection(collectionPath);

  // book rwla time
  Stream<List<Book>> watchBooks() {
    return _booksRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Book.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  // issue book
  Future<bool> issueBookSafely(String title) async {
    final docRef = _booksRef.doc(title);
    return await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (snapshot.exists && snapshot.data() != null) {
        final currentAvailable =
            (snapshot.data()!['available'] as num?)?.toInt() ?? 0;
        if (currentAvailable > 0) {
          transaction.update(docRef, {'available': currentAvailable - 1});
          return true;
        }
      }
      return false;
    });
  }

  //return bokk
  Future<bool> returnBookSafely(String title) async {
    final docRef = _booksRef.doc(title);
    return await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (snapshot.exists && snapshot.data() != null) {
        final currentAvailable =
            (snapshot.data()!['available'] as num?)?.toInt() ?? 0;
        final totalCopies =
            (snapshot.data()!['copies'] as num?)?.toInt() ?? 0;

        if (currentAvailable < totalCopies) {
          transaction.update(docRef, {'available': currentAvailable + 1});
          return true;
        }
      }
      return false;
    });
  }

  //seed wali cheez one time hai tou future
  Future<void> seedBooks() async {
    final snapshot = await _booksRef.get();
    if (snapshot.docs.isNotEmpty) return;

    final initialBooks = [
      {'title': 'Clean Code', 'author': 'Robert Martin', 'copies': 5, 'available': 3},
      {'title': 'The Pragmatic Programmer', 'author': 'Andrew Hunt', 'copies': 4, 'available': 1},
      {'title': 'Introduction to Algorithms', 'author': 'Thomas Cormen', 'copies': 6, 'available': 0},
      {'title': 'Flutter in Action', 'author': 'Eric Windmill', 'copies': 3, 'available': 2},
      {'title': 'Design Patterns', 'author': 'Erich Gamma', 'copies': 4, 'available': 0},
      {'title': 'Refactoring', 'author': 'Martin Fowler', 'copies': 3, 'available': 3},
      {'title': 'Code Complete', 'author': 'Steve McConnell', 'copies': 2, 'available': 1},
      {'title': 'Head First Java', 'author': 'Kathy Sierra', 'copies': 5, 'available': 4},
      {'title': 'Database System Concepts', 'author': 'Abraham Silberschatz', 'copies': 4, 'available': 2},
      {'title': 'Clean Architecture', 'author': 'Robert Martin', 'copies': 3, 'available': 1},
    ];

    for (var bookData in initialBooks) {
      await _booksRef.add(bookData);
    }
  }

  Future<void> updateBook(String title, bool isNotAvailable) async { // update qwali cheez
    await _booksRef.doc(title).update({
      'isNotAvailable': isNotAvailable,
    });
  }
}