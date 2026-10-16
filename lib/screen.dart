import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'library.dart';
import 'library_provide.dart';

class BookListPage extends StatelessWidget { //stateless no chnage ke luye
  const BookListPage({super.key});

  // Q9. The detail sheet
  void _showDetailSheet(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder( //wraping sheet dabbay main
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final provider = context.read<LibraryProvider>(); //read orivider wihout change issue

        return StreamBuilder<List<Book>>( //stream is used take constant change hota rahay
          stream: provider.repository.watchBooks(),
          builder: (context, snapshot) {
            final books = snapshot.data ?? [];
            final currentBook = books.firstWhere(
              (b) => b.title == book.title && b.author == book.author, //primary key nahi hai tou combo main mix
              orElse: () => book, // original book returm
            );

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 211, 85, 207), // box details
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.menu_book, color: Color.fromARGB(255, 154, 80, 138)), // wrapping container
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // left wali part
                          children: [
                            Text(
                              currentBook.title, 
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              currentBook.author,
                              style: const TextStyle(color: Color.fromARGB(255, 121, 107, 196)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  LinearProgressIndicator( // progress batayega
                    value: currentBook.copies > 0
                        ? currentBook.available / currentBook.copies 
                        : 0,
                    backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                    color: const Color.fromARGB(255, 222, 29, 129),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Available', style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 121, 107, 196))),
                          Text(
                            '${currentBook.available}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column( //right part 
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Total copies', style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 121, 107, 196))),
                          Text(
                            '${currentBook.copies}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24), // sizinf wlai
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 179, 40, 181),
                            foregroundColor: const Color.fromARGB(255, 197, 193, 193),
                          ),
                          onPressed: currentBook.available > 0
                              ? () => provider.repository.issueBookSafely(currentBook.title)
                              : null,
                          icon: const Icon(Icons.arrow_upward, size: 16), // icon arrow wala 
                          label: const Text('Issue'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: currentBook.available < currentBook.copies // icon kia karega
                              ? () => provider.repository.returnBookSafely(currentBook.title)
                              : null,
                          icon: const Icon(Icons.arrow_downward, size: 16),
                          label: const Text('Return'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) { // build 
    final provider = context.watch<LibraryProvider>();

    return Scaffold( // scaffolding app bar wagahira
      appBar: AppBar( // top uppar library wali jagah
        title: const Text('Library', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 155, 9, 143),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0), 
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration( // search bar ka decor
                    hintText: 'Search by author',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)), 
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (val) => provider.setSearchAuthorQuery(val), //search bar changing
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,  // switch jismain filter hojaye
                  children: [ 
                    const Text('Show only available'), // availablity slider
                    Switch(
                      value: provider.onlyAvailable,
                      onChanged: (val) => provider.toggleOnlyAvailable(val), //toggle kare with availability of authro
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Book>>( // stream change walay data ke liye 
              stream: provider.repository.watchBooks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) { // data laoad
                  return const Center(child: CircularProgressIndicator()); // inficator
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final rawBooks = snapshot.data ?? []; 
                final books = provider.filterBooks(rawBooks); //filter available aur other yani search aur toggle wali xheez

                if (books.isEmpty) {
                  return const Center(
                    child: Text('No books match your criteria.'), // matcg na ho tou
                  );
                }

                return ListView.builder( // list viuew books
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];

                    return Card( // main list view warap 
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () => _showDetailSheet(context, book),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.menu_book, color: Colors.pink), // container warapping icon
                        ),
                        title: Text(
                          book.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: book.isNotAvailable ? Colors.red : Colors.black, // jo availanle nahi uska card
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [
                            Text(book.author),
                            const SizedBox(height: 4),
                            // not availble condiiton
                            book.isNotAvailable
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Not Available',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Text(
                                    '${book.available} / ${book.copies} available',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                          ],
                        ),
                        trailing: Row( //list tile ke right side main arrow up and down
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_upward, size: 18),
                              onPressed: book.available > 0
                                  ? () => provider.repository.issueBookSafely(book.title)
                                  : null,
                            ),
                            IconButton( 
                              icon: const Icon(Icons.arrow_downward, size: 18),
                              onPressed: book.available < book.copies
                                  ? () => provider.repository.returnBookSafely(book.title)
                                  : null,
                            ),
                          ],
                        ),
                      ),
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