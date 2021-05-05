import 'package:flutter/material.dart';

import 'package:stated_result/stated_result.dart';

/// Widget to build progress indicator if result is WatinigResult
class BusyIndicatorBuilder extends StatelessWidget {
  /// StatedResult used to build the progress indicator
  final Stated result;

  /// Optional child
  final Widget? child;

  /// The builder used to build indicator
  final ValueWidgetBuilder<bool> builder;

  /// Invoke [builder] with boolean indicates whether [result] is [WaitingState]
  const BusyIndicatorBuilder({
    Key? key,
    required this.result,
    required this.builder,
    this.child,
  }) : super(key: key);

  /// Render a [CircularProgressIndicator] if [result] is [WaitingState]
  /// User [duration] to control fading
  factory BusyIndicatorBuilder.circular({
    Key? key,
    required Stated result,
    Duration duration = const Duration(microseconds: 100),
  }) =>
      BusyIndicatorBuilder(
        key: key,
        result: result,
        child: const CircularProgressIndicator(),
        builder: _buildAnimationWidget(duration),
      );

  /// Render a [LinearProgressIndicator] if [result] is [WaitingState]
  /// User [duration] to control fading
  factory BusyIndicatorBuilder.linear({
    Key? key,
    required Stated result,
    Duration duration = const Duration(microseconds: 100),
  }) =>
      BusyIndicatorBuilder(
        key: key,
        result: result,
        child: const LinearProgressIndicator(),
        builder: _buildAnimationWidget(duration),
      );

  @override
  Widget build(BuildContext context) =>
      builder(context, result.isWaiting, child);

  static ValueWidgetBuilder<bool> _buildAnimationWidget(Duration duration) =>
      (_, value, child) => AnimatedOpacity(
            opacity: value ? 1 : 0,
            duration: duration,
            curve: Curves.easeInOut,
            child: child,
          );
}
