import 'package:flutter/material.dart';
import 'package:frusty_logger/frusty_logger.dart';

import 'demo.dart';

void main() {
  FrustyLogger.init(Demo.dynamicLibrary);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      FrustyLogger.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Frusty Logger app'),
        ),
        body: Center(
          child: Text('Click the FAB and See the Logs'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () {
            Demo.randLog();
          },
        ),
      ),
    );
  }
}
