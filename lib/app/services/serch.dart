import 'package:flutter/material.dart';

class SearchSurah extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(child: Text("data"));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text("data"));
  }
}
