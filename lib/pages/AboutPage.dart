import 'package:flutter/material.dart';
import 'CommonWebPage.dart';

// "关于"页面

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return AboutPageState();
  }
}

class AboutPageState extends State<AboutPage> {
  bool showImage = false;
  TextStyle textStyle = TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.combine([TextDecoration.underline]));
  late Widget authorLink, mayunLink, githubLink;
  List<String> urls = List<String>.empty(growable: true);
  List<String> titles = List<String>.empty(growable: true);

  AboutPageState() {
    titles.add("yubo's blog");
    titles.add("码云");
    titles.add("GitHub");
    urls.add("https://yubo725.top");
    urls.add("https://gitee.com/yubo725");
    urls.add("https://github.com/yubo725");
    authorLink = GestureDetector(
      onTap: getLink(0),
      child: Container(
        margin: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("作者："),
            Text(
              "yubo",
              style: textStyle,
            ),
          ],
        ),
      ),
    );
    mayunLink = GestureDetector(
      onTap: getLink(1),
      child: Container(
        margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("码云："),
            Text(
              "https://gitee.com/yubo725",
              style: textStyle,
            )
          ],
        ),
      ),
    );
    githubLink = GestureDetector(
      onTap: getLink(2),
      child: Container(
        margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("GitHub："),
            Text(
              "https://github.com/yubo725",
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }

  getLink(index) {
    String url = urls[index];
    String title = titles[index];
    return () {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return CommonWebPage(
          title: title,
          url: url,
          key: ValueKey('web-page-$title'),
        );
      }));
    };
  }

  Widget getImageOrBtn() {
    if (!showImage) {
      return Center(
        child: InkWell(
          child: Container(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
            child: const Text("不要点我"),
          ),
          onTap: () {
            setState(() {
              showImage = true;
            });
          },
        ),
      );
    } else {
      return Image.asset(
        './images/ic_hongshu.jpg',
        width: 100.0,
        height: 100.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("关于", style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                width: 1.0,
                height: 100.0,
                color: Colors.transparent,
              ),
              Image.asset(
                './images/ic_osc_logo.png',
                width: 200.0,
                height: 56.0,
              ),
              const Text("基于Google Flutter的开源中国客户端"),
              authorLink,
              mayunLink,
              githubLink,
              Expanded(flex: 1, child: getImageOrBtn()),
              Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                  child: const Text(
                    "本项目仅供学习使用，与开源中国官方无关",
                    style: TextStyle(fontSize: 12.0),
                  ))
            ],
          ),
        ));
  }
}
