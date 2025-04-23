import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../api/Fire.dart';
import '../util/NetUtils.dart';
import '../pages/CommonWebPage.dart';

// 线下活动
class OfflineActivityPage extends StatefulWidget {
  const OfflineActivityPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return OfflineActivityPageState();
  }
}

class OfflineActivityPageState extends State<OfflineActivityPage> {
  String eventTypeLatest = "latest";
  String eventTypeYch = "ych";
  String eventTypeRec = "recommend";
  int curPage = 1;

  TextStyle titleTextStyle =
      const TextStyle(color: Colors.black, fontSize: 18.0);

  late List recData, latestData, ychData;

  @override
  void initState() {
    super.initState();
    getData(eventTypeRec);
    getData(eventTypeLatest);
    getData(eventTypeYch);
  }

  void getData(String type) {
    String url = Api.EVENT_LIST;
    url += "$type?pageIndex=$curPage&pageSize=5";
    NetUtils.get(url).then((data) {
      if (data != null) {
        var obj = json.decode(data);
        if (obj != null && obj['code'] == 0) {
          if (kDebugMode) {
            print(obj);
          }
          setState(() {
            if (type == eventTypeRec) {
              recData = obj['msg'];
            } else if (type == eventTypeLatest) {
              latestData = obj['msg'];
            } else {
              ychData = obj['msg'];
            }
          });
        }
      }
    });
  }

  Widget getRecBody() {
    if (recData.isEmpty) {
      return const Center(child: Text("暂无数据"));
    } else {
      return ListView.builder(
          itemBuilder: _renderRecRow, itemCount: recData.length);
    }
  }

  Widget getLatestBody() {
    if (latestData.isEmpty) {
      return const Center(child: Text("暂无数据"));
    } else {
      return ListView.builder(
          itemBuilder: _renderLatestRow, itemCount: latestData.length);
    }
  }

  Widget getYchBody() {
    if (ychData.isEmpty) {
      return const Center(child: Text("暂无数据"));
    } else {
      return ListView.builder(
          itemBuilder: _renderYchRow, itemCount: ychData.length);
    }
  }

  Widget getCard(itemData) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.network(
            itemData['cover'],
            fit: BoxFit.cover,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            alignment: Alignment.centerLeft,
            child: Text(
              itemData['title'],
              style: titleTextStyle,
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(itemData['authorName']),
                  ),
                  Text(itemData['timeStr'])
                ],
              ))
        ],
      ),
    );
  }

  Widget _renderRecRow(BuildContext ctx, int i) {
    Map itemData = recData[i];
    return InkWell(
      child: getCard(itemData),
      onTap: () {
        _showDetail(itemData['detailUrl']);
      },
    );
  }

  Widget _renderLatestRow(BuildContext ctx, int i) {
    Map itemData = latestData[i];
    return InkWell(
      child: getCard(itemData),
      onTap: () {
        _showDetail(itemData['detailUrl']);
      },
    );
  }

  Widget _renderYchRow(BuildContext ctx, int i) {
    Map itemData = ychData[i];
    return InkWell(
      child: getCard(itemData),
      onTap: () {
        _showDetail(itemData['detailUrl']);
      },
    );
  }

  _showDetail(detailUrl) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return CommonWebPage(
        title: '活动详情',
        url: detailUrl,
        key: const ValueKey('web-page-活动详情'),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("线下活动", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: const TabBar(
              tabs: <Widget>[
                Tab(
                  text: "强力推荐",
                ),
                Tab(
                  text: "最新活动",
                ),
                Tab(
                  text: "源创会",
                )
              ],
            ),
            body: TabBarView(
              children: <Widget>[getRecBody(), getLatestBody(), getYchBody()],
            )),
      ),
    );
  }
}
