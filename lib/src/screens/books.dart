import 'package:flutter/material.dart';
import '../modals/bible_responses.dart';
import '../bloc/general_provider.dart';
import 'navigation_drawer.dart';

class BibleBooksScreen extends StatelessWidget {
  final List<BibleBookModal> books;

  BibleBooksScreen({@required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Books')),
      body: _uiBuilder(context),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
    );
  }

  Widget _uiBuilder(BuildContext context) {
    // print('Building Bible Tab');
    return _bookList(context);
  }

  Widget _bookList(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (cntxt, index) {
        return Card(
          elevation: 2,
          child: ListTile(
            title: Text(books[index].name),
            //subtitle: Text(bibles[index].description),
            onTap: () {},
          ),
        );
      },
    );
  }
}
