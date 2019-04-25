/*
 * @Author: qiuz
 * @Github: <https://github.com/qiuziz>
 * @Date: 2019-04-23 20:47:53
 * @Last Modified by: qiuz
 * @Last Modified time: 2019-04-25 14:41:41
 */

import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meizi_photo/net/http-utils.dart';
import 'package:meizi_photo/net/resource-api.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  var _images = [];
  static const loadingTag = "Loading...";
  var _loading = false;
  var imageData = [];
  var _currentIndex = 1;
  int _page = 1;
  Image image;
  ScrollController _controller = new ScrollController();
  @override
  void initState() {
    super.initState();
    getImages(_page);
    _controller.addListener(() {
        double maxScroll = _controller.position.maxScrollExtent;
        double currentScroll = _controller.position.pixels;
        double delta = 400.0; // or something else..
      if (maxScroll - currentScroll < delta) {
        getImages(_page);
      }
    });

   
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void getImages([int page])  {
    print(window.physicalSize);
    print(page);
    if (_loading) {
      return;
    }
    setState(() {
      _loading = true;
    });
    Map<String, String> queryParams = {'page': page.toString()};
    HttpUtil.get(ResourceApi.IMAGES, (result)  async {
      print(333);
      var data = result['data'];
      _images.addAll(data);
      // final len = data.length;
      // for (int i = 0; i < len; i++) {
      //   // final res = await http.get(data[i]['src']);
      //   _images.add(data[i]);
      //   if (i >= len - 1) {
      //   setState(() {});
      //   }
      // }
      setState(()  {
        _page = ++page;
        _loading = false;
         _currentIndex = _images.length;
      });
    }, params: queryParams);
    
  }

  Widget loading() {
    return Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: SizedBox(
          width: 24.0,
          height: 24.0,
          child: CircularProgressIndicator(strokeWidth: 2.0,),
        ),
      );
  }

  Widget itemBuilder(BuildContext context, int index) {
    print('_currentIndex $_currentIndex index $index');
    if (index >= _currentIndex - 1) {
      return loading();
    }
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: new ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                    imageUrl: _images[index]['src'],
                    placeholder: (context, url) => loading(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
            ),
        ),
      );
    // return Image.network(_images[index]['src'], fit: BoxFit.cover);
    // return Image.memory(imageData[index], fit: BoxFit.cover);
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar:  BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.home), onPressed: () {},),
            SizedBox(), //中间位置空出
            IconButton(icon: Icon(Icons.business), onPressed: () {},),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
        )
      ),
      body: new ListView.builder(
        itemCount: _images.length == 0 ? 1 : _images.length,
        controller: _controller,
        itemBuilder: (context, index) => itemBuilder(context, index),
        // separatorBuilder: (context, index) => Divider(height: 10.0,),
      ),
    ); 
   
  }
}
