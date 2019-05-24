/*
 * @Author: qiuz
 * @Github: <https://github.com/qiuziz>
 * @Date: 2019-04-23 20:47:53
 * @Last Modified by: qiuz
 * @Last Modified time: 2019-04-25 14:41:41
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// class ImagePreview extends StatefulWidget {
//   final String src;
//   ImagePreview({Key key, @required this.src}) : super(key: key);
//   @override
//   _ImagePreviewState createState() => new _ImagePreviewState();
// }

// class _ImagePreviewState extends State<ImagePreview>  {
//   double _width = window.physicalSize.width;


//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: AppBar(
//         toolbarOpacity: .5,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: Center(
//         child: SafeArea(
//           child: GestureDetector(
//             child: Image.network(widget.src, width: _width,),
//             onScaleUpdate: (ScaleUpdateDetails e) {
//               setState(() {
//                 _width = window.physicalSize.width*e.scale.clamp(.8, 10.0);
//               });
//             },
//           ),
//         )
//       ),
//     ); 
   
//   }
// }


class ImagePreview extends StatefulWidget {
  const ImagePreview({Key key, this.url}) : super(key: key);
  final url;
  @override
  State<StatefulWidget> createState() {
    return ImagePreviewState();
  }
}

class ImagePreviewState extends State<ImagePreview> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;
  double _kMinFlingVelocity = 600.0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      setState(() {
        _offset = _animation.value;
      });
    });
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    // widget的屏幕宽度
    final Offset minOffset = Offset(size.width, size.height) * (1.0 - _scale);
    // 限制他的最小尺寸
    return Offset(
        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
    
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // 计算图片放大后的位置
      _controller.stop();
    });
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 3.0);
      // 限制放大倍数 1~3倍
      // print(details.focalPoint);
      print(details.focalPoint - _normalizedOffset * _scale);
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
      // 更新当前位置
    });
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity) return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    // 计算当前的方向
    final double distance = (Offset.zero & context.size).shortestSide;
    // 计算放大倍速，并相应的放大宽和高，比如原来是600*480的图片，放大后倍数为1.25倍时，宽和高是同时变化的
    _animation = _controller.drive(Tween<Offset>(
        begin: _offset, end: _clampOffset(_offset + direction * distance)));
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  void _back() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        decoration: BoxDecoration(color: Colors.black),
        height: window.physicalSize.height,
          child: GestureDetector(
            onScaleStart: _handleOnScaleStart,
            onScaleUpdate: _handleOnScaleUpdate,
            onScaleEnd: _handleOnScaleEnd,
            onTap: _back,
            onDoubleTap: () {
                setState(() {
                   _scale =  _scale * 2;
                   _offset = _clampOffset(Offset(80, 80));
                });
            },
            child: ClipRect(
              child: Transform(
                transform: Matrix4.identity()..translate(_offset.dx, _offset.dy)
                  ..scale(_scale),
                  child: Image.network(widget.url,),
              ),
              // child: Image.network(widget.url,fit: BoxFit.cover,),
            ),
          )
      );
  }
}
