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
    required TransitionBuilder succeededBuilder,
  }) : super(
          key: key,
          stated: result,
          child: child,
          patternDefs: (b) => b
            ..unit(OnState.isIdle(), idleBuilder ?? workingBuilder)
            ..unit(OnState.isWorking(), workingBuilder)
            ..error(OnState.isFailed(), failedBuilder)
            ..unit(OnState.isSuceeded(), succeededBuilder),
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
    required TransitionBuilder succeededBuilder,
  }) : super(
          key: key,
          stated: result,
          child: child,
          patternDefs: (b) => b
            ..error(OnState.isFailed(), failedBuilder)
            ..unit(OnState.isSuceeded(), succeededBuilder),
        );
}
