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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                  'enter the request you want to send and press the send button:'),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(controller: controller),
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () {
                dio.get(controller.text);
              },
              label: const Icon(Icons.send_rounded),
              icon: const Text("Send"),
            )
          ],
        ),
      ),
    );
  }
}
