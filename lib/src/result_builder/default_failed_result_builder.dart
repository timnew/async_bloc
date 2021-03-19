import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stated_result/stated_result.dart';

import 'widget_builders.dart';

class DefaultFailedResultBuilder extends InheritedWidget {
  final FailedResultBuilder builder;

  DefaultFailedResultBuilder({
    Key? key,
    required this.builder,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget is! DefaultFailedResultBuilder ||
      oldWidget.builder != this.builder;

  static FailedResultBuilder globalBuilder = _globalBuilderImp;

  static Widget _globalBuilderImp(
          BuildContext context, ErrorWithStack result) =>
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Error",
                textAlign: TextAlign.center,
              ),
            ),
            Text(result.error.toString()),
          ],
        ),
      );

  static FailedResultBuilder findBuilder(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<DefaultFailedResultBuilder>()
          ?.builder ??
      globalBuilder;

  static Widget ensureBuild(
    BuildContext context,
    FailedResultBuilder? customBuilder,
    FailedResult result,
  ) =>
      (customBuilder != null)
          ? customBuilder(context, result)
          : findBuilder(context)(context, result);
}
