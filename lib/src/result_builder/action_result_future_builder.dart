import 'package:flutter/widgets.dart';

import 'package:stated_result/stated_result.dart';

import 'default_failed_result_builder.dart';
import 'widget_builders.dart';
import 'result_future_builder_base.dart';

class ActionResultFutureBuilder extends ResultFutureBuilderBase<ActionResult> {
  final WidgetBuilder builder;

  ActionResultFutureBuilder({
    Key? key,
    required Future<ActionResult> future,
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

  ActionResultFutureBuilder.fromFuture({
    Key? key,
    required Future future,
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? waitingBuilder,
    FailedResultBuilder? failedBuilder,
    required WidgetBuilder builder,
  }) : this(
          key: key,
          future: future.asActionResult(),
          pendingBuilder: pendingBuilder,
          waitingBuilder: waitingBuilder,
          failedBuilder: failedBuilder,
          builder: builder,
        );

  @override
  Widget buildData(BuildContext context, ActionResult data) => data.map(
        completed: () => builder(context),
        failed: (result) => DefaultFailedResultBuilder.ensureBuild(
            context, failedBuilder, result),
      );
}
