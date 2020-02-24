import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/bean/coin_bean.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  String _nickname = '未知昵称';

  int _coinCount = 0;

  int _level = 1;

  int _rank = -1;

  @override
  void initState() {
    super.initState();
    _loadLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('个人中心'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
                onPressed: _logout)
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10)),
            Center(
              child: Container(
                height: 100,
                width: 100,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Center(
              child: Text(_nickname),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              margin: EdgeInsets.all(10),
              child: Card(
                color: Colors.blueAccent,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Container(
                      height: 80,
                      width: 100,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Text(
                            '我的收藏',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                  color: Colors.red,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 100,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          child: Text(
                            '我的积分',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          left: 10,
                          top: 8,
                        ),
                        Center(
                            child: Text(
                          '$_coinCount',
                          style: TextStyle(color: Colors.green, fontSize: 30),
                        ))
                      ],
                    ),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Card(
                  color: Colors.deepPurpleAccent,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 100,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          child: Text(
                            '我的等级',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          left: 10,
                          top: 8,
                        ),
                        Center(
                            child: Text(
                          'Lv$_level',
                          style: TextStyle(color: Colors.green, fontSize: 25),
                        ))
                      ],
                    ),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Card(
                  color: Colors.orange,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 100,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          child: Text(
                            '我的排行',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          left: 10,
                          top: 8,
                        ),
                        Center(
                            child: Text(
                          '第$_rank名',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ))
                      ],
                    ),
                  )),
            )
          ],
        ));
  }

  void _loadLoginInfo() async {
    Dio dio = Dio();
    var directory = await getApplicationDocumentsDirectory();
    dio.interceptors.add(CookieManager(PersistCookieJar(dir: directory.path)));
    Response response =
        await dio.get('https://www.wanandroid.com/lg/coin/userinfo/json');
    var coinBean = CoinBean.fromJson(json.decode(response.toString()));
    if (coinBean.errorCode == 0) {
      var data = coinBean.data;
      setState(() {
        _coinCount = data.coinCount;
        _rank = data.rank;
        _level = data.level;
      });
    }
    SharedPreferences sps = await SharedPreferences.getInstance();
    setState(() {
      _nickname = sps.getString('nickname');
    });
  }

  void _logout() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('isLogin', false);
    Navigator.pop(context);
  }
}
