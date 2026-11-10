import 'package:flutter/material.dart';
import '../../data/lostfound_repository.dart';
import '../../models/item_model.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key}) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _postedByController = TextEditingController();
  String _status = 'Lost';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Lost/Found Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) => val!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category (e.g. Bag, Keys)'),
                validator: (val) => val!.isEmpty ? 'Please enter category' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (val) => val!.isEmpty ? 'Please enter location' : null,
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['Lost', 'Found']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (val) => setState(() => _status = val!),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (val) => val!.isEmpty ? 'Please enter description' : null,
              ),
              TextFormField(
                controller: _postedByController,
                decoration: const InputDecoration(labelText: 'Posted By'),
                validator: (val) => val!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ItemModel newItem = ItemModel(
                      id: '',
                      title: _titleController.text,
                      category: _categoryController.text,
                      location: _locationController.text,
                      status: _status,
                      description: _descriptionController.text,
                      postedBy: _postedByController.text,
                    );
                    await LostFoundRepository().addItem(newItem);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}