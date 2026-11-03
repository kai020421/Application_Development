import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Domain/use_cases/get_posts.dart';
import '../../Domain/entities/post.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';
import '../widgets/post_card.dart';

const _accent = Color(0xFF2F6F5E);
const _accentDeep = Color(0xFF1C4A3D);

class PostsPage extends StatelessWidget {
  const PostsPage({super.key, required this.getPosts});

  final GetPosts getPosts;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(getPosts: getPosts)..add(LoadPostsEvent()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8F7),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            final count = switch (state) {
              PostLoaded(:final posts) => posts.length,
              _ => null,
            };

            return CustomScrollView(
              slivers: [
                _PostsAppBar(count: count),
                switch (state) {
                  PostInitial() || PostLoading() =>
                    const SliverFillRemaining(child: _LoadingView()),
                  PostLoaded(:final posts) => SliverFillRemaining(
                      child: RefreshIndicator(
                        color: _accent,
                        onRefresh: () async {
                          context.read<PostBloc>().add(LoadPostsEvent());
                          await context
                              .read<PostBloc>()
                              .stream
                              .firstWhere((s) => s is! PostLoading);
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: posts.length,
                          itemBuilder: (context, index) => PostCard(
                            post: posts[index],
                            index: index,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostDetailPage(post: posts[index]),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  PostError(:final message) => SliverFillRemaining(
                      child: _ErrorView(
                        message: message,
                        onRetry: () =>
                            context.read<PostBloc>().add(LoadPostsEvent()),
                      ),
                    ),
                  PostState() => const SliverFillRemaining(
                      child: SizedBox.shrink(),
                    ),
                },
              ],
            );
          },
        ),
      ),
    );
  }
}

/// A dedicated separate screen to show the full post title and body.
class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _accentDeep,
        title: Text(
          'Post #${post.id}',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C4A3D),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFD1DCD8)),
            const SizedBox(height: 16),
            Text(
              post.body,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7A76),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostsAppBar extends StatelessWidget {
  const _PostsAppBar({required this.count});

  final int? count;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 108,
      backgroundColor: _accentDeep,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_accentDeep, _accent],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Posts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  count == null ? 'Loading…' : '$count posts',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: _accent),
          SizedBox(height: 14),
          Text('Loading posts…', style: TextStyle(color: Color(0xFF6B7A76))),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded, size: 40, color: _accent),
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7A76)),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _accent,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}