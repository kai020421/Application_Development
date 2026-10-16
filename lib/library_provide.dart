import 'package:flutter/material.dart';
import 'library.dart';
import 'library_repository.dart';

class LibraryProvider extends ChangeNotifier { //change notification 
  final LibraryRepository repository;

  String _searchAuthorQuery = ''; //author search
  bool _onlyAvailable = false; // availanle wali dikhay ka filter jo toggle main hai

  LibraryProvider(this.repository);

  String get searchAuthorQuery => _searchAuthorQuery;
  bool get onlyAvailable => _onlyAvailable;

  void setSearchAuthorQuery(String query) {
    _searchAuthorQuery = query;
    notifyListeners();
  }

  void toggleOnlyAvailable(bool value) {
    _onlyAvailable = value;
    notifyListeners();
  }

  // Q8. Search and filter logic
  List<Book> filterBooks(List<Book> books) {
    return books.where((book) {
      final matchesAuthor = book.author
          .toLowerCase()
          .contains(_searchAuthorQuery.toLowerCase().trim());
      final matchesAvailability = !_onlyAvailable || book.available > 0;
      return matchesAuthor && matchesAvailability;
    }).toList();
  }
}