import 'package:flutter/material.dart';
import 'post.dart';
import 'posts_api.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late final Future<ApiResponse<List<Post>>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = PostApi().fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Custom Header Bar instead of AppBar
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).colorScheme.primaryContainer,
              width: double.infinity,
              child: Text(
                'API Posts List',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
            ),
            // Body Content using Expanded & FutureBuilder
            Expanded(
              child: FutureBuilder<ApiResponse<List<Post>>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final posts = snapshot.data!.data;
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${post.id}'),
                            ),
                            title: Text(
                              post.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              post.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text('No posts found.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}