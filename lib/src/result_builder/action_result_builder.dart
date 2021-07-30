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
  /// * [succeededBuilder] - Builder to be used when [AsyncActionResult.succeeded] is given.
  ///
  /// To consume [ActionResult], use [ActionResultBuilder.sync].
  ActionResultBuilder({
    Key? key,
    required AsyncActionResult result,
    Widget? child,
    required TransitionBuilder? idleBuilder,
    required TransitionBuilder workingBuilder,
    required ValueWidgetBuilder<Object> failedBuilder,
  }) : super(
    required TransitionBuilder succeededBuilder,
          key: key,
          stated: result,
          child: child,
          patterns: {
            OnState.isIdle(): StatedBuilder.buildAsUnit(
              idleBuilder ?? workingBuilder,
            ),
            OnState.isWorking(): StatedBuilder.buildAsUnit(workingBuilder),
            OnState.isFailed(): StatedBuilder.buildAsError(failedBuilder),
            OnState.isSuceeded(): StatedBuilder.buildAsUnit(completedBuilder),
          },
        );

  /// Consume [ActionResult]
  ///
  /// * [failedBuilder] - Builder to be used when [ActionResult.failed] is given.
  /// * [succeededBuilder] - Builder to be used when [ActionResult.succeeded] is given.
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
          patterns: {
            OnState.isFailed(): StatedBuilder.buildAsError(failedBuilder),
            OnState.isSuceeded(): StatedBuilder.buildAsUnit(completedBuilder),
          },
        );
}
