import 'package:flutter/widgets.dart';

import 'package:stated_result/stated_result.dart';

import 'stated_result_builder_base.dart';
import 'widget_builders.dart';

/// Widget that builds UI according to the state of [AsyncQueryResult] or [QueryResult]
class QueryResultBuilder<T>
    extends StatedResultBuilderBase<AsyncQueryResult<T>> {
  final ValueResultBuilder<T> valueBuilder;

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
