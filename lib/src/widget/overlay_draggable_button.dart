import 'package:flutter/material.dart';

import 'http_log_list_widget.dart';

OverlayEntry? itemEntry;

///显示全局悬浮调试按钮
showDebugBtn(BuildContext context, {Widget? button, Color? btnColor}) {
  /// widget第一次渲染完成
  Future.delayed(const Duration(milliseconds: 500)).then((value) {
    try {
      dismissDebugBtn();
      itemEntry = OverlayEntry(
          builder: (BuildContext context) =>
              button ?? DraggableButtonWidget(btnColor: btnColor));

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
  double btnSize = 44;

  late double screenWidth;
  late double screenHeight;
  late double screenTop;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    screenTop = MediaQuery.of(context).padding.top;
    Color color = widget.btnColor ?? Colors.grey;
    Widget w = GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HttpLogListWidget(),
          ),
        );
      },
      onPanUpdate: _dragUpdate,
      child: Container(
        width: btnSize,
        height: btnSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color.withOpacity(0.4),
        ),
        child: Icon(
          Icons.developer_board,
          color: color.withOpacity(0.8),
          size: btnSize - 8,
        ),
      ),
    );

    ///计算偏移量限制
    if (left < 1) {
      left = 1;
    }
    if (left > screenWidth - btnSize) {
      left = screenWidth - btnSize;
    }

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
