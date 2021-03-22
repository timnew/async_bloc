import 'package:flutter/widgets.dart';

import 'package:stated_result/stated_result.dart';

import 'stated_result_builder_base.dart';
import 'default_waiting_result_builder.dart';
import 'default_failed_result_builder.dart';
import 'default_pending_result_builder.dart';
import 'widget_builders.dart';

/// Widget that builds UI according to the state of [AsyncActionResult] or [ActionResult]
class ActionResultBuilder extends StatedResultBuilderBase<AsyncActionResult> {
  /// Builder to be used when [CompletedResult] is given.
  final WidgetBuilder completedBuilder;

  /// Build UI with [AsyncActionResult]
  ///
  /// * [pendingBuilder] - Builder to be used when [PendingResult] is given.
  /// * [waitingBuilder] - Builder to be used when [WaitingResult] is given.
  /// * [failedBuilder] - Builder to be used when [FailedResult] is given.
  /// * [completedBuilder] - Builder to be used when [CompletedResult] is given.
  ///
  /// [pendingBuilder], [waitingBuilder], [failedBuilder] are optional,
  /// if not given default builder provided by [DefaultPendingResultBuilder],
  /// [DefaultWaitingResultBuilder], [DefaultFailedResultBuilder] or global default
  /// builders will be used.
  ///
  /// To consume [ActionResult] instead of [AsyncActionResult],
  /// use [ActionResultBuilder.sync] instead.
  ActionResultBuilder({
    Key? key,
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? waitingBuilder,
    FailedResultBuilder? failedBuilder,
    required this.completedBuilder,
    required AsyncActionResult result,
  }) : super(
          key: key,
          pendingBuilder: pendingBuilder,
          waitingBuilder: waitingBuilder,
          failedBuilder: failedBuilder,
          result: result,
        );

  /// Build UI with [ActionResult]
  ///
  /// * [pendingBuilder] - Builder to be used when [PendingResult] is given.
  /// * [waitingBuilder] - Builder to be used when [WaitingResult] is given.
  /// * [failedBuilder] - Builder to be used when [FailedResult] is given.
  /// * [completedBuilder] - Builder to be used when [CompletedResult] is given.
  ///
  /// [pendingBuilder], [waitingBuilder], [failedBuilder] are optional,
  /// if not given default builder provided by [DefaultPendingResultBuilder],
  /// [DefaultWaitingResultBuilder], [DefaultFailedResultBuilder] or global default
  /// builders will be used.
  ActionResultBuilder.sync({
    Key? key,
    FailedResultBuilder? failedBuilder,
    required WidgetBuilder completedBuilder,
    required ActionResult result,
  }) : this(
          key: key,
          completedBuilder: completedBuilder,
          result: result.asAsyncResult(),
        );

  @override
  Widget buildData(BuildContext context) => completedBuilder(context);
}
