import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/widgets/browser.dart';

class MyPage extends StatefulWidget {
  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('我的Github主页'),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => Browser(
                        url: 'https://github.com/juwulu',
                        title: 'Github主页',
                      )));
        },
      ),
    );
  }
}
