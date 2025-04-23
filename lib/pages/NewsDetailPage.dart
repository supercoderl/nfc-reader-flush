import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NewsDetailPage extends StatefulWidget {
  final String id;

  const NewsDetailPage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() =>
      NewsDetailPageState(id: id, key: ValueKey('web-page-$id'));
}

class NewsDetailPageState extends State<NewsDetailPage> {
  String id;
  bool loaded = false;
  late String detailDataStr;
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  NewsDetailPageState({required Key key, required this.id});

  @override
  void initState() {
    super.initState();
    // 监听WebView的加载事件
    flutterWebViewPlugin.onStateChanged.listen((state) {
      if (kDebugMode) {
        print("state: ${state.type}");
      }
      if (state.type == WebViewState.finishLoad) {
        // 加载完成
        setState(() {
          loaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = [];
    titleContent.add(const Text(
      "资讯详情",
      style: TextStyle(color: Colors.white),
    ));
    if (!loaded) {
      titleContent.add(const CupertinoActivityIndicator());
    }
    titleContent.add(Container(width: 50.0));
    return WebviewScaffold(
      url: id,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: titleContent,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    );
  }
}
