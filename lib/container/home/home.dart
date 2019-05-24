/*
 * @Author: qiuz
 * @Github: <https://github.com/qiuziz>
 * @Date: 2019-04-23 20:47:53
 * @Last Modified by: qiuz
 * @Last Modified time: 2019-04-25 14:41:41
 */

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meizi_photo/container/image-list/image-list.dart';
import 'package:meizi_photo/container/like/like.dart';
import 'package:meizi_photo/container/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  var _currentIndex = 0;
  String userId;
  List<Widget> pages = List<Widget>();
  @override
  void initState() {
    super.initState();
    pages
      ..add(ImageList());
  
    isLogin();
    
  }

  void isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userInfoStr = prefs.get('userInfo');
    Map<String, dynamic> userInfo = null != userInfoStr ? json.decode(userInfoStr) : {};
    if (null != userInfo['userId']) {
      userId = userInfo['userId'];
      pages..add(Like(userId: userInfo['userId'],));
    }
  }

  void changeTab(int index) {
    if (index == 1 && null == userId) {
      Navigator.push(
          context,
          new CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => new Login(),
          ),
        );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        iconSize: 25.0,
        // color: Colors.white,
        // shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
        items: [
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe66d, fontFamily: 'mz-iconfont')),
            title: Text('首页')
          ),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe641, fontFamily: 'mz-iconfont')),
            title: Text('收藏')
          )
        ],
        currentIndex: _currentIndex,
        onTap: changeTab,
        activeColor: Color.fromARGB(255, 215, 10, 57),
        //  type: BottomNavigationBarType.shifting,
        // child: Row(
        //   children: [
            
        //     SizedBox(), //中间位置空出
        //     Padding(
        //       padding: const EdgeInsets.all(10.0),
        //       child: Icon(IconData(0xe641, fontFamily: 'mz-iconfont'), color: Color(0x142142142), size: 30.0,),
        //     ),
        //   ],
        //   mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
        // )
      ),
      body: IndexedStack(
              index: _currentIndex,
              children: pages,
            )
    ); 
   
  }
}
