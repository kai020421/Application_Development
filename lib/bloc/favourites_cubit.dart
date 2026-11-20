import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritesCubit extends Cubit<Set<int>>{
  FavouritesCubit() : super(<int>{});


  void toggle(int productId) {
    final next = Set<int>.from(state);
    next.contains(productId) ? next.remove(productId) : next.add(productId);
    emit(next);
  }
}