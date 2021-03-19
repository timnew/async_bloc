import 'package:flutter/widgets.dart';

import '../../stated_result.dart';

import 'default_busy_result_builder.dart';
import 'default_failed_result_builder.dart';
import 'default_pending_result_builder.dart';
import 'widget_builders.dart';

class QueryResultBuilder<T> extends StatelessWidget {
  final WidgetBuilder? pendingBuilder;
  final WidgetBuilder? busyBuilder;
  final FailedResultBuilder? failedBuilder;
  final ValueResultBuilder<T> valueBuilder;
  final AsyncQueryResult<T> result;

  const QueryResultBuilder({
    Key? key,
    this.pendingBuilder,
    this.busyBuilder,
    this.failedBuilder,
    required this.valueBuilder,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => result.map(
        pending: () =>
            DefaultPendingResultBuilder.ensureBuild(context, pendingBuilder),
        busy: () => DefaultBusyResultBuilder.ensureBuild(context, busyBuilder),
        failed: (error, stackTrace) => DefaultFailedResultBuilder.ensureBuild(
            context, failedBuilder, error, stackTrace),
        initialValue: (value) => valueBuilder(context, value),
        succeeded: (value) => valueBuilder(context, value),
      );
}
