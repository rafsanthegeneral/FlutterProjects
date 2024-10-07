//import 'dart:io';
import 'package:flutter/foundation.dart';

class PubicImageStoreVar {
  static final ValueNotifier<String> imagePathValue =
      ValueNotifier<String>('light');

  static void updateImagePathValue(String newImagePathvalue) {
    imagePathValue.value = newImagePathvalue;
  }
}
