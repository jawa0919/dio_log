import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:dio_log_plus/dio_log_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    _counter++;
    setState(() {});
  }

  final dio = Dio();
  final url = 'https://api.github.com/users';
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    DioLogInterceptor.enablePrintLog = false;
    dio.interceptors.add(DioLogInterceptor());
    // LogPoolManager.getInstance().isError = (res) => res.resOptions==null;

    showDebugBtn(context);
    controller.text = url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            const Text(
                'enter the request you want to send and press the send button:'),
            TextField(controller: controller),
            IconButton(
              onPressed: () {
                dio.get(controller.text);
              },
              icon: const Icon(Icons.send),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
