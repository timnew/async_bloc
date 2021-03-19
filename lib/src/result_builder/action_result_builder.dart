import 'package:flutter/widgets.dart';
import 'package:stated_result/stated_result.dart';
import 'package:stated_result/stated_result_builder.dart';

import 'stated_result_builder_base.dart';

/// Widget that builds UI according to the state of [AsyncActionResult] or [ActionResult]
class ActionResultBuilder extends StatedResultBuilderBase<AsyncActionResult> {
  final WidgetBuilder completedBuilder;

  ActionResultBuilder({
    Key? key,
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? busyBuilder,
    FailedResultBuilder? failedBuilder,
    required this.completedBuilder,
    required AsyncActionResult result,
  }) : super(
          key: key,
          pendingBuilder: pendingBuilder,
          busyBuilder: busyBuilder,
          failedBuilder: failedBuilder,
          result: result,
        );

  ActionResultBuilder.sync({
    Key? key,
    FailedResultBuilder? failedBuilder,
    required WidgetBuilder completedBuilder,
    required ActionResult result,
  }) : this(
          key: key,
          completedBuilder: completedBuilder,
          result: result.asAsyncResult(),
        );

  @override
  Widget buildData(BuildContext context) => completedBuilder(context);
}
