import 'package:flutter/material.dart';

class Like extends StatefulWidget {
  @override
  _LikeState createState() => new _LikeState();
}

class _LikeState extends State<Like> {
  double _top = 50.0;
  double _top1 = 100.0;
  double _left = 150.0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('aaa'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: _top,
            left: _left,
            child: GestureDetector(
              child: CircleAvatar(child: Text('Q'),),
              onPanDown: (DragDownDetails e) {
                print('用户手指按下：${e.globalPosition}');
              },
              onPanUpdate: (DragUpdateDetails e) {
                setState(() {
                  _left += e.delta.dx;
                  _top += e.delta.dy;
                });
              },
              onPanEnd: (DragEndDetails e) {
                // setState(() {
                //   _left = 0;
                // });
                print(e.velocity);
              },
            ),
          ),
          Positioned(
            top: _top1,
            child: GestureDetector(
              child: CircleAvatar(child: Text('Z'),),
              onPanDown: (DragDownDetails e) {
                print('用户手指按下：${e.globalPosition}');
              },
              onVerticalDragUpdate: (DragUpdateDetails e) {
                setState(() {
                  _top1 += e.delta.dy;
                });
              },
            ),
          ),
        ],
      )
    ); 
   
  }
}