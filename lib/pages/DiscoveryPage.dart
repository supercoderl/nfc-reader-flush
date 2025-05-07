import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:barcode_scan2/barcode_scan2.dart';

class DiscoveryPage extends StatelessWidget {
  static const String TAG_START = "startDivider";
  static const String TAG_END = "endDivider";
  static const String TAG_CENTER = "centerDivider";
  static const String TAG_BLANK = "blankDivider";

  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;

  final imagePaths = [
    "images/ic_discover_softwares.png",
    "images/ic_discover_git.png",
    "images/ic_discover_gist.png",
    "images/ic_discover_scan.png",
    "images/ic_discover_shake.png",
    "images/ic_discover_nearby.png",
    "images/ic_discover_pos.png",
  ];
  final titles = ["开源软件", "码云推荐", "代码片段", "扫一扫", "摇一摇", "码云封面人物", "线下活动"];
  final rightArrowIcon = Image.asset(
    'images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );
  static const titleTextStyle = TextStyle(fontSize: 16.0);
  final List listData = [];

  DiscoveryPage({super.key}) {
    initData();
  }

  initData() {
    listData.add(TAG_START);
    for (int i = 0; i < 3; i++) {
      listData.add(ListItem(title: titles[i], icon: imagePaths[i]));
      if (i == 2) {
        listData.add(TAG_END);
      } else {
        listData.add(TAG_CENTER);
      }
    }
    listData.add(TAG_BLANK);
    listData.add(TAG_START);
    for (int i = 3; i < 5; i++) {
      listData.add(ListItem(title: titles[i], icon: imagePaths[i]));
      if (i == 4) {
        listData.add(TAG_END);
      } else {
        listData.add(TAG_CENTER);
      }
    }
    listData.add(TAG_BLANK);
    listData.add(TAG_START);
    for (int i = 5; i < 7; i++) {
      listData.add(ListItem(title: titles[i], icon: imagePaths[i]));
      if (i == 6) {
        listData.add(TAG_END);
      } else {
        listData.add(TAG_CENTER);
      }
    }
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child:
          Image.asset(path, width: IMAGE_ICON_WIDTH, height: IMAGE_ICON_WIDTH),
    );
  }

  renderRow(BuildContext ctx, int i) {
    var item = listData[i];
    if (item is String) {
      switch (item) {
        case TAG_START:
          return const Divider(
            height: 1.0,
          );
        case TAG_END:
          return const Divider(
            height: 1.0,
          );
        case TAG_CENTER:
          return const Padding(
            padding: EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
            child: Divider(
              height: 1.0,
            ),
          );
        case TAG_BLANK:
          return Container(
            height: 20.0,
          );
      }
    } else if (item is ListItem) {
      var listItemContent = Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Row(
          children: <Widget>[
            getIconImage(item.icon),
            Expanded(
                child: Text(
              item.title,
              style: titleTextStyle,
            )),
            rightArrowIcon
          ],
        ),
      );
      return InkWell(
        onTap: () {
          handleListItemClick(ctx, item);
        },
        child: listItemContent,
      );
    }
  }

  void handleListItemClick(BuildContext ctx, ListItem item) {
    
  }

  Future scan() async {
    try {
      ScanResult? barcode = await BarcodeScanner.scan();
      if (kDebugMode) {
        print(barcode);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, i) => renderRow(context, i),
      ),
    );
  }
}

class ListItem {
  String icon;
  String title;
  ListItem({required this.icon, required this.title});
}
