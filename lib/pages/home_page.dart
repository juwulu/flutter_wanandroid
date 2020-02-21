import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/home/home_list_item.dart';
import 'package:flutter_wanandroid/pages/home/wx_host_item.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static var _tabs = <Tab>[
    Tab(
      text: '最新',
    ),
    Tab(
      text: '广场',
    ),
    Tab(
      text: '问答',
    ),
    Tab(
      text: '项目',
    ),
    Tab(
      text: '公众号',
    )
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      print('${_tabController.index} ${_tabController.previousIndex}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        height: 42,
        child: TabBar(
          tabs: _tabs,
          controller: _tabController,
          labelColor: Colors.blue,
          indicatorColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelColor: Colors.black,
        ),
      ),
      Divider(
        height: 0.5,
        color: Color(0x50000000),
      ),
      Expanded(
          child: Container(
        child: TabBarView(
          children: <Widget>[
            ArticleListPage(
              type: 'article',
            ),
            ArticleListPage(
              type: 'user_article',
            ),
            ArticleListPage(
              type: 'wenda',
            ),
            ArticleListPage(
              type: 'project',
            ),
            WxHostPage()
          ],
          controller: _tabController,
        ),
      ))
    ]);
  }
}
