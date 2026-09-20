import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/post.dart';

class ApiResponse<T>{
  const ApiResponse({required this.statusCode, required this.data});
  final int statusCode;
  final T data;

  String? get title => null;
}
class PostApi{
  PostApi({http.Client? client}):
  _client = client ?? http.Client();

  static final _base = Uri.parse('https://jsonplaceholder.typicode.com/posts');

  final http.Client _client;
  
  Future<ApiResponse<List<Post>>> fetchPosts() async{
    final response = await _client.get(_base);
    if(response.statusCode!=200){
      throw Exception('GET /posts failed: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as List<dynamic>;
    final posts = body
     .cast<Map<String, dynamic>>()
     .map(Post.fromJson)
     .toList();
   return ApiResponse(statusCode: response.statusCode, data: posts);
  }

}