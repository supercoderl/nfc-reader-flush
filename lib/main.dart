import 'package:flutter/material.dart';
import 'package:nfc_reader_flush/pages/SplashPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyOSCClient());
}

class MyOSCClient extends StatefulWidget {
  const MyOSCClient({super.key});

  @override
  State<StatefulWidget> createState() => MyOSCClientState();
}

class MyOSCClientState extends State<MyOSCClient> {
  // int _tabIndex = 0;
  // final tabTextStyleNormal = const TextStyle(color: Color(0xff969696));
  // final tabTextStyleSelected = const TextStyle(color:  Color(0xff63ca6c));

  // var tabImages;
  // var _body;
  // var appBarTitles = ['资讯', '动弹', '发现', '我的'];

  // Image getTabImage(path) {
  //   return Image.asset(path, width: 20.0, height: 20.0);
  // }

  // void initData() {
  //   tabImages ??= [
  //       [
  //         getTabImage('images/ic_nav_news_normal.png'),
  //         getTabImage('images/ic_nav_news_actived.png')
  //       ],
  //       [
  //         getTabImage('images/ic_nav_tweet_normal.png'),
  //         getTabImage('images/ic_nav_tweet_actived.png')
  //       ],
  //       [
  //         getTabImage('images/ic_nav_discover_normal.png'),
  //         getTabImage('images/ic_nav_discover_actived.png')
  //       ],
  //       [
  //         getTabImage('images/ic_nav_my_normal.png'),
  //         getTabImage('images/ic_nav_my_pressed.png')
  //       ]
  //     ];
  //   _body = IndexedStack(
  //     index: _tabIndex,
  //     children: <Widget>[
  //       NewsListPage(),
  //       TweetsListPage(),
  //       DiscoveryPage(),
  //       const InfoPage()
  //     ],
  //   );
  // }

  // TextStyle getTabTextStyle(int curIndex) {
  //   if (curIndex == _tabIndex) {
  //     return tabTextStyleSelected;
  //   }
  //   return tabTextStyleNormal;
  // }

  // Image getTabIcon(int curIndex) {
  //   if (curIndex == _tabIndex) {
  //     return tabImages[curIndex][1];
  //   }
  //   return tabImages[curIndex][0];
  // }

  // Text getTabTitle(int curIndex) {
  //   return Text(appBarTitles[curIndex], style: getTabTextStyle(curIndex));
  // }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: SplashPage());
  }
}
