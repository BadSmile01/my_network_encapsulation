import 'package:flutter/material.dart';
import 'package:my_network_encapsulation/base/base_function.dart';
import 'package:my_network_encapsulation/network/http/http.dart';

/// @describe: 通常是和 viewpager 联合使用  ， 类似于Android 中的 fragment
/// 不过生命周期 还需要在容器父类中根据tab切换来完善
///
/// @author: qds
/// @date:
// ignore: must_be_immutable
abstract class BaseInnerWidget extends StatefulWidget {
  BaseInnerWidget({Key? key}) : super(key: key);

  late BaseInnerWidgetState baseInnerWidgetState;
  int? index;

  @override
  BaseInnerWidgetState createState() {
    baseInnerWidgetState = getState();
    index = setIndex();
    return baseInnerWidgetState;
  }

  /// 作为内部页面 ， 设置是第几个页面 ，也就是在list中的下标 ， 方便 生命周期的完善
  int setIndex();

  BaseInnerWidgetState getState();

  String getStateName() {
    return baseInnerWidgetState.getClassName();
  }
}

abstract class BaseInnerWidgetState<T extends BaseInnerWidget> extends State<T>
    with AutomaticKeepAliveClientMixin, BaseFunction {
  @override
  void initState() {
    initBaseCommon(this, context);
    setBackIconHinde();
    setTopBarVisible(false);
    setAppBarVisible(false);
    setAppBarBottomShow(false);
    onCreate();
    onResume();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    bottomVertical = getVerticalMargin();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return getBaseView(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    onDestroy();
    Http.cancelHttp(getClassName());
    super.dispose();
  }

  /// 返回作为内部页面，垂直方向 头和底部 被占用的 高度
  double getVerticalMargin();

  @override
  bool get wantKeepAlive => true;

  /// 为了完善生命周期而特意搞得 方法,
  /// 手动调用 onPause 和onResume
  void changePageVisible(int index, int preIndex) {
    if (index != preIndex) {
      if (preIndex == widget.index) {
        onPause();
      } else if (index == widget.index) {
        onResume();
      }
    }
  }
}
