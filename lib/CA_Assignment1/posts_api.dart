
// PART A
/*
import 'dart:convert'; //json ke liye
import 'package:http/http.dart' as http; //get post wali cheez
import 'post.dart';//this is basically the user model wali class

class ApiResponse<T> { //t generral entry
  final int statusCode; //run 200 ok ok
  final T data;//user ka data

  const ApiResponse({required this.statusCode, required this.data}); //status code aur data is compulsory for making object jaise construtor banay
}

class UserApi { //api ko user interface se alag rakhna hai ta ke usko alag call karlain
  final http.Client _client; // calling client on http network
  static final _base = Uri.parse('https://jsonplaceholder.typicode.com/users'); 

  UserApi({http.Client? client}) : _client = client ?? http.Client(); //dependecy hai ke client ho tou wo pass ho warna default client use hoga

  Future<ApiResponse<List<User>>> fetchUsers() async { // yeh function api se data fetch karega aur user ka list return karega
    final response = await _client.get(_base); // yeh line api se data fetch kar rahi hai aur response me store kar rahi hai
    if (response.statusCode != 200) {  // agar status code 200 nahi hai tou exception throw kar do
      throw Exception('Failed to fetch users: ${response.statusCode}');
    }
    final List<dynamic> body = jsonDecode(response.body); // jsonDecode se response ka body ko decode kar ke list me convert kar diya
    final users = body.map((json) => User.fromJson(json)).toList(); // list ke har json ko User model me convert kar ke list me store kar diya
    return ApiResponse(statusCode: response.statusCode, data: users); // return kar diya api response object me status code aur data ke sath
  }
}


*/
// PART B

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'post.dart';

class NoInternetException implements Exception { // internet na ho tou retry ke saath ye aye
  final String message;
  NoInternetException([this.message = 'No internet connection']);
  @override
  String toString() => message;
}

class ServerException implements Exception { // server error 
  final String message;
  ServerException([this.message = 'Server error occurred']);
  @override
  String toString() => message;
}

class DataParsingException implements Exception { //data na aaye
  final String message;
  DataParsingException([this.message = 'Failed to parse response data']);
  @override
  String toString() => message;
}

class UserApi {
  final http.Client _client;
  static final _base = Uri.parse('https://jsonplaceholder.typicode.com/users');

  UserApi({http.Client? client}) : _client = client ?? http.Client();

  Future<List<User>> fetchUsers() async { //timepit ke liye async await use kiya hai aur list of user return karega
    try {
      
      final response = await _client.get(_base).timeout( // 8 second se ziqada time lagay api call, exception dedo
        const Duration(seconds: 8),
        onTimeout: () {
          throw TimeoutException('Connection timed out. Please try again.');
        },
      );

      if (response.statusCode == 200) { // agar run hojaye tou data json se decode karke user model dedo
        final List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => User.fromJson(json)).toList();
      } else {
        throw ServerException('Server returned code: ${response.statusCode}');
      }
    } on SocketException {
      throw NoInternetException('No internet connection. Check your network.');
    } on FormatException {
      throw DataParsingException('Invalid data received from server.');
    } catch (e) {
      rethrow;
    }
  }
}