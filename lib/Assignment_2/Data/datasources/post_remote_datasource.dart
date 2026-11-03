import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

abstract class PostRemoteDataSource { 
  Future<List<PostModel>> getPosts();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource { //class implemnting posremote datasource jo ke basically client ko use kar ke data fetch karega
  final http.Client client;

  PostRemoteDataSourceImpl({required this.client}); //initializing the client in constructor

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts from server');
    }
  }
}