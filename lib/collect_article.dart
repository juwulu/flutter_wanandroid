import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_wanandroid/bean/favorite_bean.dart';
import 'package:path_provider/path_provider.dart';

class CollectUtil {
  static void collect(int articleId, CollectCallback call) async {
    Dio dio = Dio();
    Directory directory = await getApplicationDocumentsDirectory();
    dio.interceptors.add(CookieManager(PersistCookieJar(dir: directory.path)));
    Response response =
        await dio.post('https://www.wanandroid.com/lg/collect/$articleId/json');
    var collectBean = CollectBean.fromJson(json.decode(response.toString()));
    call(collectBean.errorCode == 0);
  }
}

typedef void CollectCallback(bool isSuccess);
