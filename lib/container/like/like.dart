/*
 * @Author: qiuz
 * @Github: <https://github.com/qiuziz>
 * @Date: 2019-04-23 20:47:53
 * @Last Modified by: qiuz
 * @Last Modified time: 2019-05-23 10:46:12
 */

import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meizi_photo/container/imge-preview/imge-preview.dart';
import 'package:meizi_photo/net/http-utils.dart';
import 'package:meizi_photo/net/resource-api.dart';

class Like extends StatefulWidget {
  const Like({Key key, this.userId}) : super(key: key);
  final userId;
  @override
  _LikeState createState() => new _LikeState();
}

class _LikeState extends State<Like> {
  var _images = [];
  static const loadingTag = "Loading...";
  var _loading = false;
  bool _loadMore = true;
  var imageData = [];
  var _currentIndex = 1;
  int _page = 1;
  
  Image image;
  ScrollController _controller = new ScrollController();
  @override
  void initState() {
    super.initState();
    getLikes(_page);
    _controller.addListener(() {
        double maxScroll = _controller.position.maxScrollExtent;
        double currentScroll = _controller.position.pixels;
        double delta = 400.0;
      if (maxScroll - currentScroll < delta && _loadMore) {
        getLikes(_page);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void getLikes([int page])  {
    if (_loading) {
      return;
    }
    setState(() {
      _loading = true;
    });
    HttpUtil.post(ResourceApi.LIKE_LIST, {'userId': widget.userId, 'page': page.toString()},(result)  async {
      var data = result['data'];
      _images.addAll(data);
      final len = data.length;
      print(data);
      setState(()  {
        _page = ++page;
        _loading = false;
        _loadMore = len < 10 ? false : true;
         _currentIndex = _images.length;
      });
    });
    
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
    print(index);
    print(_currentIndex);
    if (index >= _currentIndex - 1 && _loadMore) {
      return loading();
    }
    if (_images.length <= 0) {
      return null;
    }
    final _src = _images[index]['src'];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          new CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => new ImagePreview(url: _src,),
          ),
        );
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: new ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                      imageUrl: _src,
                      placeholder: (context, url) => loading(),
                      errorWidget: (context, url, error) => new Icon(Icons.error),
                    ),
              ),
          ),
        ),
      ) ;
    // return Image.network(_images[index]['src'], fit: BoxFit.cover);
    // return Image.memory(imageData[index], fit: BoxFit.cover);
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: new ListView.builder(
          itemCount: _images.length == 0 ? 1 : _images.length,
          controller: _controller,
          itemBuilder: (context, index) => itemBuilder(context, index),
          // separatorBuilder: (context, index) => Divider(height: 10.0,),
        ),
      )
    ); 
   
  }
}
