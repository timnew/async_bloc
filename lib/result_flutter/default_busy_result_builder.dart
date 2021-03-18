import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DefaultBusyResultBuilder extends InheritedWidget {
  final WidgetBuilder builder;

  DefaultBusyResultBuilder({
    Key? key,
    required this.builder,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget is! DefaultBusyResultBuilder ||
      oldWidget.builder != this.builder;

  static WidgetBuilder globalBuilder = _globalBuilderImp;

  static Widget _globalBuilderImp(BuildContext context) => Center(
        child: Text("Loading..."),
      );

  static WidgetBuilder findBuilder(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<DefaultBusyResultBuilder>()
          ?.builder ??
      globalBuilder;

  static Widget ensureBuild(
    BuildContext context,
    WidgetBuilder? customBuilder,
  ) =>
      (customBuilder != null)
          ? customBuilder(context)
          : findBuilder(context)(context);
}
