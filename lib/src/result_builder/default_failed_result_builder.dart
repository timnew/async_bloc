import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stated_result/stated_result.dart';

import 'widget_builders.dart';

/// Provide defauilt failed builder to child
class DefaultFailedResultBuilder extends InheritedWidget {
  /// The default builder
  final FailedResultBuilder builder;

  /// Provider default failed builder to [child].
  DefaultFailedResultBuilder({
    Key? key,
    required this.builder,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget is! DefaultFailedResultBuilder ||
      oldWidget.builder != this.builder;

  /// The global default builder, which will be used if no default builder can be found.
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

  /// Search for default builder from ancesters of [context].
  /// When no default builder can be found, [globalBuilder] will be returned
  static FailedResultBuilder findBuilder(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<DefaultFailedResultBuilder>()
          ?.builder ??
      globalBuilder;

  /// Build the UI for given state
  ///
  /// If [customBuilder] is given, it is used.
  /// Otherwise [findBuilder] will be called with [context] to find the default builder.
  static Widget ensureBuild(
    BuildContext context,
    FailedResultBuilder? customBuilder,
    FailedResult result,
  ) =>
      (customBuilder != null)
          ? customBuilder(context, result)
          : findBuilder(context)(context, result);
}
