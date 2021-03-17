import 'package:async_bloc/result/async_query_result.dart';
import 'package:flutter/widgets.dart';

import 'default_busy_result_builder.dart';
import 'default_failed_result_builder.dart';
import 'default_pending_result_builder.dart';
import 'function_types.dart';

class QueryResultBuilder<T> extends StatelessWidget {
  final WidgetBuilder? pendingBuilder;
  final WidgetBuilder? busyBuilder;
  final FailedResultBuilder? failedBuilder;
  final ValueResultBuilder<T> successfulBuilder;
  final AsyncQueryResult<T> result;

  const QueryResultBuilder({
    Key? key,
    this.pendingBuilder,
    this.busyBuilder,
    this.failedBuilder,
    required this.successfulBuilder,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => result.map(
        pending: () =>
            DefaultPendingResultBuilder.ensureBuild(context, pendingBuilder),
        busy: () => DefaultBusyResultBuilder.ensureBuild(context, busyBuilder),
        failed: (error, stackTrace) => DefaultFailedResultBuilder.ensureBuild(
            context, failedBuilder, error, stackTrace),
        defaultValue: (value) => successfulBuilder(context, value),
        succeeded: (value) => successfulBuilder(context, value),
      );
}
