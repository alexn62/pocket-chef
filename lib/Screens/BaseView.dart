import 'package:flutter/cupertino.dart';
import 'package:personal_recipes/ViewModels/BaseViewModel.dart';
import 'package:provider/provider.dart';

import '../locator.dart';

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final T Function()? viewModelBuilder;
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Function(T)? onModelReady;

  BaseView({
    required this.builder,
    this.onModelReady,
    this.viewModelBuilder,
  });

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  T? model;

  @override
  void initState() {
    if (widget.viewModelBuilder != null) {
      model = widget.viewModelBuilder!();
    } else {
      model = locator<T>();
    }
    if (widget.onModelReady != null) {
      widget.onModelReady!(model!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model!,
      child: Consumer<T>(builder: widget.builder),
    );
  }
}
