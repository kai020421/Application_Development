//PART A
/*
import 'package:flutter/material.dart';
import 'api_dummy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { // stateless widget jo app ke liye root widget hai
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) { // build method jo widget tree ko return karta hai
    return MaterialApp(
      title: 'Student Directory',
      debugShowCheckedModeBanner: false, // debug banner ko hide karne ke liye
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PostsPage(),
    );
  }
}
*/

// PART B
import 'package:flutter/material.dart';
import 'api_dummy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Directory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PostsPage(),
    );
  }
}