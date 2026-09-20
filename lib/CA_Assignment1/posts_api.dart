
// PART A
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


