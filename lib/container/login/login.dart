/*
 * @Author: qiuz
 * @Github: <https://github.com/qiuziz>
 * @Date: 2019-05-23 10:47:44
 * @Last Modified by: qiuz
 * @Last Modified time: 2019-05-23 10:56:53
 */

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meizi_photo/net/http-utils.dart';
import 'package:meizi_photo/net/resource-api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  FocusScopeNode focusScopeNode;

  @override
  void initState() {
    super.initState();
    _usernameController.text = 'Hello Qiuz';
    _usernameController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _usernameController.text.length
    );
    _usernameController.addListener(() {
      print(_usernameController.text);
    });
  }

  void save(Map<String, dynamic> userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userInfo', json.encode(userInfo));
  }

  void login() {
    focusNode1.unfocus();
    focusNode2.unfocus();
    HttpUtil.post(ResourceApi.LOGIN, {'username': _usernameController.text, 'password': _pwdController.text}, (result)  async {
      var data = result['data'];
      save(data);
      Navigator.pop(context);
    }, errorCallback: (error) {
      print(error);
      Fluttertoast.showToast(
        msg: error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              Container(
                child: TextFormField(
                  controller: _usernameController,
                  autofocus: true,
                  focusNode: focusNode1,
                  decoration: InputDecoration(
                    labelText: '用户名',
                    hintText: '用户名或邮箱',
                    prefixIcon: Icon(Icons.person),
                    border: InputBorder.none
                  ),
                  validator: (v) {
                    return v
                      .trim()
                      .length > 0 ? null : '用户名不能为空';
                  },
                ),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[200], width: 1.0))
                ),
              ),
              
              TextFormField(
                controller: _pwdController,
                focusNode: focusNode2,
                decoration: InputDecoration(
                  labelText: '密码',
                  hintText: '您的登录密码',
                  prefixIcon: Icon(Icons.lock)
                ),
                obscureText: true,
                validator: (v) {
                  return v.trim().length > 5 ? null : '密码不能少于6位';
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        child: Text('登录'),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.blue,
                        onPressed: login,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      
    );
  }
}

