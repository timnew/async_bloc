import 'package:flutter/widgets.dart';
import 'package:stated_result/src/result/stated_result.dart';
import 'package:stated_result/stated_result.dart';

import 'default_failed_result_builder.dart';
import 'default_pending_result_builder.dart';
import 'default_waiting_result_builder.dart';
import 'widget_builders.dart';

abstract class ResultFutureBuilderBase<TS extends StatedResult>
    extends StatelessWidget {
  final Future<TS> future;

  final WidgetBuilder? pendingBuilder;
  final WidgetBuilder? waitingBuilder;
  final FailedResultBuilder? failedBuilder;

  ResultFutureBuilderBase({
    required Key? key,
    required this.future,
    required this.pendingBuilder,
    required this.waitingBuilder,
    required this.failedBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder<TS>(
        future: future,
        builder: _build,
      );

  Widget _build(BuildContext context, AsyncSnapshot<TS> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return DefaultPendingResultBuilder.ensureBuild(context, pendingBuilder);
      case ConnectionState.waiting:
        return DefaultWaitingResultBuilder.ensureBuild(context, waitingBuilder);
      case ConnectionState.active:
        throw StateError("Impossible state");
      case ConnectionState.done:
        if (snapshot.hasError) {
          return DefaultFailedResultBuilder.ensureBuild(
            context,
            failedBuilder,
            ActionResult.failed(snapshot.error!).asFailed(),
          );
        }

        if (!snapshot.hasData) {
          throw StateError("future doesn't have data");
        }

        return buildData(context, snapshot.data!);
    }
  }

  @protected
  Widget buildData(BuildContext context, TS data);
}
