import 'package:async_bloc/result/async_action_result.dart';
import 'package:async_bloc/result_flutter/default_busy_result_builder.dart';
import 'package:async_bloc/result_flutter/default_failed_result_builder.dart';
import 'package:async_bloc/result_flutter/default_pending_result_builder.dart';
import 'package:async_bloc/result_flutter/function_types.dart';
import 'package:flutter/widgets.dart';

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
