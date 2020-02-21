import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/widgets/navigator_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '玩安卓',
      home: NavigatorBar(),
      theme: ThemeData(
        primaryColor: Colors.white
      ),
    );
  }
}
