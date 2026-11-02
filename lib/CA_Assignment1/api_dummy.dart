//PART A
/*
import 'package:flutter/material.dart';
import 'package:project/CA_Assignment1/screen.dart'; // user ki detail screen ke liye
import 'posts_api.dart';// api se data fetch karne ke liye
import 'post_card.dart';// user card
import 'post.dart';// user model

class PostsPage extends StatefulWidget { // stateful widget state change ho tou widget rebuild ho jaye
  const PostsPage({super.key}); // constructor

  @override
  State<PostsPage> createState() => _PostsPageState(); // state create karne ke liye
}

class _PostsPageState extends State<PostsPage> with SingleTickerProviderStateMixin { // state wahi staeful widget, single ticker animation ke liye horti
  late TabController _tabController; // tab controller jo tab bar par hota left right distribute aur swipe ke liye
  final TextEditingController _searchController = TextEditingController(); // tab controller ke saath jo search bar hai text controller ke liye 
  
  List<User> _allUsers = []; //user list api se jo aaye /user wali
  bool _isLoading = true; // data loading ho rahi
  String? _errorMessage;// error msg ko store
  String _searchQuery = '';// search ko store

  @override 
  void initState() { // init state method jo widget ke state ko initialize karta hai
    super.initState(); //calling
    _tabController = TabController(length: 2, vsync: this);//2 tabs laanay ke liye
    _tabController.addListener(() => setState(() {})); // tab chamnge, state of widget update
    _searchController.addListener(() { //search bar main jab text change ho tou widget update
      setState(() {
        _searchQuery = _searchController.text.toLowerCase(); // search insensitve case, chahy bara chahy chota
      }); 
    });
    _loadUsers(); //user load hojaye call karne par
  }

  Future<void> _loadUsers() async { // api se data fetch karne ke liye
    setState(() { //update state, load true maian ho aur error nahi aaye
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await UserApi().fetchUsers(); // api se data fetch karne ke liye
      setState(() { // state update, data load ho jaye aur error nahi aaye
        _allUsers = response.data;
        _isLoading = false;
      });
    } catch (e) { // agar error aaye tou state update, load false ho aur error msg show ho
      setState(() { 
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<User> get _filteredUsers { //search tab ke hisab se filtered user aaye
    List<User> baseList = _tabController.index == 0 // jab tab main 0 ho tou all users, warna fav show ho
        ? _allUsers
        : _allUsers.where((u) => u.isFavorite).toList();

    if (_searchQuery.isEmpty) return baseList; // search empty tou base lsit aajayegi
    return baseList.where((u) => u.name.toLowerCase().contains(_searchQuery)).toList(); // case insenstivie karke search ke hisab se filter
  }

  @override
  void dispose() { // widegt state dispose take memory leak na ho 
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { // build method jo widget tree ko return karta hai
    return Scaffold( // scaffold widget jo app ka basic structure banaye
      appBar: AppBar( //app bar widhet jo top par dikhe
        title: const Text('Student Directory'), 
        bottom: TabBar( //tab bar jo app bar ke neeche aaye
          controller: _tabController,
          tabs: const [
            Tab(text: 'All users'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: Column( // column arange jo widget ko vertcial karain
        children: [
          Padding( // padding widget jo child widget ke around space create kare
            padding: const EdgeInsets.all(12.0),
            child: SearchBar( //search bar
              controller: _searchController, //search bar main text controller wali
              hintText: 'Search students...',
              leading: const Icon(Icons.search),
            ),
          ),
          Expanded( // expand widget ho basically child ko space de aur scroll ho sakte
            child: RefreshIndicator(
              onRefresh: _loadUsers,
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() { // body widget jo user list ko show kare
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator()); // loading indicator show kare jab data load ho raha ho
    } 
    if (_errorMessage != null) { //error hai tou error dikhado
      return Center(
        child: Text(
          'Error: $_errorMessage',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final users = _filteredUsers; 
    if (users.isEmpty) {
      return ListView( 
        children: const [
          SizedBox(height: 100),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // center align karne ke liye
              children: [
                Icon(Icons.person_off, size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('No users found', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder( // list view builder jo user list ko show kare
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserCard(
          user: user,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailScreen(user: user), // user detail screen par navigate karne ke liye
              ),
            );
          },
          onFavoriteToggle: () {
            setState(() {
              user.isFavorite = !user.isFavorite;
            });
          },
        );
      },
    );
  }
}
*/

//PART B

import 'package:flutter/material.dart';
import 'post.dart';
import 'posts_api.dart';
import 'post_card.dart';
import 'screen.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<User> _allUsers = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await UserApi().fetchUsers();
      setState(() {
        _allUsers = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<User> _getFilteredUsers({required bool favoritesOnly}) {
    return _allUsers.where((user) {
      final matchesTab = favoritesOnly ? user.isFavorite : true;
      final matchesSearch = user.name.toLowerCase().contains(_searchQuery);
      return matchesTab && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Directory'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Users'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search students...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    
    if (_errorMessage != null) { //error state update load false aur error msg show
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red), 
              const SizedBox(height: 12),
              Text(
                _errorMessage!, // error msg show
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon( // retry button jo error main aaye aur refresh jarsakt
                onPressed: _loadUsers,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              )
            ],
          ),
        ),
      );
    }

    final isFavoritesTab = _tabController.index == 1;
    final displayedUsers = _getFilteredUsers(favoritesOnly: isFavoritesTab);

    if (displayedUsers.isEmpty) { // agar user list empty ho tou empty state show
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_off, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              isFavoritesTab ? 'No favorites added yet' : 'No users found',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator( // refresh jo pull karke hota usse data feload
      onRefresh: _loadUsers,
      child: ListView.builder(
        itemCount: displayedUsers.length,
        itemBuilder: (context, index) {
          final user = displayedUsers[index];
          return UserCard(
            user: user,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailScreen(user: user),
                ),
              );
            },
            onFavoriteToggle: () { //fav click karke fav toggle karsakte
              setState(() {
                user.isFavorite = !user.isFavorite;
              });
            },
          );
        },
      ),
    );
  }
}