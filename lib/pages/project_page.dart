import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/bean/project_type_bean.dart';
import 'package:flutter_wanandroid/pages/home/project_list_item.dart';

class ProjectPage extends StatefulWidget {
  @override
  ProjectPageState createState() => ProjectPageState();
}

class ProjectPageState extends State<ProjectPage> {
  List<Data> _projectTypes = List<Data>();

  @override
  void initState() {
    super.initState();
    _getProjectTypes();
  }

  void _getProjectTypes() async {
    Response response =
        await Dio().get('https://www.wanandroid.com/project/tree/json');
    var articleBean =
        ProjectTypeBean.fromJson(json.decode(response.toString()));
    setState(() {
      _projectTypes.addAll(articleBean.data);
    });
  }

  Color _getRandomColor() => Color.fromARGB(255, Random.secure().nextInt(255),
      Random.secure().nextInt(255), Random.secure().nextInt(255));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: _projectTypes
            .map((projectType) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProjectListPage(
                                  id: projectType.id,
                                  title: projectType.name,
                                )));
                  },
                  child: Card(
                    color: _getRandomColor(),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        projectType.name,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
