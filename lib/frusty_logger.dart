import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'ffi.dart';

class FrustyLogger {
  static DynamicLibrary _dl;
  static final RawReceivePort _responsePort = RawReceivePort();
  static final StreamController<String> _streamController = StreamController();

  /// Init the Logger and Setup the Hooking into Rust Code.
  static void init(DynamicLibrary dl) {
    _dl = dl;
    // Avoid unnecessary calls
    if (isInitialized) return;
    _responsePort.handler = _streamController.add;
    final frustyLoggerInit =
        _dl.lookupFunction<frusty_logger_init_C, frusty_logger_init_Dart>(
      'frusty_logger_init',
    );

    final res = frustyLoggerInit(
      _responsePort.sendPort.nativePort,
      NativeApi.postCObject,
    );
    if (res != 0) {
      throw "Error While Initializing the logger, did you called `FrustyLogger.init()` before?";
    }
  }

  /// add a listener to the log stream
  /// Returns a [StreamSubscription] which handles events from this stream
  static StreamSubscription<String> addListener(void Function(String) action) {
    return _streamController.stream.listen(action);
  }

  /// Check if the logger is initialized correctly
  static bool get isInitialized {
    if (_dl == null) return false;
    final frustyLoggerisInitialized = _dl.lookupFunction<
        frusty_logger_is_initialized_C, frusty_logger_is_initialized_Dart>(
      'frusty_logger_is_initialized',
    );
    final res = frustyLoggerisInitialized();
    return res == 1;
  }

  static void dispose() {
    _streamController.close();
    _responsePort.close();
  }
}
