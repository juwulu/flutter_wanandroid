import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/bean/article_bean.dart';
import 'package:flutter_wanandroid/widgets/browser.dart';

class SearchResultView extends StatefulWidget {
  String word;

  SearchResultView({Key key, this.word});

  @override
  SearchResultState createState() => SearchResultState(word);
}

class SearchResultState extends State<SearchResultView>
    with AutomaticKeepAliveClientMixin {
  List<Datas> _articles = List<Datas>();

  var _scrollController = ScrollController();

  int _currentPageNum = 0;

  String word;

  SearchResultState(this.word);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
    _queryArticles(0, word);
  }

  void _queryArticles(int pageNum, String word) async {
    Response response = await Dio()
        .post('https://www.wanandroid.com/article/query/$pageNum/json?k=$word');
    var articleBean = ArticleBean.fromJson(json.decode(response.toString()));
    setState(() {
      _articles.addAll(articleBean.data.datas);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _articles.length,
      itemBuilder: (context, index) => _getListItem(index),
      controller: _scrollController,
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
                      url: _article.link,
                      title: highlightTitle(_article.title),
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
                  highlightTitle(_article.title),
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

  void _loadMore() {
    _currentPageNum++;
    _queryArticles(_currentPageNum, word);
  }

  @override
  bool get wantKeepAlive => true;

  String highlightTitle(String title) {
    String title1 = title.replaceAll("<em class='highlight'>", "");
    return title1.replaceAll("</em>", "");
  }
}
