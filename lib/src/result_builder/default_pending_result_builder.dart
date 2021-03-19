import 'package:flutter/widgets.dart';

import 'default_failed_result_builder.dart';
import 'default_busy_result_builder.dart';
import 'default_result_builder.dart';

/// Provide defauilt pending builder to child
///
/// See also
/// * [DefaultBusyResultBuilder]
/// * [DefaultFailedResultBuilder]
/// * [DefaultResultBuilder]
class DefaultPendingResultBuilder extends InheritedWidget {
  /// The default builder
  final WidgetBuilder builder;

  /// Provider default pending builder to [child].
  DefaultPendingResultBuilder({
    Key? key,
    required this.builder,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget is! DefaultPendingResultBuilder ||
      oldWidget.builder != this.builder;

  /// The global default builder, which will be used if no default builder can be found.
  static WidgetBuilder globalBuilder = _globalBuilderImp;

  static Widget _globalBuilderImp(BuildContext context) => Container();

  /// Search for default builder from ancesters of [context].
  /// When no default builder can be found, [globalBuilder] will be returned
  static WidgetBuilder findBuilder(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<DefaultPendingResultBuilder>()
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
