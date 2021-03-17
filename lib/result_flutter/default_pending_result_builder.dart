import 'package:flutter/widgets.dart';

class DefaultPendingResultBuilder extends InheritedWidget {
  final WidgetBuilder builder;

  DefaultPendingResultBuilder({
    Key? key,
    required this.builder,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget is! DefaultPendingResultBuilder ||
      oldWidget.builder != this.builder;

  static WidgetBuilder defaultBuilder = _defaultBuilder;

  static Widget _defaultBuilder(BuildContext context) => Container();

  static WidgetBuilder findBuilder(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<DefaultPendingResultBuilder>()
          ?.builder ??
      defaultBuilder;

  static Widget ensureBuild(
    BuildContext context,
    WidgetBuilder? customBuilder,
  ) =>
      (customBuilder != null)
          ? customBuilder(context)
          : findBuilder(context)(context);
}
