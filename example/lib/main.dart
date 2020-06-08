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

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
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
