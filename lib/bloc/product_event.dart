abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class FilterByCategory extends ProductEvent {
  final String? category; //null is all
  FilterByCategory(this.category);
}

class SearchProducts extends ProductEvent {
  final String query;
  SearchProducts(this.query);
}