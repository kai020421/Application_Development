import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';
import '../widgets/post_card.dart';
import '../widgets/post_detailsheet.dart'; 

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment 2 - Clean Architecture BLoC'),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostInitial) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  // Yahan event trigger ho raha hai (agar aapka event FetchPosts hai toh usko FetchPosts() kar lein)
                  BlocProvider.of<PostBloc>(context).add(LoadPostsEvent());
                },
                child: const Text('Load Posts'),
              ),
            );
          } else if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                // Yahan sir ka PostCard aur detail sheet call ho rahi hai
                return PostCard(
                  post: post,
                  index: index,
                  onTap: () => showPostDetailSheet(context, post),
                );
              },
            );
          } else if (state is PostError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}