import 'dart:async';

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
  StreamSubscription<String> logs;
  List<String> logsItems = [];
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logs = FrustyLogger.addListener(_onLogEvent);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    logs.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Frusty Logger app'),
        ),
        body: ListView.separated(
          separatorBuilder: (_, __) => const Divider(),
          controller: _scrollController,
          itemCount: logsItems.length ?? 0,
          itemBuilder: (_, i) {
            return Text(logsItems[i] ?? 'No Log Messages');
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Demo.randLog();
          },
        ),
      ),
    );
  }

  void _onLogEvent(String event) {
    final pattern = [
      '[\\u001B\\u009B][[\\]()#;?]*(?:(?:(?:[a-zA-Z\\d]*(?:;[-a-zA-Z\\d\\/#&.:=?%@~_]*)*)?\\u0007)',
      '(?:(?:\\d{1,4}(?:;\\d{0,4})*)?[\\dA-PR-TZcf-ntqry=><~]))'
    ].join('|');
    final r = RegExp(pattern);
    final e = event.replaceAll(r, '');
    logsItems.add(e);
    print(event);
    setState(() {});
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }
}
