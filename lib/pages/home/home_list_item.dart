import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/bean/article_bean.dart';
import 'package:flutter_wanandroid/widgets/browser.dart';

class ArticleListPage extends StatefulWidget {
  String type;

  ArticleListPage({Key key, this.type});

  @override
  ArticleListState createState() => ArticleListState(type);
}

class ArticleListState extends State<ArticleListPage>
    with AutomaticKeepAliveClientMixin {
  List<Datas> _articles = List<Datas>();

  var _scrollController = ScrollController();

  int _currentPageNum = 0;

  String type;

  ArticleListState(this.type);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
    _getArticles(0);
  }

  void _getArticles(int pageNum) async {
    Response response =
        await Dio().get("https://www.wanandroid.com/$type/list/$pageNum/json");
    var articleBean = ArticleBean.fromJson(json.decode(response.toString()));
    setState(() {
      _articles.addAll(articleBean.data.datas);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: _articles.length != 0
          ? ListView.builder(
              itemCount: _articles.length,
              itemBuilder: (context, index) => _getListItem(index),
              controller: _scrollController,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _getListItem(int index) {
    var _article = _articles[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Browser(
                      isCollected: _article.collect,
                      id: _article.id,
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
                          _article.chapterName +
                              '/' +
                              _article.superChapterName,
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
                Text(_article.author == ""
                    ? '分享人:' + _article.shareUser
                    : '作者:' + _article.author),
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

  Future<void> _onRefresh() async {
    _articles.clear();
    _currentPageNum = 0;
    _getArticles(_currentPageNum);
  }

  void _loadMore() {
    _currentPageNum++;
    _getArticles(_currentPageNum);
  }

  @override
  bool get wantKeepAlive => true;
}
