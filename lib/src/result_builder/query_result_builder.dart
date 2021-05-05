import 'package:flutter/widgets.dart';

import 'package:stated_result/stated_result.dart';

import 'stated_result_builder_base.dart';
import 'default_waiting_result_builder.dart';
import 'default_failed_result_builder.dart';
import 'default_pending_result_builder.dart';
import 'widget_builders.dart';

/// Widget that builds UI according to the state of [AsyncQueryResult] or [QueryResult]
class QueryResultBuilder<T>
    extends StatedResultBuilderBase<AsyncQueryResult<T>> {
  /// Builder to be used when [ValueResult] is given,
  /// which could be either [SucceededResult] or [InitialValueResult].
  final ValueResultBuilder<T> builder;

  /// Build UI with [AsyncQueryResult]
  ///
  /// * [pendingBuilder] - Builder to be used when [PendingResult] is given.
  /// * [waitingBuilder] - Builder to be used when [WaitingResult] is given.
  /// * [failedBuilder] - Builder to be used when [FailedResult] is given.
  /// * [builder] - Builder to be used when [SucceededResult] or [InitialValueResult] is given.
  ///
  /// [pendingBuilder], [waitingBuilder], [failedBuilder] are optional,
  /// if not given default builder provided by [DefaultPendingResultBuilder],
  /// [DefaultWaitingResultBuilder], [DefaultFailedResultBuilder] or global default
  /// builders will be used.
  ///
  /// To consume [QueryResult],
  /// use [QueryResultBuilder.sync] instead.
  QueryResultBuilder({
    Key? key,
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? waitingBuilder,
    FailedResultBuilder? failedBuilder,
    required this.builder,
    required AsyncQueryResult<T> result,
  }) : super(
          key: key,
          pendingBuilder: pendingBuilder,
          waitingBuilder: waitingBuilder,
          failedBuilder: failedBuilder,
          result: result,
        );

  /// Build UI with [QueryResult]
  ///
  /// * [pendingBuilder] - Builder to be used when [PendingResult] is given.
  /// * [waitingBuilder] - Builder to be used when [WaitingResult] is given.
  /// * [failedBuilder] - Builder to be used when [FailedResult] is given.
  /// * [builder] - Builder to be used when [SucceededResult] or [InitialValueResult] is given.
  ///
  /// [pendingBuilder], [waitingBuilder], [failedBuilder] are optional,
  /// if not given default builder provided by [DefaultPendingResultBuilder],
  /// [DefaultWaitingResultBuilder], [DefaultFailedResultBuilder] or global default
  /// builders will be used.
  QueryResultBuilder.sync({
    Key? key,
    FailedResultBuilder? failedBuilder,
    required ValueResultBuilder<T> builder,
    required QueryResult<T> result,
  }) : this(
          key: key,
          failedBuilder: failedBuilder,
          builder: builder,
          result: AsyncQueryResult<T>.from(result),
        );

  @override
  Widget buildData(BuildContext context) =>
      builder(context, result.asValue<T>());
}
