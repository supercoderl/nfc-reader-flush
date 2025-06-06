import 'dart:convert';

class Utf8Utils {
  static String? encode(String origin) {
    if (origin.isEmpty) {
      return null;
    }
    List<int> list = utf8.encode(origin);
    StringBuffer sb = StringBuffer();
    for (int i in list) {
      sb.write("$i,");
    }
    String result = sb.toString();
    return result.substring(0, result.length - 1);
  }

  static String? decode(String encodeStr) {
    if (encodeStr.isEmpty) {
      return null;
    }
    List<String> list = encodeStr.split(",");
    if (list.isNotEmpty) {
      var intList = <int>[];
      for (String s in list) {
        intList.add(int.parse(s));
      }
      return utf8.decode(intList);
    }
    return null;
  }
}
