import 'package:flutter/material.dart';
import '../../data/lostfound_repository.dart';
import '../../models/item_model.dart';
import '../widgets/item.dart';
import 'item_detail.dart';
import 'add_item.dart';

class LostFoundListPage extends StatefulWidget {
  const LostFoundListPage({Key? key}) : super(key: key);

  @override
  State<LostFoundListPage> createState() => _LostFoundListPageState();
}

class _LostFoundListPageState extends State<LostFoundListPage> {
  final LostFoundRepository _repository = LostFoundRepository();
  String _searchQuery = '';
  String _selectedStatusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IBA Lost & Found'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddItemPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search by title...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedStatusFilter,
                  items: ['All', 'Lost', 'Found', 'Claimed']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatusFilter = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ItemModel>>(
              stream: _repository.getItemsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No items found.'));
                }

                var filteredItems = snapshot.data!.where((item) {
                  final matchesSearch =
                      item.title.toLowerCase().contains(_searchQuery);
                  final matchesStatus = _selectedStatusFilter == 'All' ||
                      item.status == _selectedStatusFilter;
                  return matchesSearch && matchesStatus;
                }).toList();

                if (filteredItems.isEmpty) {
                  return const Center(child: Text('No matching items.'));
                }

                return ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return ItemTile(
                      item: item,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemDetailPage(itemId: item.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}