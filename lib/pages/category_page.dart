import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/bean/category_bean.dart';
import 'package:flutter_wanandroid/pages/home/category_list_item.dart';

class NavigatorPage extends StatefulWidget {
  @override
  NavigatorPageState createState() => NavigatorPageState();
}

class NavigatorPageState extends State<NavigatorPage> {
  List<Data> _categories = List<Data>();

  @override
  void initState() {
    super.initState();
    _getBannerData();
  }

  void _getBannerData() async {
    Response response = await Dio().get('https://www.wanandroid.com/tree/json');
    var categoryBean = CategoryBean.fromJson(json.decode(response.toString()));
    setState(() {
      _categories.addAll(categoryBean.data);
      print(_categories.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => ExpansionTile(
        title: Text(_categories[index].name),
        children: [
          Container(
            child: Wrap(
              spacing: 5,
              children: _categories[index]
                  .children
                  .map((child) => ActionChip(
                        label: Text(child.name),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CategoryListPage(
                                        id: child.id,
                                        title: child.name,
                                      )));
                        },
                      ))
                  .toList(),
            ),
          )
        ],
      ),
      itemCount: _categories.length,
    );
  }
}
