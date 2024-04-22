import 'package:flutter/material.dart';

import '../bean/net_options.dart';
import 'overlay_draggable_button.dart';
import '../page/log_widget.dart';
import '../utils/log_pool_manager.dart';
import '../utils/time_utils.dart';

/// 网络请求日志列表
class HttpLogListWidget extends StatefulWidget {
  const HttpLogListWidget({Key? key}) : super(key: key);

  @override
  State<HttpLogListWidget> createState() => _HttpLogListWidgetState();
}

class _HttpLogListWidgetState extends State<HttpLogListWidget> {
  Map<String, NetOptions> logMap = {};
  List<String> keys = [];

  @override
  Widget build(BuildContext context) {
    logMap = LogPoolManager.getInstance().logMap;
    keys = LogPoolManager.getInstance().keys;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        toolbarHeight: 48,
        titleSpacing: 4,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios_rounded),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: InkWell(
          child: const Text('Dio Request List'),
          onLongPress: () {
            if (debugBtnIsShow()) {
              dismissDebugBtn();
            } else {
              showDebugBtn(context);
            }
            setState(() {});
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever_rounded),
            onPressed: () {
              LogPoolManager.getInstance().clear();
              setState(() {});
            },
          )
        ],
      ),
      body: logMap.isEmpty
          ? const Center(child: Text('no request log'))
          : ListView.builder(
              reverse: false,
              itemCount: keys.length,
              itemBuilder: (BuildContext context, int index) {
                NetOptions item = logMap[keys[index]]!;
                return _buildItem(item);
              },
            ),
    );
  }

  ///构建请求的简易信息
  Widget _buildItem(NetOptions item) {
    var resOpt = item.resOptions;
    var reqOpt = item.reqOptions;

    ///格式化请求时间
    var requestTime = getTimeStr1(reqOpt!.requestTime!);

    Color textColor =
        LogPoolManager.getInstance().isError(item) ? Colors.red : Colors.black;
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 6,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LogWidget(item);
          }));
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'url: ${reqOpt.url}',
                style: TextStyle(
                  color: textColor,
                ),
              ),
              const Divider(height: 2),
              Text(
                'status: ${resOpt?.statusCode}',
                style: TextStyle(
                  color: textColor,
                ),
              ),
              const Divider(height: 2),
              Text(
                'requestTime: $requestTime    duration: ${resOpt?.duration ?? 0}ms',
                style: TextStyle(
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
