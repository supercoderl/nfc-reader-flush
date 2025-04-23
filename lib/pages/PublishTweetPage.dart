import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../api/Fire.dart';
import '../util/DataUtils.dart';
import 'package:image_picker/image_picker.dart';

class PublishTweetPage extends StatefulWidget {
  const PublishTweetPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return PublishTweetPageState();
  }
}

class PublishTweetPageState extends State<PublishTweetPage> {
  final TextEditingController _controller = TextEditingController();
  List<File> fileList = <File>[];
  late Future<XFile?> _imageFile;
  bool isLoading = false;
  String msg = "";

  Widget getBody() {
    var textField = TextField(
      decoration: const InputDecoration(
          hintText: "说点什么吧～",
          hintStyle: TextStyle(color: Color(0xFF808080)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)))),
      maxLines: 6,
      maxLength: 150,
      controller: _controller,
    );
    var gridView = Builder(
      builder: (ctx) {
        return GridView.count(
          crossAxisCount: 4,
          children: List.generate(fileList.length + 1, (index) {
            Widget content;
            if (index == 0) {
              // 添加图片按钮
              var addCell = Center(
                  child: Image.asset(
                './images/ic_add_pics.png',
                width: 80.0,
                height: 80.0,
              ));
              content = GestureDetector(
                onTap: () {
                  // 添加图片
                  pickImage(ctx);
                },
                child: addCell,
              );
            } else {
              // 被选中的图片
              content = Center(
                  child: Image.file(
                fileList[index - 1],
                width: 80.0,
                height: 80.0,
                fit: BoxFit.cover,
              ));
            }
            return Container(
              margin: const EdgeInsets.all(2.0),
              width: 80.0,
              height: 80.0,
              color: const Color(0xFFECECEC),
              child: content,
            );
          }),
        );
      },
    );
    var children = [
      const Text(
        "提示：由于OSC的openapi限制，发布动弹的接口只支持上传一张图片，本项目可添加最多9张图片，但OSC只会接收最后一张图片。",
        style: TextStyle(fontSize: 12.0),
      ),
      textField,
      Container(
          margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          height: 200.0,
          child: gridView)
    ];
    if (isLoading) {
      children.add(Container(
        margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ));
    } else {
      children.add(Container(
          margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: Center(
            child: Text(msg),
          )));
    }
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: children,
      ),
    );
  }

  // 相机拍照或者从图库选择图片
  pickImage(ctx) {
    // 如果已添加了9张图片，则提示不允许添加更多
    num size = fileList.length;
    if (size >= 9) {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text("最多只能添加9张图片！"),
      ));
      return;
    }
    showModalBottomSheet<void>(context: context, builder: _bottomSheetBuilder);
  }

  Widget _bottomSheetBuilder(BuildContext context) {
    return SizedBox(
        height: 182.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
          child: Column(
            children: <Widget>[
              _renderBottomMenuItem("相机拍照", ImageSource.camera),
              const Divider(
                height: 2.0,
              ),
              _renderBottomMenuItem("图库选择照片", ImageSource.gallery)
            ],
          ),
        ));
  }

  _renderBottomMenuItem(title, ImageSource source) {
    var item = SizedBox(
      height: 60.0,
      child: Center(child: Text(title)),
    );
    return InkWell(
      child: item,
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          final picker = ImagePicker();
          _imageFile = picker.pickImage(source: source);
        });
      },
    );
  }

  sendTweet(ctx, token) async {
    if (token == null) {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text("未登录！"),
      ));
      return;
    }
    String content = _controller.text;
    if (content.isEmpty || content.trim().isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text("请输入动弹内容！"),
      ));
    }
    try {
      Map<String, String> params = Map();
      params['msg'] = content;
      params['access_token'] = token;
      var request = MultipartRequest('POST', Uri.parse(Api.PUB_TWEET));
      request.fields.addAll(params);
      if (fileList.isNotEmpty) {
        for (File f in fileList) {
          var stream = http.ByteStream(DelegatingStream.typed(f.openRead()));
          var length = await f.length();
          var filename = f.path.substring(f.path.lastIndexOf("/") + 1);
          request.files.add(
              http.MultipartFile('img', stream, length, filename: filename));
        }
      }
      setState(() {
        isLoading = true;
      });
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        if (kDebugMode) {
          print(value);
        }
        var obj = json.decode(value);
        var error = obj['error'];
        setState(() {
          if (error != null && error == '200') {
            // 成功
            setState(() {
              isLoading = false;
              msg = "发布成功";
              fileList.clear();
            });
            _controller.clear();
          } else {
            setState(() {
              isLoading = false;
              msg = "发布失败：$error";
            });
          }
        });
      });
    } catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("发布动弹", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          Builder(
            builder: (ctx) {
              return IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // 发送动弹
                    DataUtils.isLogin().then((isLogin) {
                      if (isLogin) {
                        return DataUtils.getAccessToken();
                      } else {
                        return null;
                      }
                    }).then((token) {
                      sendTweet(ctx, token);
                    });
                  });
            },
          )
        ],
      ),
      body: FutureBuilder<XFile?>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<XFile?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            fileList.add(File(snapshot.data!.path));
            _imageFile = Future.value(null);
          }
          return getBody();
        },
      ),
    );
  }
}
