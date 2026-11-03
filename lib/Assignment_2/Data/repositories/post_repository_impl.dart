import '../../Domain/entities/post.dart';
import '../../Domain/repositories/post_repository.dart';
import '../datasources/post_remote_datasource.dart';

class PostRepositoryImpl implements PostRepository { //class imp postrepository jo ke remote datasource ko use kar ke data fetch karegii
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource}); // remotedatasoirce constructor main initialize kar rahe hain

  @override
  Future<List<Post>> getPosts() async {
    try {
      final remotePosts = await remoteDataSource.getPosts(); // data fetch kar rahay
      return remotePosts;
    } catch (e) {
      throw Exception('Could not fetch posts. Please check your connection.');
    }
  }
}