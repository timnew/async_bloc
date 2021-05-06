import 'package:flutter/widgets.dart';
import 'package:stated_result/stated_builder.dart';
import 'package:stated_result/stated_result.dart';

/// Widget that builds itself based on the value of [ActionResult] or [AsyncActionResult]
class ActionResultBuilder extends StatedBuilder<Never> {
  /// Consume [AsyncActionResult]
  ///
  /// * [idleBuilder] - Builder to be used when [AsyncActionResult.idle] is given.
  /// * [workingBuilder] - Builder to be used when [AsyncActionResult.working] is given.
  /// * [failedBuilder] - Builder to be used when [AsyncActionResult.failed] is given.
  /// * [completedBuilder] - Builder to be used when [AsyncActionResult.completed] is given.
  ///
  /// To consume [ActionResult], use [ActionResultBuilder.sync].
  ActionResultBuilder({
    Key? key,
    required AsyncActionResult result,
    Widget? child,
    required TransitionBuilder idleBuilder,
    required TransitionBuilder workingBuilder,
    required ValueWidgetBuilder<HasError> failedBuilder,
    required TransitionBuilder completedBuilder,
  }) : super(
          key: key,
          stated: result,
          child: child,
          idleBuilder: idleBuilder,
          workingBuilder: workingBuilder,
          errorBuilder: failedBuilder,
          doneBuilder: completedBuilder,
        );

  /// Consume [ActionResult]
  ///
  /// * [failedBuilder] - Builder to be used when [ActionResult.failed] is given.
  /// * [completedBuilder] - Builder to be used when [ActionResult.completed] is given.
  ActionResultBuilder.sync({
    Key? key,
    required ActionResult result,
    Widget? child,
    required ValueWidgetBuilder<HasError> failedBuilder,
    required TransitionBuilder completedBuilder,
  }) : super(
          key: key,
          stated: result,
          child: child,
          errorBuilder: failedBuilder,
          doneBuilder: completedBuilder,
        );
}
