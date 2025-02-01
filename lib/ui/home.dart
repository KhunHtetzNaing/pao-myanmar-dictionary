import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pao_myanmar_dictionary/ext.dart';
import 'package:pao_myanmar_dictionary/ui/category.dart';
import 'package:pao_myanmar_dictionary/ui/widgets/word_tile.dart';
import 'package:url_launcher/url_launcher.dart';
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
        centerTitle: true,
        title: Text(context.tr("title")),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
              onPressed: () {
                context.setLocale(Locale(context.isMyanmar ? "en" : "my"));
              },
              icon: Icon(Icons.translate_rounded))
        ],
      ),
      body: _words.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [_searchBar(), _items()],
            ),
      drawer: _drawer(context),
    );
  }

  NavigationDrawer _drawer(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: -1,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28, top: 16, bottom: 16),
          child: Text(
            context.tr("categories"),
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ..._categories.map(
          (item) => NavigationDrawerDestination(
            icon: Icon(Icons.category_rounded),
            label: Flexible(
                child: Text(
              context.isMyanmar ? item.mm : item.pao,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
          ),
        ),
        Divider(),
        NavigationDrawerDestination(
            icon: Icon(Icons.account_circle_rounded),
            label: Text(context.tr("about")))
      ],
      onDestinationSelected: (index) {
        if (index == _categories.length) {
          _showAbout(context);
          return;
        }

        final category = _categories[index];
        final items = _repository.fetchWordsByCategory(category);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WordsByCategory(
                items: items,
                title: context.isMyanmar ? category.mm : category.pao)));
      },
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Pa'O-Myanmar Dictionary"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.update_rounded),
                    title: Text("Version"),
                    subtitle: Text("1.2.1"),
                    onTap: () => launchUrl(Uri.parse(
                        "https://github.com/KhunHtetzNaing/pao-myanmar-dictionary")),
                  ),
                  ListTile(
                    leading: Icon(Icons.terminal_rounded),
                    title: Text("Developer"),
                    subtitle: Text("Khun Htetz Naing"),
                    onTap: () => launchUrl(
                        Uri.parse("https://www.facebook.com/iamHtetzNaing")),
                  ),
                  ListTile(
                    leading: Icon(Icons.storage_rounded),
                    title: Text("Database"),
                    subtitle: Text("Khun Naing Ko"),
                    onTap: () => launchUrl(
                        Uri.parse("https://m.facebook.com/100003911637398")),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("OK"))
              ],
            ));

    // return showAboutDialog(
    //     context: context,
    //     applicationName: "Pa'O-Myanmar Dictionary",
    //     applicationVersion: "1.2.0",
    //     children: [],
    //     applicationIcon: Card(
    //       color: Theme.of(context).colorScheme.primaryContainer,
    //       child:
    //           SizedBox(width: 50, height: 50, child: Center(child: Text("က"))),
    //     ));
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
          barHintText: context.tr("search_hint"),
          suggestionsBuilder: (context, controller) {
            final query = controller.text;
            if (query.isEmpty) return [];

            final searchResult = _words.where(
                (item) => item.mm.contains(query) || item.pao.contains(query));

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
          }),
    );
  }
}
