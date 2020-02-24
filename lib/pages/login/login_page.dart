import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/bean/login_bean.dart';
import 'package:flutter_wanandroid/data_manager.dart';
import 'package:flutter_wanandroid/pages/my_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bean/login_bean.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  TextEditingController _userController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户登录'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 36),
            child: Center(
              child: Icon(
                Icons.android,
                size: 80,
                color: Colors.blue,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 30),
            child: TextField(
              controller: _userController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: '用户名',
                  hintText: '请输入用户名',
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue))),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: TextField(
              controller: _pwdController,
              obscureText: true,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: '密码',
                  hintText: '请输入密码',
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue))),
            ),
          ),
          Container(
            height: 75,
            padding: EdgeInsets.only(left: 30, right: 30, top: 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(37.5),
              child: RaisedButton(
                onPressed: _login,
                color: Colors.blue,
                child: Text(
                  '登录',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 10),
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: _goRegister,
              child: Text(
                '注册账号',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _login() async {
    print(_userController.text);
    print(_pwdController.text);
    FormData formData = new FormData.fromMap({
      "username": _userController.text.trim(),
      "password": _pwdController.text.trim(),
    });
    Dio dio = Dio();
    var directory = await getApplicationDocumentsDirectory();
    dio.interceptors.add(CookieManager(PersistCookieJar(dir: directory.path)));
    Response response =
        await dio.post('https://www.wanandroid.com/user/login', data: formData);
    var loginBean = LoginBean.fromJson(json.decode(response.toString()));
    print(response.toString());
    updateLoginState(loginBean);
  }

  void _goRegister() {}

  void updateLoginState(LoginBean loginBean) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('isLogin', loginBean.errorCode == 0);
    sharedPreferences.setString('nickname', loginBean.data.nickname);
    sharedPreferences.setInt('id', loginBean.data.id);
    LoginStateManager.isLogin = true;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => MyPage()));
  }
}
