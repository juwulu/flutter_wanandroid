import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/collect_article.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Browser extends StatefulWidget {
  final String url;
  final String title;
  final int id;
  final bool isCollected;

  const Browser({Key key, this.id, this.url, this.title, this.isCollected})
      : super(key: key);

  @override
  BrowserState createState() => BrowserState(id, url, title, isCollected);
}

class BrowserState extends State<Browser> {
  int id;
  String url;
  String title;
  bool isCollected;
  bool isPageFinished = false;

  BrowserState(this.id, this.url, this.title, this.isCollected);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: isPageFinished
          ? WebView(
              onPageFinished: (url) {
                setState(() {
                  isPageFinished = true;
                });
              },
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CollectUtil.collect(id, _collectCallback);
        },
        child: isCollected
            ? Icon(
                Icons.favorite,
                color: Colors.red,
              )
            : Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
      ),
    );
  }

  void _collectCallback(bool isSuccess) {
    if (isSuccess) {
      setState(() {
        isCollected = !isCollected;
      });
    }
    _showToast(isSuccess);
  }

  void _showToast(bool isSuccess) {
    String msg = isCollected ? '收藏' : '取消收藏';
    Fluttertoast.showToast(
        msg: '$msg${isSuccess ? '成功' : '失败'}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
