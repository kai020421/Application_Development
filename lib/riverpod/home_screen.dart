import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/riverpod/favourites_screen.dart';
import 'package:project/riverpod/product_row.dart';
import 'package:project/riverpod/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
 const HomeScreen({super.key});
 @override
 ConsumerState<HomeScreen> createState() =>
 _HomeScreenState();
}
class _HomeScreenState
 extends ConsumerState<HomeScreen>
 with SingleTickerProviderStateMixin {
   late TabController _tabController;
 @override
 void initState() {
   super.initState();
    _tabController = TabController(
       length: 1, vsync: this
       );
 }
 @override
 Widget build(BuildContext context) {
 final categoriesAsync =
 ref.watch(categoriesProvider);
 final productsAsync =
 ref.watch(productsProvider);
 return categoriesAsync.when(
 data: (cats) {
 final tabs = ['All', ...cats];
 return DefaultTabController(
 length: tabs.length,
 child: Scaffold(
 appBar: AppBar(
 title: const Text('Fakestore Deals'),
 bottom: TabBar(
 isScrollable: true,
 tabs: tabs
 .map((t) => Tab(text: t))
 .toList(),
 ),
 actions: [
 IconButton(
 icon: const Icon(Icons.favorite),
 onPressed: () => Navigator.push(
 context,
 MaterialPageRoute(
 builder: (_) =>
 const FavoritesScreen(),
 ),
 ),
 ),
 ],
 ),
 body: productsAsync.when(
 data: (allProducts) => TabBarView(
 children: tabs.map((tab) {
 final list = tab == 'All'
 ? allProducts
 : allProducts
 .where((p) =>
 p.category == tab)
 .toList()
 ..sort((a, b) => b.rating
 .compareTo(a.rating));
 return ListView.builder(
 itemCount: list.length,
 itemBuilder: (_, i) =>
 ProductRow(list[i]),
 );
 }).toList(),
 ),
 loading: () => const Center(
 child:
 CircularProgressIndicator()),
 error: (e, _) =>
 Center(child: Text('Error: $e')),
 ),
 ),
 );
 },
 loading: () => const Center(
 child: CircularProgressIndicator()),
 error: (e, _) =>
 Center(child: Text('Error: $e')),
 );
 }
 }