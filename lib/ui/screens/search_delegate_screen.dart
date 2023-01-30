import 'package:flutter/material.dart';
import 'package:notchy/providers/product_provider.dart';
import 'package:notchy/ui/widget/product_card.dart';

class SearchDelegateScreen extends SearchDelegate<String> {
  SearchDelegateScreen({this.context, required this.initialList}) {
    filteredList = List.of(initialList);
  }

  BuildContext? context;
  List<dynamic> initialList;
  List<dynamic> filteredList = [];

  @override
  String get searchFieldLabel => 'Search Product';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, 'null');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<dynamic> items = filteredList
        .where((element) =>
            element.title.contains(RegExp(query, caseSensitive: false)))
        .toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 190 / 183,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (content, index) => ChangeNotifierProvider<ProductProvider>(
        key: Key('${items[index].id}'),
        create: (_) => ProductProvider(items[index]),
        child: const ProductCard(),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<dynamic> items = filteredList
        .where((element) =>
            element.title.contains(RegExp(query, caseSensitive: false)))
        .toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 190 / 183,
      ),
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shrinkWrap: true,
      itemBuilder: (content, index) => ChangeNotifierProvider<ProductProvider>(
        key: Key('${items[index].id}'),
        create: (_) => ProductProvider(items[index]),
        child: const ProductCard(),
      ),
    );
  }
}
