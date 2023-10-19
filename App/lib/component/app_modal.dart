import 'package:flutter/material.dart';
import 'package:gohan_map/colors/app_colors.dart';

//定数
//キーボードを避けるためにどれだけ余白をとるか
const double _avoidKeyboardPadding = 200;

///下から出てくるモーダルウィジェットの中身の雛形
class AppModal extends StatefulWidget {
  final Widget child; //子要素となるウィジェット
  final double initialChildSize; //初期の大きさが画面の高さの何倍か
  final double minChildSize; //最小の大きさが画面の高さの何倍か
  final double maxChildSize; //最大の大きさが画面の高さの何倍か
  final bool showKnob; //つまみを表示するか
  final bool avoidKeyboardFlg; //キーボードを避けるかどうか
  final Color backgroundColor;
  const AppModal({
    this.initialChildSize = 0.4,
    this.minChildSize = 0.2,
    this.maxChildSize = 0.9,
    this.showKnob = true,
    this.avoidKeyboardFlg = false,
    this.backgroundColor = AppColors.whiteColor,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<AppModal> createState() => _AppModalState();
}

class _AppModalState extends State<AppModal> {
  final DraggableScrollableController controller =
      DraggableScrollableController();

  bool finished = false;
  @override
  Widget build(BuildContext context) {
    //modalの高さをNavigationBarに合わせる
    var ratio = 0.0;

    // if (maxChildSize == 1) {
    //   ratio = (displayHeight - navigationBarHeight) / displayHeight;
    // } else {
    //   ratio = maxChildSize;
    // }
    ratio = widget.maxChildSize;
    return GestureDetector(
      //モーダルの外側をタップしたらモーダルを閉じる
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
        //スクロール可能なモーダルウィジェット
        controller: controller,
        builder: (BuildContext context, scrollController) {
          controller.addListener(() {
            double sheetHeight = controller.size;
            //minChildSize以下になったらモーダルを閉じる
            //MaterialModalBottomSheetを使うときは、これがないとモーダルを閉じられない
            if (sheetHeight == widget.minChildSize && !finished) {
              finished = true;
              Navigator.pop(context);
            }
          });
          return InkWell(
            onTap: () {
              //キーボードを閉じる
              FocusScope.of(context).unfocus();
            }, //モーダルの内側をタップしてモーダルを閉じないようにタップイベントを無効化
            child: Container(
              //モーダルの中身
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 16, color: Colors.black.withOpacity(0.2))
                ],
                color: widget.backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: _ChildScrollView(
                  draggableController: controller,
                  scrollController: scrollController,
                  avoidKeyboard: widget.avoidKeyboardFlg,
                  showKnob: widget.showKnob,
                  child: widget.child),
            ),
          );
        },
        initialChildSize: widget.initialChildSize /*最初の大きさが親ウェジェットの何倍か*/,
        minChildSize: widget.minChildSize /*最小の大きさが親ウェジェットの何倍か*/,
        maxChildSize: ratio /*最大の大きさが親ウェジェットの何倍か*/,
      ),
    );
  }
}

//モーダル内のスクロール可能な領域
//スクロールを実行するためにはscrollControllerが必要なのでここでStatefulWidgetを使用
class _ChildScrollView extends StatefulWidget {
  const _ChildScrollView({
    required this.draggableController,
    required this.scrollController,
    required this.avoidKeyboard,
    required this.showKnob,
    required this.child,
  });

  final DraggableScrollableController draggableController;
  final ScrollController scrollController;
  final bool showKnob;
  final bool avoidKeyboard;
  final Widget child;

  @override
  State<_ChildScrollView> createState() => _ChildScrollViewState();
}

class _ChildScrollViewState extends State<_ChildScrollView> {
  //余白をつけるかどうかのフラグ
  //フォーカスアウト時はアニメーションが終わるまでの遅延を入れるため、avoidKeyboardとは別のフラグを定義
  bool existMargin = false;

  @override
  void didUpdateWidget(covariant _ChildScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.avoidKeyboard != oldWidget.avoidKeyboard) {
      // avoidKeyboardの値が変更された場合に実行する処理
      if (widget.avoidKeyboard) {
        // フォーカスされた場合の処理
        existMargin = true;
        widget.draggableController
            .animateTo(
          1,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeIn,
        )
            .then((value) {
          widget.scrollController.animateTo(
            widget.scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        });
      } else {
        // フォーカスが外れた場合の処理
        widget.scrollController
            .animateTo(
          widget.scrollController.position.maxScrollExtent -
              _avoidKeyboardPadding,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        )
            .then((value) {
          existMargin = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //DraggableScrollableSheeの子要素は必ずScrollableなウィジェットである必要がある
      controller: widget.scrollController,
      child: Column(
        children: [
          if (widget.showKnob)
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
              height: 5,
              width: 26,
              decoration: BoxDecoration(
                color: const Color(0x16000000),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: widget.child,
          ),
          if (existMargin)
            const SizedBox(
              height: _avoidKeyboardPadding,
            ),
        ],
      ),
    );
  }
}
