import 'package:flutter/widgets.dart';
import 'package:stated_result/stated_builder.dart';
import 'package:stated_result/stated_result.dart';

/// Widget that builds itself based on the value of [QueryResult] or [AsyncQueryResult]
class QueryResultBuilder<T> extends StatedBuilder<T> {
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
    required TransitionBuilder idleBuilder,
    ValueWidgetBuilder<T>? presetBuilder,
    required TransitionBuilder workingBuilder,
    required ValueWidgetBuilder<HasError> failedBuilder,
    required ValueWidgetBuilder<T> completedBuilder,
  }) : super(
          key: key,
          stated: result,
          child: child,
          idleBuilder: idleBuilder,
          idleValueBuilder: presetBuilder,
          workingBuilder: workingBuilder,
          errorBuilder: failedBuilder,
          doneValueBuilder: completedBuilder,
        );

  /// Consume [ActionResult]
  ///
  /// * [failedBuilder] - Builder to be used when [ActionResult.failed] is given.
  /// * [doneBuilder] - Builder to be used when [ActionResult.completed] is given.
  QueryResultBuilder.sync({
    Key? key,
    required QueryResult<T> result,
    Widget? child,
    required ValueWidgetBuilder<HasError> failedBuilder,
    required ValueWidgetBuilder<T> completedBuilder,
  }) : super(
          key: key,
          stated: result,
          child: child,
          errorBuilder: failedBuilder,
          doneValueBuilder: completedBuilder,
        );
}
