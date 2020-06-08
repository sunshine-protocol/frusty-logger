import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

void println(Pointer<Utf8> msg) {
  debugPrint(Utf8.fromUtf8(msg));
}

typedef frustyLoggerInitRust = Uint32 Function(
  Pointer<NativeFunction<Void Function(Pointer<Utf8>)>>,
);

typedef frustyLoggerInitDart = int Function(
  Pointer<NativeFunction<Void Function(Pointer<Utf8>)>>,
);

typedef frustyLoggerIsInitializedRust = Uint32 Function();

typedef frustyLoggerIsInitializedDart = int Function();
