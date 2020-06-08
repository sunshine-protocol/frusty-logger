import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'ffi.dart';

class FrustyLogger {
  static DynamicLibrary _dl;

  /// Init the Logger and Setup the Hooking into Rust Code.
  static void init(DynamicLibrary dl) {
    _dl = dl;
    // Avoid unnecessary calls
    if (isInitialized) return;
    final frustyLoggerInit =
        _dl.lookupFunction<frustyLoggerInitRust, frustyLoggerInitDart>(
      'frusty_logger_init',
    );

    final printlnPtr =
        Pointer.fromFunction<Void Function(Pointer<Utf8>)>(println);
    final res = frustyLoggerInit(printlnPtr);
    if (res != 0) {
      throw "Error While Initializing the logger, did you called `FrustyLogger.init()` before?";
    }
  }

  /// Check if the logger is initialized correctly
  static bool get isInitialized {
    if (_dl == null) return false;
    final frustyLoggerisInitialized = _dl.lookupFunction<
        frustyLoggerIsInitializedRust, frustyLoggerIsInitializedDart>(
      'frusty_logger_is_initialized',
    );
    final res = frustyLoggerisInitialized();
    return res == 1;
  }
}
