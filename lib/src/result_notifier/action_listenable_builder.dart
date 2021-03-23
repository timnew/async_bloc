import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:stated_result/stated_result.dart';
import 'package:stated_result/stated_result_builder.dart';

class ActionListenableBuilder extends StatelessWidget {
  final ValueListenable<AsyncActionResult> listenable;
  final WidgetBuilder? pendingBuilder;
  final WidgetBuilder? waitingBuilder;
  final FailedResultBuilder? failedBuilder;
  final WidgetBuilder builder;

  const ActionListenableBuilder({
    Key? key,
    this.pendingBuilder,
    this.waitingBuilder,
    this.failedBuilder,
    required this.builder,
    required this.listenable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<AsyncActionResult>(
        valueListenable: listenable,
        builder: (context, result, _) => ActionResultBuilder(
          result: result,
          pendingBuilder: pendingBuilder,
          waitingBuilder: waitingBuilder,
          failedBuilder: failedBuilder,
          builder: builder,
        ),
      );
}
