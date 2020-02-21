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

  List<Tab> _tabs = List<Tab>();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
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
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _tabs.length == 0
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: <Widget>[
              Container(
                child: TabBar(
                  tabs: _tabs,
                  isScrollable: true,
                  labelColor: Colors.blue,
                  indicator: BoxDecoration(),
                  unselectedLabelStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  labelStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
