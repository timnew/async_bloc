import 'package:flutter/widgets.dart';
import 'package:stated_result/stated_builder.dart';
import 'package:stated_result/stated_result.dart';

/// Widget that builds itself based on the value of [ActionResult] or [AsyncActionResult]
class ActionResultBuilder extends StatedBuilder<Stated> {
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
    required ValueWidgetBuilder<Object> failedBuilder,
    required TransitionBuilder completedBuilder,
  }) : super(
          key: key,
          stated: result,
          child: child,
          stateBuilders: [
            OnState.unit(idleBuilder, criteria: CanBuild.isIdle),
            OnState.unit(workingBuilder, criteria: CanBuild.isWorking),
            OnState.error(failedBuilder, criteria: CanBuild.isFailed),
            OnState.unit(completedBuilder, criteria: CanBuild.isSuceeded),
          ],
        );

  /// Consume [ActionResult]
  ///
  /// * [failedBuilder] - Builder to be used when [ActionResult.failed] is given.
  /// * [completedBuilder] - Builder to be used when [ActionResult.completed] is given.
  ActionResultBuilder.sync({
    Key? key,
    required ActionResult result,
    Widget? child,
    required ValueWidgetBuilder<Object> failedBuilder,
    required TransitionBuilder completedBuilder,
  }) : super(
          key: key,
          stated: result,
          child: child,
          stateBuilders: [
            OnState.error(failedBuilder, criteria: CanBuild.isFailed),
            OnState.unit(completedBuilder, criteria: CanBuild.isSuceeded),
          ],
        );
}
