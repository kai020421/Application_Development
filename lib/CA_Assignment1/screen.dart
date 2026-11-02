//PART A & PART B
import 'package:flutter/material.dart';
import 'post.dart';

class UserDetailScreen extends StatelessWidget { // stateless widget jo user detail screen ke liye hai
  final User user;

  const UserDetailScreen({super.key, required this.user}); // constructor jo user ko pass karta hai

  @override
  Widget build(BuildContext context) { // build method jo widget tree ko return karta hai
    return Scaffold( // baisc sructure
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      floatingActionButton: FloatingActionButton( // floating action button jo message bhejne ke liye hai
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar( // snackbar jo message bhejne ke liye hai tab 2 par
            const SnackBar(content: Text('Message Sent')),
          );
        },
        child: const Icon(Icons.message), // message icon jo button par dikhe
      ),
      body: SingleChildScrollView( //contetn ko scrollable banaye 
        padding: const EdgeInsets.all(16.0), // padding jo content ke around space create kare
        child: Column(
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 40,
              child: Text(
                user.initials,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith( // headline small text ko bold aur large banaye
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              user.company.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(user.email),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(user.phone),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text('${user.address.street}, ${user.address.city}'),
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: Text(user.company.name),
            ),
          ],
        ),
      ),
    );
  }
} 