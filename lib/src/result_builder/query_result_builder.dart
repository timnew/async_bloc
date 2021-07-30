import 'package:flutter/widgets.dart';
import 'package:stated_result/stated_builder.dart';
import 'package:stated_result/stated_result.dart';

/// Widget that builds itself based on the value of [QueryResult] or [AsyncQueryResult]
class QueryResultBuilder<T> extends StatedBuilder<Stated> {
  /// Consume [AsyncQueryResult]
  ///
  /// * [idleBuilder] - Builder to be used when [AsyncQueryResult.idle] is given.
  /// * [presetBuilder] - Optional builder to be used [AsyncQueryResult.preset] is given.
  /// * [workingBuilder] - Builder to be used when [AsyncQueryResult.working] is given.
  /// * [failedBuilder] - Builder to be used when [AsyncQueryResult.failed] is given.
  /// * [completedBuilder] - Builder to be used when [AsyncQueryResult.completed] is given.
  ///
  /// To consume [ActionResult], use [ActionResultBuilder.sync].
  QueryResultBuilder({
    Key? key,
    required AsyncQueryResult<T> result,
    Widget? child,
    required TransitionBuilder? idleBuilder,
    ValueWidgetBuilder<T>? presetBuilder,
    required TransitionBuilder workingBuilder,
    required ValueWidgetBuilder<Object> failedBuilder,
    required ValueWidgetBuilder<T> completedBuilder,
  }) : super(
          key: key,
          stated: result,
          child: child,
          stateBuilders: [
            OnState.unit(
              idleBuilder ?? workingBuilder,
              criteria: CanBuild.isIdle,
            ),
            OnState<T>.value(
              presetBuilder ?? completedBuilder,
              criteria: CanBuild.isType<IdleValueState>(),
            ),
            OnState.unit(workingBuilder, criteria: CanBuild.isWorking),
            OnState.error(failedBuilder, criteria: CanBuild.isFailed),
            OnState<T>.value(completedBuilder, criteria: CanBuild.isSuceeded),
          ],
        );

  /// Consume [ActionResult]
  ///
  /// * [failedBuilder] - Builder to be used when [ActionResult.failed] is given.
  /// * [doneBuilder] - Builder to be used when [ActionResult.completed] is given.
  QueryResultBuilder.sync({
    Key? key,
    required QueryResult<T> result,
    Widget? child,
    required ValueWidgetBuilder<Object> failedBuilder,
    required ValueWidgetBuilder<T> completedBuilder,
  }) : super(
          key: key,
          stated: result,
          child: child,
          stateBuilders: [
            OnState.error(failedBuilder, criteria: CanBuild.isFailed),
            OnState<T>.value(completedBuilder, criteria: CanBuild.isSuceeded),
          ],
        );
}
