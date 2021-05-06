import 'package:flutter/material.dart';

import 'package:stated_result/stated_result.dart';

/// Build
class WorkingIndicatorBuilder extends StatelessWidget {
  /// StatedResult used to build the progress indicator
  final Stated stated;

  /// Optional child
  final Widget? child;

  /// The builder used to build indicator
  final ValueWidgetBuilder<bool> builder;

  /// Invoke [builder] with boolean indicates whether [stated] is working or not
  const WorkingIndicatorBuilder({
    Key? key,
    required this.stated,
    required this.builder,
    this.child,
  }) : super(key: key);

  /// Render a [CircularProgressIndicator] if [stated] is working
  /// User [duration] and [curve] to control fading animation
  factory WorkingIndicatorBuilder.circular({
    Key? key,
    required Stated stated,
    Duration duration = const Duration(microseconds: 100),
    Curve curve = Curves.easeInOut,
  }) =>
      WorkingIndicatorBuilder(
        key: key,
        stated: stated,
        child: const CircularProgressIndicator(),
        builder: _buildAnimation(duration, curve),
      );

  /// Render a [LinearProgressIndicator] if [stated] is working.
  /// User [duration] and [curve] to control fading animation
  factory WorkingIndicatorBuilder.linear({
    Key? key,
    required Stated stated,
    Duration duration = const Duration(microseconds: 100),
    Curve curve = Curves.easeInOut,
  }) =>
      WorkingIndicatorBuilder(
        key: key,
        stated: stated,
        child: const LinearProgressIndicator(),
        builder: _buildAnimation(duration, curve),
      );

  @override
  Widget build(BuildContext context) =>
      builder(context, stated.isWorking, child);

  static ValueWidgetBuilder<bool> _buildAnimation(
    Duration duration,
    Curve curve,
  ) =>
      (_, value, child) => AnimatedOpacity(
            opacity: value ? 1 : 0,
            duration: duration,
            curve: curve,
            child: child,
          );
}
