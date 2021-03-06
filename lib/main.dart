import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meizi_photo/container/home/home.dart';
import 'package:meizi_photo/container/image-list/image-list.dart';

import 'component/loading/loading.dart';

void main() {
  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
}

Map<String, WidgetBuilder> routes =  {
  '/': (BuildContext context) => Home(),
  '/image-list': (BuildContext context) => ImageList(),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Loading.ctx = context; // 注入context
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.white,
      ),
      routes: routes,
      
    );
  }
}
