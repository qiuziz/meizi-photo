/*
 * @Author: qiuz
 * @Github: <https://github.com/qiuziz>
 * @Date: 2019-04-23 20:47:53
 * @Last Modified by: qiuz
 * @Last Modified time: 2019-04-25 14:41:41
 */

import 'dart:ui';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final String src;
  
  ImagePreview({Key key, @required this.src}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        toolbarOpacity: .5,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: <Widget>[
          Image.network(src),
        ],
      ),
    ); 
   
  }
}
