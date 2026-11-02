import '../../entities/post.dart';
import '../../repositories/post_repository.dart';
import '../datasources/post_remote_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Post>> getPosts() async {
    try {
      final remotePosts = await remoteDataSource.getPosts();
      return remotePosts;
    } catch (e) {
      throw Exception('Could not fetch posts. Please check your connection.');
    }
  }
}