import 'package:flutter/material.dart';

import 'http_log_list_widget.dart';

OverlayEntry? itemEntry;

///显示全局悬浮调试按钮
showDebugBtn(BuildContext context, {Color? btnColor}) {
  /// widget第一次渲染完成
  Future.delayed(const Duration(milliseconds: 500)).then((value) {
    try {
      dismissDebugBtn();
      itemEntry = OverlayEntry(
        builder: (_) => DraggableButtonWidget(btnColor: btnColor),
      );

      /// 显示悬浮menu
      Overlay.of(context)?.insert(itemEntry!);
    } catch (e) {
      debugPrint(e.toString());
    }
  });
}

/// 关闭悬浮按钮
dismissDebugBtn() {
  itemEntry?.remove();
  itemEntry = null;
}

/// 悬浮按钮展示状态
bool debugBtnIsShow() {
  return !(itemEntry == null);
}

class DraggableButtonWidget extends StatefulWidget {
  final Color? btnColor;

  const DraggableButtonWidget({Key? key, this.btnColor}) : super(key: key);

  @override
  State<DraggableButtonWidget> createState() => _DraggableButtonWidgetState();
}

class _DraggableButtonWidgetState extends State<DraggableButtonWidget> {
  double left = 30;
  double top = 100;
  double btnSize = 40;

  late double screenWidth;
  late double screenHeight;
  late double screenTop;

  bool showWidget = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    screenTop = MediaQuery.of(context).padding.top;
    Color color = widget.btnColor ?? Theme.of(context).primaryColor;
    Widget w = GestureDetector(
      onTap: () {
        if (showWidget) return;
        showWidget = true;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const HttpLogListWidget()))
            .then((_) => showWidget = false);
      },
      onPanUpdate: _dragUpdate,
      child: Container(
        alignment: Alignment.center,
        width: btnSize,
        height: btnSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color.withOpacity(0.3),
        ),
        child: Text(
          "Dio",
          style: TextStyle(
            fontSize: btnSize - 24,
            color: color.withOpacity(0.8),
          ),
        ),
      ),
    );

    /// 计算偏移量限制
    if (left < 1) {
      left = 1;
    }
    if (left > screenWidth - btnSize) {
      left = screenWidth - btnSize;
    }

    /// 安全区
    if (top < screenTop) {
      top = screenTop;
    }
    if (top > screenHeight - btnSize) {
      top = screenHeight - btnSize;
    }
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: left, top: top),
      child: w,
    );
  }

  _dragUpdate(DragUpdateDetails detail) {
    Offset offset = detail.delta;
    left = left + offset.dx;
    top = top + offset.dy;
    setState(() {});
  }
}
