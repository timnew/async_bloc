import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../stated_result.dart';
import '../../stated_result_builder.dart';

class ActionListenableBuilder extends StatelessWidget {
  final ValueListenable<AsyncActionResult> valueListenable;
  final WidgetBuilder? pendingBuilder;
  final WidgetBuilder? busyBuilder;
  final FailedResultBuilder? failedBuilder;
  final WidgetBuilder completedBuilder;

  const ActionListenableBuilder({
    Key? key,
    this.pendingBuilder,
    this.busyBuilder,
    this.failedBuilder,
    required this.completedBuilder,
    required this.valueListenable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<AsyncActionResult>(
        valueListenable: valueListenable,
        builder: (context, result, _) => ActionResultBuilder(
          result: result,
          pendingBuilder: pendingBuilder,
          busyBuilder: busyBuilder,
          failedBuilder: failedBuilder,
          completedBuilder: completedBuilder,
        ),
      );
}
