import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/bean/hot_word_bean.dart';
import 'package:flutter_wanandroid/db/DbManager.dart';
import 'package:flutter_wanandroid/widgets/search/search_view.dart';

class HotWordView extends StatefulWidget {
  SearchBarDelegate searchBarDelegate;

  HotWordView(this.searchBarDelegate);

  @override
  HotWordState createState() => HotWordState(searchBarDelegate);
}

class HotWordState extends State<HotWordView>
    with AutomaticKeepAliveClientMixin {
  List<Data> _hotWords = List<Data>();

  SearchDao _searchDao = SearchDao();

  List<Map<String, dynamic>> _maps = List<Map<String, dynamic>>();

  SearchBarDelegate searchBarDelegate;

  HotWordState(this.searchBarDelegate);

  @override
  void initState() {
    super.initState();
    _getHotWords();
    _loadRecords();
  }

  void _loadRecords() {
    _searchDao.queryAll().then((maps) {
      setState(() {
        _maps.clear();
        _maps.addAll(maps);
      });
    });
  }

  void _getHotWords() async {
    Response response =
        await Dio().get('https://www.wanandroid.com//hotkey/json');
    var hotWordBean = HotWordBean.fromJson(json.decode(response.toString()));
    setState(() {
      _hotWords.addAll(hotWordBean.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '热搜榜',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Container(
              padding: EdgeInsets.only(top: 5),
              child: Wrap(
                spacing: 15,
                children: _hotWords
                    .map((hotWord) => ActionChip(
                          onPressed: () {
                            searchBarDelegate.query = hotWord.name;
                          },
                          label: Text(hotWord.name),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ))
                    .toList(),
              )),
          Text(
            '搜索记录',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Container(
              padding: EdgeInsets.only(top: 5),
              child: Wrap(
                spacing: 15,
                children: _maps
                    .map((map) => Chip(
                        deleteIconColor: Colors.red,
                        onDeleted: () {
                          _searchDao.delete(map['record']).then((_) {
                            _loadRecords();
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        label: Text(map['record'])))
                    .toList(),
              ))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
