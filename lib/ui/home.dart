import 'package:flutter/material.dart';
import 'package:pao_myanmar_dictionary/ui/category.dart';
import 'package:pao_myanmar_dictionary/ui/widgets/word_tile.dart';
import '../data/category.dart';
import '../data/repository.dart';
import '../data/word.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repository = Repository();
  final List<WordItem> _words = [];
  final List<CategoryItem> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _repository.init();
    setState(() {
      _words.addAll(_repository.fetchWords());
      _categories.addAll(_repository.fetchCategories());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ပအိုဝ်ႏ-မန်း"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [_searchBar(), _items()],
      ),
      drawer: NavigationDrawer(
        selectedIndex: -1,
        children: _categories
            .map(
              (item) => NavigationDrawerDestination(
                icon: Icon(Icons.category_rounded),
                label: Flexible(
                    child: Text(
                  item.pao,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
              ),
            )
            .toList(),
        onDestinationSelected: (index) {
          final category = _categories[index];
          final items = _repository.fetchWordsByCategory(category);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  WordsByCategory(items: items, title: category.pao)));
        },
      ),
    );
  }

  Expanded _items() {
    return Expanded(
      child: ListView(
        children: _words
            .map((item) => WordTile(
                  item: item,
                ))
            .toList(),
      ),
    );
  }

  Padding _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SearchAnchor.bar(
          barHintText: "ထိုမ်ႏ",
          suggestionsBuilder: (context, controller) {
            final query = controller.text;
            if (query.isEmpty) return [];

            final searchResult = _words.where(
                (item) => item.mm.contains(query) || item.pao.contains(query));
            return searchResult.map((item) => WordTile(
                  item: item,
                ));
          }),
    );
  }
}
