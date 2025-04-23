import 'package:flutter/material.dart';
import '../pages/AboutPage.dart';
import '../pages/BlackHousePage.dart';
import '../pages/PublishTweetPage.dart';
import '../pages/SettingsPage.dart';

class Drawer extends StatelessWidget {
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;
  final rightArrowIcon = Image.asset(
    'images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );
  final List menuTitles = ['发布动弹', '动弹小黑屋', '关于', '设置'];
  final List menuIcons = [
    './images/leftmenu/ic_fabu.png',
    './images/leftmenu/ic_xiaoheiwu.png',
    './images/leftmenu/ic_about.png',
    './images/leftmenu/ic_settings.png'
  ];
  final TextStyle menuStyle = const TextStyle(
    fontSize: 15.0,
  );

  Drawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(width: 304.0),
      child: Material(
        elevation: 16.0,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
          ),
          child: ListView.builder(
            itemCount: menuTitles.length * 2 + 1,
            itemBuilder: renderRow,
          ),
        ),
      ),
    );
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 6.0, 0.0),
      child: Image.asset(path, width: 28.0, height: 28.0),
    );
  }

  Widget renderRow(BuildContext context, int index) {
    if (index == 0) {
      // render cover image
      var img = Image.asset(
        './images/cover_img.jpg',
        width: 304.0,
        height: 304.0,
      );
      return Container(
        width: 304.0,
        height: 304.0,
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: img,
      );
    }
    index -= 1;
    if (index.isOdd) {
      return const Divider();
    }
    index = index ~/ 2;

    var listItemContent = Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      child: Row(
        children: <Widget>[
          getIconImage(menuIcons[index]),
          Expanded(
              child: Text(
            menuTitles[index],
            style: menuStyle,
          )),
          rightArrowIcon
        ],
      ),
    );

    return InkWell(
      child: listItemContent,
      onTap: () {
        switch (index) {
          case 0:
            // 发布动弹
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return PublishTweetPage();
            }));
            break;
          case 1:
            // 小黑屋
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return BlackHousePage();
            }));
            break;
          case 2:
            // 关于
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return AboutPage();
            }));
            break;
          case 3:
            // 设置
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return SettingsPage();
            }));
            break;
        }
      },
    );
  }
}
