import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPosts {
  final PostRepository repository; // GetPosts class ka constructor jo ke PostRepository ko accept kar raha

  GetPosts(this.repository); //repo getpost

  Future<List<Post>> call() async {
    return await repository.getPosts(); //funciton call list
  }
}