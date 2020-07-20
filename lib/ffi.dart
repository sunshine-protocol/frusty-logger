// ignore_for_file: unused_import, camel_case_types, non_constant_identifier_names
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart' as ffi;

typedef frusty_logger_init_C = Int32 Function(
  Int64 port,
  Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>
      post_c_object,
);
typedef frusty_logger_init_Dart = int Function(
  int port,
  Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>
      post_c_object,
);

typedef frusty_logger_is_initialized_C = Int32 Function();
typedef frusty_logger_is_initialized_Dart = int Function();
