import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/project_page.dart';
import 'package:flutter_wanandroid/pages/home_page.dart';
import 'package:flutter_wanandroid/pages/my_page.dart';
import 'package:flutter_wanandroid/pages/category_page.dart';
import 'package:flutter_wanandroid/widgets/search/search_view.dart';

class NavigatorBar extends StatefulWidget {
  @override
  NavigatorState createState() => NavigatorState();
}

class NavigatorState extends State<NavigatorBar> {
  static const titles = ['首页', '分类', '项目', '我的'];

  var _currentIndex = 0;

  var _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('玩Android'),
          elevation: 0,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: SearchBarDelegate());
                })
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: <Widget>[
            HomePage(),
            NavigatorPage(),
            ProjectPage(),
            MyPage()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _pageController.jumpToPage(index);
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(Icons.home, color: Colors.blue),
                  title: Text(
                    titles[0],
                    style: TextStyle(
                        color: _currentIndex == 0 ? Colors.blue : Colors.black),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.navigation,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(Icons.navigation, color: Colors.blue),
                  title: Text(
                    titles[1],
                    style: TextStyle(
                        color: _currentIndex == 1 ? Colors.blue : Colors.black),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.category,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(Icons.category, color: Colors.blue),
                  title: Text(
                    titles[2],
                    style: TextStyle(
                        color: _currentIndex == 2 ? Colors.blue : Colors.black),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(Icons.account_circle, color: Colors.blue),
                  title: Text(
                    titles[3],
                    style: TextStyle(
                        color: _currentIndex == 3 ? Colors.blue : Colors.black),
                  ))
            ]));
  }
}