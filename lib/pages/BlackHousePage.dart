import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/Fire.dart';
import '../constants/Constants.dart';
import '../events/LoginEvent.dart';
import '../util/BlackListUtils.dart';
import '../util/NetUtils.dart';
import 'dart:convert';
import '../pages/LoginPage.dart';
import '../util/Utf8Utils.dart';

class BlackHousePage extends StatefulWidget {
  const BlackHousePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return BlackHousePageState();
  }
}

class BlackHousePageState extends State<BlackHousePage> {
  bool isLogin = true;
  late List blackDataList;
  TextStyle btnStyle = const TextStyle(color: Colors.white, fontSize: 12.0);

  BlackHousePageState() {
    queryBlackList();
  }

  queryBlackList() {
   
  }

  // 获取用户信息
  getUserInfo() async {
  }

  // 从黑名单中删除
  deleteFromBlack(authorId) {
  }

  showResultDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('提示'),
            content: Text(msg),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  '确定',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  showSetFreeDialog(item) {
    String? name = Utf8Utils.decode(item['authorname']);
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('提示'),
            content: Text('确定要把\"$name\"放出小黑屋吗？'),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  '确定',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  deleteFromBlack(item['authorid']);
                },
              )
            ],
          );
        });
  }

  Widget getBody() {
    if (!isLogin) {
      return Center(
        child: InkWell(
          child: Container(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
            child: const Text("去登录"),
          ),
          onTap: () async {
            final result = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return LoginPage();
            }));
            if (result != null && result == "refresh") {
              // 通知动弹页面刷新
              Constants.eventBus.fire(LoginEvent());
              getUserInfo();
            }
          },
        ),
      );
    }
    if (blackDataList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("小黑屋中没人..."), Text("长按动弹列表即可往小黑屋中加人")],
        ),
      );
    }
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(blackDataList.length, (index) {
        String? name = Utf8Utils.decode(blackDataList[index]['authorname']);
        return Container(
          margin: const EdgeInsets.all(2.0),
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 45.0,
                height: 45.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  image: DecorationImage(
                      image: NetworkImage(
                          "${blackDataList[index]['authoravatar']}"),
                      fit: BoxFit.cover),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                child: Text(name ?? "",
                    style: const TextStyle(color: Colors.white)),
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8.0, 5.0, 5.0, 8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0))),
                  child: Text(
                    "放我出去",
                    style: btnStyle,
                  ),
                ),
                onTap: () {
                  showSetFreeDialog(blackDataList[index]);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("动弹小黑屋", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 0.0),
        child: getBody(),
      ),
    );
  }
}
