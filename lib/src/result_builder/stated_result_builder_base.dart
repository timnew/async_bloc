import 'package:flutter/widgets.dart';
import 'package:stated_result/src/states/stated_result.dart';

import 'package:stated_result/src/states/util.dart';
import 'package:stated_result/stated_result.dart';

import 'default_waiting_result_builder.dart';
import 'default_failed_result_builder.dart';
import 'default_pending_result_builder.dart';
import 'widget_builders.dart';

/// @nodoc
abstract class StatedResultBuilderBase<TS extends StatedResult>
    extends StatelessWidget {
  /// Builder to be used when [PendingResult] is given.
  ///
  /// Default pending builder provided by [DefaultPendingResultBuilder] will be used if not explicitly given.
  final WidgetBuilder? pendingBuilder;

  /// Builder to be used when [WaitingResult] is given.
  ///
  /// Default pending builder provided by [DefaultWaitingResultBuilder] will be used if not explicitly given.
  final WidgetBuilder? waitingBuilder;

  /// Builder to be used when [FailedResult] is given.
  ///
  /// Default pending builder provided by [DefaultFailedResultBuilder] will be used if not explicitly given.
  final FailedResultBuilder? failedBuilder;

  /// Result used to build UI
  final TS result;

  /// @nodoc
  StatedResultBuilderBase({
    required Key? key,
    required this.pendingBuilder,
    required this.waitingBuilder,
    required this.failedBuilder,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => result.unsafeMapOr(
        pendingResult: () =>
            DefaultPendingResultBuilder.ensureBuild(context, pendingBuilder),
        waitingResult: () =>
            DefaultWaitingResultBuilder.ensureBuild(context, waitingBuilder),
        failedResult: (result) => DefaultFailedResultBuilder.ensureBuild(
            context, failedBuilder, result),
        completedResult: () => buildData(context),
        hasValue: (_) => buildData(context),
      );

  @protected
  Widget buildData(BuildContext context);
}
