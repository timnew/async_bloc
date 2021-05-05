import 'package:flutter/widgets.dart';

import 'package:stated_result/stated_result.dart';

import 'result_future_builder_base.dart';
import 'default_failed_result_builder.dart';
import 'widget_builders.dart';

class QueryResultFutureBuilder<T>
    extends ResultFutureBuilderBase<QueryResult<T>> {
  final ValueResultBuilder<T> builder;

  QueryResultFutureBuilder({
    Key? key,
    required Future<QueryResult<T>>? future,
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? waitingBuilder,
    FailedResultBuilder? failedBuilder,
    required this.builder,
  }) : super(
          key: key,
          future: future,
          pendingBuilder: pendingBuilder,
          waitingBuilder: waitingBuilder,
          failedBuilder: failedBuilder,
        );

  QueryResultFutureBuilder.fromFuture({
    Key? key,
    required Future<T>? future,
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? waitingBuilder,
    FailedResultBuilder? failedBuilder,
    required ValueResultBuilder<T> builder,
  }) : this(
          key: key,
          future: future?.asQueryResult(),
          pendingBuilder: pendingBuilder,
          waitingBuilder: waitingBuilder,
          failedBuilder: failedBuilder,
          builder: builder,
        );

  @override
  Widget buildData(BuildContext context, QueryResult<T> data) => data.map(
        completed: (result) => builder(context, result.value),
        failed: (result) => DefaultFailedResultBuilder.ensureBuild(
            context, failedBuilder, result),
      );
}
