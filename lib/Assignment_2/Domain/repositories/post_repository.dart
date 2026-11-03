import '../entities/post.dart';

abstract class PostRepository { //abstract class isliye kiyonke we want to define a contract for the repository without providing an implementation
//faide is flexibility and clear interfacwe to call abstract class methods
  Future<List<Post>> getPosts(); //abstract method jo ke post ko get karne ke liye use hoga
}