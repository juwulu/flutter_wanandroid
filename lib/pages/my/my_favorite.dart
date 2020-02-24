import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/bean/favorite_bean.dart';
import 'dart:convert';

import 'package:flutter_wanandroid/widgets/browser.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                      isCollected: true,
                      id: _article.id,
                      url: _article.link,
                      title: _article.title,
                    )));
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                        alignment: FractionalOffset.centerLeft,
                        child: Text(
                          '${_article.chapterName} ${_article.niceDate}',
                          style: TextStyle(color: Colors.blue),
                        )),
                    Text(
                      _article.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _removeFavorite(_article);
                    },
                  ),
                )
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

  Widget _getBody() => _favorites.length == 0
      ? Center(
          child: Text('暂无收藏'),
        )
      : ListView.builder(
          itemCount: _favorites.length,
          itemBuilder: (context, index) => _getListItem(index),
          controller: _scrollController,
        );

  void _removeFavorite(Datas article) async {
    Dio dio = Dio();
    Directory directory = await getApplicationDocumentsDirectory();
    dio.interceptors.add(CookieManager(PersistCookieJar(dir: directory.path)));
    Response response = await dio.post(
        'https://www.wanandroid.com/lg/uncollect/${article.id}/json?originId=-1');
    CollectBean removeBean =
        CollectBean.fromJson(json.decode(response.toString()));
    if (removeBean.errorCode == 0) {
      setState(() {
        _favorites.remove(article);
      });
      Fluttertoast.showToast(
          msg: "取消收藏成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
