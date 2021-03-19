import 'package:flutter/widgets.dart';

import '../result.dart';
import 'default_busy_result_builder.dart';
import 'default_failed_result_builder.dart';
import 'default_pending_result_builder.dart';
import 'function_types.dart';

class ActionResultBuilder extends StatelessWidget {
  final WidgetBuilder? pendingBuilder;
  final WidgetBuilder? busyBuilder;
  final FailedResultBuilder? failedBuilder;
  final WidgetBuilder completedBuilder;
  final AsyncActionResult result;

  const ActionResultBuilder({
    Key? key,
    this.pendingBuilder,
    this.busyBuilder,
    this.failedBuilder,
    required this.completedBuilder,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => result.map(
        pending: () =>
            DefaultPendingResultBuilder.ensureBuild(context, pendingBuilder),
        busy: () => DefaultBusyResultBuilder.ensureBuild(context, busyBuilder),
        failed: (error, stackTrace) => DefaultFailedResultBuilder.ensureBuild(
            context, failedBuilder, error, stackTrace),
        completed: () => completedBuilder(context),
      );
}
