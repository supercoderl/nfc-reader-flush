@JS()
library jsqr_wrapper;

import 'dart:typed_data';
import 'package:js/js.dart';

@JS('jsQR')
external JsQRResult? jsQR(Uint8ClampedList data, int width, int height);

@JS()
@anonymous
class JsQRResult {
  external String get data;
  external int get location;
}
