import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pao_myanmar_dictionary/data/word.dart';
import 'package:pao_myanmar_dictionary/ui/widgets/word_tile.dart';

class WordsByCategory extends StatelessWidget {
  const WordsByCategory({super.key, required this.items, required this.title});
  final List<WordItem> items;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          SearchAnchor(
              viewHintText: context.tr("search_hint"),
              builder: (context, controller) => IconButton(
                  onPressed: () => controller.openView(),
                  icon: Icon(Icons.search_rounded)),
              suggestionsBuilder: (context, controller) {
                final query = controller.text;
                if (query.isEmpty) return [];

                final searchResult = items.where((item) =>
                    item.mm.contains(query) || item.pao.contains(query));

                if (searchResult.isEmpty) {
                  return [
                    Container(
                        padding: EdgeInsets.all(16),
                        child: Text("empty".tr(args: [query])))
                  ];
                }

                return searchResult.map((item) => WordTile(
                      item: item,
                    ));
              })
        ],
      ),
      body: items.isEmpty
          ? Center(child: Text("empty".tr(args: [title])))
          : ListView(
              children: items.map((item) => WordTile(item: item)).toList(),
            ),
    );
  }
}
