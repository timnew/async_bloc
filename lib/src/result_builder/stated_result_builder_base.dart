import 'package:flutter/widgets.dart';

import 'package:stated_result/src/result/stated_result.dart';
import 'package:stated_result/src/result/util.dart';
import 'package:stated_result/stated_result.dart';
import 'package:stated_result/stated_result_builder.dart';

/// @nodoc
abstract class StatedResultBuilderBase<TS extends StatedResult>
    extends StatelessWidget {
  /// Builder to be used when [PendingResult] is given.
  ///
  /// Default pending builder provided by [DefaultPendingResultBuilder] will be used if not explicitly given.
  final WidgetBuilder? pendingBuilder;

  /// Builder to be used when [BusyResult] is given.
  ///
  /// Default pending builder provided by [DefaultBusyResultBuilder] will be used if not explicitly given.
  final WidgetBuilder? busyBuilder;

  /// Builder to be used when [FailedResult] is given.
  ///
  /// Default pending builder provided by [DefaultFailedResultBuilder] will be used if not explicitly given.
  final FailedResultBuilder? failedBuilder;

  /// Result used to build UI
  final TS result;

  /// @nodoc
  StatedResultBuilderBase({
    Key? key,
    this.pendingBuilder,
    this.busyBuilder,
    this.failedBuilder,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => result.completeMapOr(
        pendingResult: () =>
            DefaultPendingResultBuilder.ensureBuild(context, pendingBuilder),
        busyResult: () =>
            DefaultBusyResultBuilder.ensureBuild(context, busyBuilder),
        failedResult: (result) => DefaultFailedResultBuilder.ensureBuild(
            context, failedBuilder, result),
        completedResult: () => buildData(context),
        hasValue: (_) => buildData(context),
      );

  @protected
  Widget buildData(BuildContext context);
}
