import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/bean/wx_host_bean.dart';
import 'package:flutter_wanandroid/pages/home/wx_list_item.dart';

class WxHostPage extends StatefulWidget {
  @override
  WxHostState createState() => WxHostState();
}

class WxHostState extends State<WxHostPage>
    with SingleTickerProviderStateMixin {
  List<Data> _wxHosts = List<Data>();

  var _scrollController = ScrollController();

  List<Tab> _tabs = List<Tab>();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
    _getHosts();
  }

  void _getHosts() async {
    Response response =
        await Dio().get('https://wanandroid.com/wxarticle/chapters/json');
    var wxHostBean = WxHostBean.fromJson(json.decode(response.toString()));
    _wxHosts.addAll(wxHostBean.data);
    setState(() {
      _tabs.addAll(_wxHosts
          .map((wxHost) => Tab(
                text: wxHost.name,
              ))
          .toList());
      _tabController = TabController(length: _tabs.length, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 30,
          child: TabBar(
            tabs: _tabs,
            isScrollable: true,
            labelColor: Colors.blue,
            indicator: BoxDecoration(),
            unselectedLabelColor: Colors.black,
            controller: _tabController,
          ),
        ),
        Divider(
          height: 0.5,
          color: Color(0x50000000),
        ),
        Expanded(
            child: TabBarView(
                controller: _tabController,
                children: _wxHosts
                    .map((wxHost) => WxArticleListPage(
                          hostId: wxHost.id,
                        ))
                    .toList()))
      ],
    );
  }
}
