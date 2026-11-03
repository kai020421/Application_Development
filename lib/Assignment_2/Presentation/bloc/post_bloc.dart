import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Domain/use_cases/get_posts.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> { //bloc extend jo ke post event aur post state ko use karegi
  final GetPosts getPosts;

  PostBloc({required this.getPosts}) : super(PostInitial()) { //initial state is postinitial
    on<LoadPostsEvent>((event, emit) async { //loadpostevent basically wo function hai jo ke post ko load karega aur emit karega state ko
      emit(PostLoading());
      try {
        final posts = await getPosts();
        emit(PostLoaded(posts: posts)); //emit postloaded state with posts
      } catch (e) {
        emit(PostError(message: e.toString())); //emit posterror state with error message
      }
    });
  }
}