import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'function_types.dart';

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
          BuildContext context, dynamic error, StackTrace? stackTrace) =>
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
            Text(error.toString()),
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
    dynamic error,
    StackTrace? stackTrace,
  ) =>
      (customBuilder != null)
          ? customBuilder(context, error, stackTrace)
          : findBuilder(context)(context, error, stackTrace);
}
