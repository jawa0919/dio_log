import 'package:flutter/material.dart';

import '../bean/net_options.dart';

/// LogErrorWidget
class LogErrorWidget extends StatefulWidget {
  final NetOptions netOptions;
  const LogErrorWidget(this.netOptions, {Key? key}) : super(key: key);

  @override
  State<LogErrorWidget> createState() => _LogErrorWidgetState();
}

class _LogErrorWidgetState extends State<LogErrorWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: double.infinity,
      child: Center(
        child: Text(widget.netOptions.errOptions?.errorMsg ?? 'no error'),
      ),
    );
  }
}
