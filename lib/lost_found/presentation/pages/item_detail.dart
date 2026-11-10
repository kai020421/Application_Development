import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/lostfound_repository.dart';
import '../../models/item_model.dart';

class ItemDetailPage extends StatelessWidget {
  final String itemId;
  const ItemDetailPage({Key? key, required this.itemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LostFoundRepository repository = LostFoundRepository();

    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('items').doc(itemId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Item not found or deleted.'));
          }

          var item = ItemModel.fromMap(
              snapshot.data!.data() as Map<String, dynamic>, snapshot.data!.id);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Chip(label: Text('Status: ${item.status}'), backgroundColor: Colors.amber.shade100),
                const SizedBox(height: 12),
                Text('Category: ${item.category}', style: const TextStyle(fontSize: 16)),
                Text('Location: ${item.location}', style: const TextStyle(fontSize: 16)),
                Text('Posted By: ${item.postedBy}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(item.description, style: const TextStyle(fontSize: 15)),
                const Spacer(),
                if (item.status != 'Claimed')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () async {
                        try {
                          await repository.markAsClaimed(item.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Marked as Claimed successfully!')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      },
                      child: const Text('Mark as Claimed (Transaction)', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () async {
                      await repository.deleteItem(item.id);
                      Navigator.pop(context);
                    },
                    child: const Text('Delete Item'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}