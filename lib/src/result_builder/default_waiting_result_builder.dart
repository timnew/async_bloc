import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'default_failed_result_builder.dart';
import 'default_pending_result_builder.dart';
import 'default_empty_builder.dart';
import 'default_result_builder.dart';

/// Provide defauilt waiting builder to child
///
/// See also
/// * [DefaultPendingResultBuilder]
/// * [DefaultFailedResultBuilder]
/// * [DefaultEmptyBuilder]
/// * [DefaultResultBuilder]
class DefaultWaitingResultBuilder extends InheritedWidget {
  /// The default builder
  final WidgetBuilder builder;

  /// Provider default waiting builder to [child].
  DefaultWaitingResultBuilder({
    Key? key,
    required this.builder,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget is! DefaultWaitingResultBuilder ||
      oldWidget.builder != this.builder;

  static WidgetBuilder _globalBuilder = defaltGlobalBuilder;

  /// The global default builder, which will be used if no default builder can be found.
  static WidgetBuilder get globalBuilder => _globalBuilder;

  /// Set global default builder, if [builder] is `null`, it revert it to default one.
  static void setGlobalBuilder(WidgetBuilder? builder) {
    _globalBuilder = builder ?? defaltGlobalBuilder;
  }

  /// Default global builder implementation
  static Widget defaltGlobalBuilder(BuildContext context) => Center(
        child: Text("Loading..."),
      );

  /// Search for default builder from ancesters of [context].
  /// When no default builder can be found, [globalBuilder] will be returned
  static WidgetBuilder findBuilder(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<DefaultWaitingResultBuilder>()
          ?.builder ??
      globalBuilder;

  /// Build the UI for given state
  ///
  /// If [customBuilder] is given, it is used.
  /// Otherwise [findBuilder] will be called with [context] to find the default builder.
  static Widget ensureBuild(
    BuildContext context,
    WidgetBuilder? customBuilder,
  ) =>
      (customBuilder != null)
          ? customBuilder(context)
          : findBuilder(context)(context);
}
