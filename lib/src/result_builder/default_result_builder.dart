import 'package:flutter/widgets.dart';

import 'widget_builders.dart';
import 'default_waiting_result_builder.dart';
import 'default_failed_result_builder.dart';
import 'default_pending_result_builder.dart';
import 'default_empty_builder.dart';

/// Provide multiple defauilt builders to child
///
/// See also
/// * [DefaultPendingResultBuilder]
/// * [DefaultWaitingResultBuilder]
/// * [DefaultFailedResultBuilder]
/// * [DefaultEmptyBuilder]
class DefaultResultBuilder extends StatelessWidget {
  /// Default pending builder
  final WidgetBuilder? pendingBuilder;

  /// Default waiting builder
  final WidgetBuilder? waitingBuilder;

  /// Default failed builder
  final FailedResultBuilder? failedBuilder;

  /// Default empty builder
  final WidgetBuilder? emptyBuilder;

  /// child widget
  final Widget child;

  /// Provider default waiting builders to [child].
  ///
  /// [pendingBuilder], [waitingBuilder], [failedBuilder] should at least 1 have value.
  const DefaultResultBuilder({
    Key? key,
    this.pendingBuilder,
    this.waitingBuilder,
    this.failedBuilder,
    this.emptyBuilder,
    required this.child,
  })   : assert(
          pendingBuilder != null ||
              waitingBuilder != null ||
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

    if (waitingBuilder != null) {
      result =
          DefaultWaitingResultBuilder(builder: waitingBuilder!, child: result);
    }

    if (failedBuilder != null) {
      result =
          DefaultPendingResultBuilder(builder: pendingBuilder!, child: result);
    }

    if (emptyBuilder != null) {
      result = DefaultEmptyBuilder(builder: pendingBuilder!, child: result);
    }

    return result;
  }

  /// Configue global builders in batch
  static void setGlobalBuilder({
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? waitingBuilder,
    FailedResultBuilder? failedBuilder,
    WidgetBuilder? emptyBuilder,
  }) {
    if (pendingBuilder != null) {
      DefaultPendingResultBuilder.globalBuilder = pendingBuilder;
    }

    if (waitingBuilder != null) {
      DefaultWaitingResultBuilder.globalBuilder = waitingBuilder;
    }

    if (failedBuilder != null) {
      DefaultFailedResultBuilder.globalBuilder = failedBuilder;
    }

    if (emptyBuilder != null) {
      DefaultEmptyBuilder.globalBuilder = emptyBuilder;
    }
  }
}
