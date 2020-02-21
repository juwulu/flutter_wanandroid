import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/bean/project_bean.dart';
import 'package:flutter_wanandroid/widgets/browser.dart';

class ProjectListPage extends StatefulWidget {
  int id;

  String title;

  ProjectListPage({Key key, this.id, this.title});

  @override
  ProjectListState createState() => ProjectListState(id, title);
}

class ProjectListState extends State<ProjectListPage>
    with AutomaticKeepAliveClientMixin {
  List<Datas> _projects = List<Datas>();

  var _scrollController = ScrollController();

  int _currentPageNum = 0;

  int id;

  String title;

  ProjectListState(this.id, this.title);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
    _getProjects(0);
  }

  void _getProjects(int pageNum) async {
    Response response = await Dio()
        .get('https://www.wanandroid.com/project/list/$pageNum/json?cid=$id');
    var articleBean = ProjectBean.fromJson(json.decode(response.toString()));
    setState(() {
      _projects.addAll(articleBean.data.datas);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _projects.length != 0
            ? ListView.builder(
                itemCount: _projects.length,
                itemBuilder: (context, index) => _getListItem(index),
                controller: _scrollController,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget _getListItem(int index) {
    var _article = _projects[index];
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
    _projects.clear();
    _currentPageNum = 0;
    _getProjects(_currentPageNum);
  }

  void _loadMore() {
    _currentPageNum++;
    _getProjects(_currentPageNum);
  }

  @override
  bool get wantKeepAlive => true;
}
