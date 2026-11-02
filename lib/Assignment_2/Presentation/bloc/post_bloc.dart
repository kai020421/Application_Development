import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Domain/use_cases/get_posts.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPosts getPosts;

  PostBloc({required this.getPosts}) : super(PostInitial()) {
    on<LoadPostsEvent>((event, emit) async {
      emit(PostLoading());
      try {
        final posts = await getPosts();
        emit(PostLoaded(posts: posts));
      } catch (e) {
        emit(PostError(message: e.toString()));
      }
    });
  }
}