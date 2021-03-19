import 'package:flutter/widgets.dart';

import 'default_busy_result_builder.dart';
import 'default_failed_result_builder.dart';
import 'default_pending_result_builder.dart';
import 'widget_builders.dart';

/// Provide multiple defauilt builders to child
///
/// See also
/// * [DefaultPendingResultBuilder]
/// * [DefaultBusyResultBuilder]
/// * [DefaultFailedResultBuilder]
class DefaultResultBuilder extends StatelessWidget {
  /// Default pending builder
  final WidgetBuilder? pendingBuilder;

  /// Default busy builder
  final WidgetBuilder? busyBuilder;

  /// Default failed builder
  final FailedResultBuilder? failedBuilder;

  /// child widget
  final Widget child;

  /// Provider default busy builders to [child].
  ///
  /// [pendingBuilder], [busyBuilder], [failedBuilder] should at least 1 have value.
  const DefaultResultBuilder({
    Key? key,
    this.pendingBuilder,
    this.busyBuilder,
    this.failedBuilder,
    required this.child,
  })   : assert(
          pendingBuilder != null ||
              busyBuilder != null ||
              failedBuilder != null,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    if (failedBuilder != null) {
      result =
          DefaultFailedResultBuilder(builder: failedBuilder!, child: result);
    }

    if (busyBuilder != null) {
      result = DefaultBusyResultBuilder(builder: busyBuilder!, child: result);
    }

    if (failedBuilder != null) {
      result =
          DefaultPendingResultBuilder(builder: pendingBuilder!, child: result);
    }

    return result;
  }

  /// Configue global builders in batch
  static void setGlobalBuilder({
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? busyBuilder,
    FailedResultBuilder? failedBuilder,
  }) {
    if (pendingBuilder != null) {
      DefaultPendingResultBuilder.globalBuilder = pendingBuilder;
    }

    if (busyBuilder != null) {
      DefaultBusyResultBuilder.globalBuilder = busyBuilder;
    }

    if (failedBuilder != null) {
      DefaultFailedResultBuilder.globalBuilder = failedBuilder;
    }
  }
}
