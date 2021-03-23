import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:stated_result/stated_result.dart';
import 'package:stated_result/stated_result_builder.dart';

class QueryListenableBuilder<T> extends StatelessWidget {
  final ValueListenable<AsyncQueryResult<T>> listenable;
  final WidgetBuilder? pendingBuilder;
  final WidgetBuilder? waitingBuilder;
  final FailedResultBuilder? failedBuilder;
  final ValueResultBuilder<T> builder;

  const QueryListenableBuilder({
    Key? key,
    this.pendingBuilder,
    this.waitingBuilder,
    this.failedBuilder,
    required this.builder,
    required this.listenable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<AsyncQueryResult<T>>(
        valueListenable: listenable,
        builder: (context, result, _) => QueryResultBuilder<T>(
          result: result,
          pendingBuilder: pendingBuilder,
          waitingBuilder: waitingBuilder,
          failedBuilder: failedBuilder,
          builder: builder,
        ),
      );
}
