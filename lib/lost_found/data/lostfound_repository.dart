import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class LostFoundRepository {
  final CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('items');

  // Stream for real-time reads
  Stream<List<ItemModel>> getItemsStream() {
    return _itemsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ItemModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Safe write - Add Item
  Future<void> addItem(ItemModel item) async {
    await _itemsCollection.add(item.toMap());
  }

  // Delete Item
  Future<void> deleteItem(String id) async {
    await _itemsCollection.doc(id).delete();
  }

  // Race-safe Transaction-based update for "Mark as Claimed"
  Future<void> markAsClaimed(String itemId) async {
    DocumentReference docRef = _itemsCollection.doc(itemId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("Item does not exist!");
      }

      transaction.update(docRef, {'status': 'Claimed'});
    });
  }
}