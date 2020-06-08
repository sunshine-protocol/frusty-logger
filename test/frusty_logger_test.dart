import 'package:flutter_test/flutter_test.dart';
import 'package:frusty_logger/frusty_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {});

  tearDown(() {
    // nothing to tear down
  });

  test('init', () async {
    expect(FrustyLogger.isInitialized, false);
  });
}
