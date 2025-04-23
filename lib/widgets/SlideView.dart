import 'package:flutter/material.dart';
import '../pages/NewsDetailPage.dart';

class SlideView extends StatefulWidget {
  final data;

  const SlideView(this.data, {super.key});

  @override
  State<StatefulWidget> createState() {
    return SlideViewState(data);
  }
}

class SlideViewState extends State<SlideView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late List slideData;

  SlideViewState(data) {
    slideData = data;
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: slideData.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget generateCard() {
    return Card(
      color: Colors.blue,
      child: Image.asset(
        "images/ic_avatar_default.png",
        width: 20.0,
        height: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    if (slideData.isNotEmpty) {
      for (var i = 0; i < slideData.length; i++) {
        var item = slideData[i];
        var imgUrl = item['imgUrl'];
        var title = item['title'];
        var detailUrl = item['detailUrl'];
        items.add(GestureDetector(
          onTap: () {
            // 点击跳转到详情
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => NewsDetailPage(id: detailUrl)));
          },
          child: Stack(
            children: <Widget>[
              Image.network(imgUrl),
              Container(
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0x50000000),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(title,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15.0)),
                  ))
            ],
          ),
        ));
      }
    }
    return TabBarView(
      controller: tabController,
      children: items,
    );
  }
}
