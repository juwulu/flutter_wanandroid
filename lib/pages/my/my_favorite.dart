import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/bean/favorite_bean.dart';
import 'dart:convert';

import 'package:flutter_wanandroid/widgets/browser.dart';
import 'package:path_provider/path_provider.dart';

class MyFavoritePage extends StatefulWidget {
  @override
  MyFavoriteState createState() => MyFavoriteState();
}

class MyFavoriteState extends State<MyFavoritePage> {
  List<Datas> _favorites = List<Datas>();

  ScrollController _scrollController = ScrollController();

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('我的收藏'),
      ),
      body: _getBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
    _getFavorites(_currentPage);
  }

  void _getFavorites(int pageNum) async {
    Dio dio = Dio();
    Directory directory = await getApplicationDocumentsDirectory();
    dio.interceptors.add(CookieManager(PersistCookieJar(dir: directory.path)));
    Response response = await dio
        .get('https://www.wanandroid.com/lg/collect/list/$pageNum/json');
    var favoriteBean = FavoriteBean.fromJson(json.decode(response.toString()));
    setState(() {
      _favorites.addAll(favoriteBean.data.datas);
    });
  }

  void _loadMore() {
    _currentPage++;
    _getFavorites(_currentPage);
  }

  Widget _getListItem(int index) {
    var _article = _favorites[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Browser(
                      url: _article.link,
                      title: _article.title,
                    )));
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Align(
                        alignment: FractionalOffset.centerLeft,
                        child: Text(
                          _article.chapterName,
                          style: TextStyle(color: Colors.blue),
                        )),
                    Align(
                      alignment: FractionalOffset.centerRight,
                      child: Text(_article.niceDate),
                    )
                  ],
                ),
                Text(
                  _article.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black12,
            height: 1,
          ),
        ],
      ),
    );
  }

  Widget _getBody() => ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) => _getListItem(index),
        controller: _scrollController,
      );
}
