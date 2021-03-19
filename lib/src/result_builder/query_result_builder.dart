import 'package:flutter/widgets.dart';

import 'package:stated_result/stated_result.dart';

import 'stated_result_builder_base.dart';
import 'default_busy_result_builder.dart';
import 'default_failed_result_builder.dart';
import 'default_pending_result_builder.dart';
import 'widget_builders.dart';

/// Widget that builds UI according to the state of [AsyncQueryResult] or [QueryResult]
class QueryResultBuilder<T>
    extends StatedResultBuilderBase<AsyncQueryResult<T>> {
  /// Builder to be used when [ValueResult] is given,
  /// which could be either [SucceededResult] or [InitialValueResult].
  final ValueResultBuilder<T> valueBuilder;

  /// Build UI with [AsyncQueryResult]
  ///
  /// * [pendingBuilder] - Builder to be used when [PendingResult] is given.
  /// * [busyBuilder] - Builder to be used when [BusyResult] is given.
  /// * [failedBuilder] - Builder to be used when [FailedResult] is given.
  /// * [valueBuilder] - Builder to be used when [SucceededResult] or [InitialValueResult] is given.
  ///
  /// [pendingBuilder], [busyBuilder], [failedBuilder] are optional,
  /// if not given default builder provided by [DefaultPendingResultBuilder],
  /// [DefaultBusyResultBuilder], [DefaultFailedResultBuilder] or global default
  /// builders will be used.
  ///
  /// To consume [QueryResult],
  /// use [QueryResultBuilder.sync] instead.
  QueryResultBuilder({
    Key? key,
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? busyBuilder,
    FailedResultBuilder? failedBuilder,
    required this.valueBuilder,
    required AsyncQueryResult<T> result,
  }) : super(
          key: key,
          pendingBuilder: pendingBuilder,
          busyBuilder: busyBuilder,
          failedBuilder: failedBuilder,
          result: result,
        );

  /// Build UI with [QueryResult]
  ///
  /// * [pendingBuilder] - Builder to be used when [PendingResult] is given.
  /// * [busyBuilder] - Builder to be used when [BusyResult] is given.
  /// * [failedBuilder] - Builder to be used when [FailedResult] is given.
  /// * [valueBuilder] - Builder to be used when [SucceededResult] or [InitialValueResult] is given.
  ///
  /// [pendingBuilder], [busyBuilder], [failedBuilder] are optional,
  /// if not given default builder provided by [DefaultPendingResultBuilder],
  /// [DefaultBusyResultBuilder], [DefaultFailedResultBuilder] or global default
  /// builders will be used.
  QueryResultBuilder.sync({
    Key? key,
    FailedResultBuilder? failedBuilder,
    required ValueResultBuilder<T> valueBuilder,
    required QueryResult<T> result,
  }) : this(
          key: key,
          failedBuilder: failedBuilder,
          valueBuilder: valueBuilder,
          result: result.asAsyncResult(),
        );

  @override
  Widget buildData(BuildContext context) =>
      valueBuilder(context, result.asValueResult<T>()!.value);
}
