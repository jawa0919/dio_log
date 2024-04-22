import 'package:flutter/material.dart';

import '../bean/net_options.dart';
import '../utils/copy_clipboard.dart';
import '../utils/json_utils.dart';
import '../widget/json_view.dart';

/// 网络请求结果详情
class LogResponseWidget extends StatefulWidget {
  final NetOptions netOptions;

  const LogResponseWidget(this.netOptions, {Key? key}) : super(key: key);

  @override
  State<LogResponseWidget> createState() => _LogResponseWidgetState();
}

class _LogResponseWidgetState extends State<LogResponseWidget>
    with AutomaticKeepAliveClientMixin {
  bool isShowAll = false;
  double fontSize = 14;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var response = widget.netOptions.resOptions;
    var json = response?.data ?? 'no response';
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Switch(
                value: isShowAll,
                onChanged: (check) {
                  isShowAll = check;
                  fontSize = 14;
                  setState(() {});
                },
              ),
              Expanded(
                child: Slider(
                  value: fontSize,
                  max: 30,
                  min: 1,
                  onChanged: (v) {
                    fontSize = v;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          const Text(
            'Tip: long press a key to copy the value to the clipboard',
            style: TextStyle(
              fontSize: 10,
              color: Colors.red,
            ),
          ),
          _buildJsonView('headers', response?.headers),
          _buildJsonView('response.data', json),
        ],
      ),
    );
  }

  ///构建json树的展示
  Widget _buildJsonView(key, json) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 8, bottom: 8, right: 8, left: 8),
          height: 32,
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$key:',
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  copyClipboard(context, toJson(json));
                },
                child: Text('Copy $key'),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: JsonView(
            json: json,
            isShowAll: isShowAll,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
