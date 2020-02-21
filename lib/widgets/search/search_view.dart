import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/db/DbManager.dart';
import 'package:flutter_wanandroid/widgets/search/search_result.dart';
import 'package:flutter_wanandroid/widgets/search/search_suggestion.dart';

class SearchBarDelegate extends SearchDelegate {
  SearchDao _searchDao = new SearchDao();

  @override
  String get searchFieldLabel => '请输入关键字';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, '');
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    _searchDao.insert(query);
    return SearchResultView(
      word: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return HotWordView(this);
  }
}
