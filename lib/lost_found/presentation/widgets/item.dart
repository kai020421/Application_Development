import 'package:flutter/material.dart';
import '../../models/item_model.dart';

class ItemTile extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;

  const ItemTile({Key? key, required this.item, required this.onTap})
      : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Lost':
        return Colors.redAccent;
      case 'Found':
        return Colors.green;
      case 'Claimed':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${item.category} • ${item.location}\nPosted by: ${item.postedBy}'),
        isThreeLine: true,
        trailing: Chip(
          label: Text(
            item.status,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          backgroundColor: _getStatusColor(item.status),
        ),
        onTap: onTap,
      ),
    );
  }
}