import '../../Domain/entities/post.dart';

abstract class PostState {} //class poststate basically define karegi different states jo ke post ke liye use hongi like initial, loading, loaded, error waghaura

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded({required this.posts});// ye basically postloaded state ko define karega aur posts ko pass karega jo ke load hoyi hai
}

class PostError extends PostState {
  final String message;
  PostError({required this.message});// ye basically posterror state ko define karega aur error message ko pass karega jo ke load nahi hoyi ha
}