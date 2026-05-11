import 'dart:io';

abstract class PlatformInfo {
  bool get isAndroid;
  bool get isIOS;
}

class SystemPlatformInfo implements PlatformInfo {
  @override
  bool get isAndroid => Platform.isAndroid;

  @override
  bool get isIOS => Platform.isIOS;
}

PlatformInfo platformInfo = SystemPlatformInfo();
