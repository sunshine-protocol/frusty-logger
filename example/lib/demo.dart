import 'dart:ffi';
import 'dart:io';

DynamicLibrary load() {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('libdemo.so');
  } else {
    throw NotSupportedPlatform();
  }
}

class NotSupportedPlatform extends Error implements Exception {
  NotSupportedPlatform() {
    throw Error();
  }
}

class Demo {
  static final _dl = load();
  static final _randLog =
      _dl.lookupFunction<Void Function(), void Function()>('rand_log');
  static randLog() {
    _randLog();
  }

  static DynamicLibrary get dynamicLibrary => _dl;
}
