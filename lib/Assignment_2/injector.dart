import 'package:http/http.dart' as http;
import 'Data/datasources/post_remote_datasource.dart';
import 'Data/repositories/post_repository_impl.dart';
import 'Domain/use_cases/get_posts.dart';

/// Manual dependency injection for the posts feature: wires
/// data source -> repository -> use case, in that order, so PostsPage only
/// ever has to ask for a [GetPosts].
GetPosts buildGetPosts() {
  final remoteDataSource = PostRemoteDataSourceImpl(client: http.Client());
  final repository = PostRepositoryImpl(remoteDataSource: remoteDataSource);
  return GetPosts(repository);
}