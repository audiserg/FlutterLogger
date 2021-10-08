import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logger for TCP',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Extratool Sniffer for ICOM and ENET'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _pid = 0;
  String _statusText = "";

  void _startTcpDump() async {
    // var process = await Process.start("tcpdump.exe", ["-w", "capture.pcap"],{});
    var process = await Process.start("direct.lnk", [], runInShell: true);
    var processcode = process.exitCode;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Result"), content: Text("$processcode"));
        });
    _pid = process.pid;
    setState(() {
      _statusText = "RECORDING";
    });
  }

  void _stopTcpDump() {
    // Process.killPid(_pid);
    Process.start("stop.lnk", [], runInShell: true);
    setState(() {
      _statusText = "RECORD STOPPED";
    });
  }

  void _clearLog() {
    Process.start("clear.lnk", [], runInShell: true);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: SizedBox(
            width: 100,
            height: 400,
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.file(File("logo.png")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 30)),
                    onPressed: _startTcpDump,
                    child: const Text("START")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 30)),
                    onPressed: _stopTcpDump,
                    child: const Text("STOP")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 30)),
                    onPressed: _clearLog,
                    child: const Text("CLEAR")),
                Text(
                  _statusText,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ),
        ));
  }
}
