import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:stated_result/stated_result.dart';
import 'package:stated_result/stated_result_builder.dart';

class QueryListenableBuilder<T> extends StatelessWidget {
  final ValueListenable<AsyncQueryResult<T>> valueListenable;
  final WidgetBuilder? pendingBuilder;
  final WidgetBuilder? busyBuilder;
  final FailedResultBuilder? failedBuilder;
  final ValueResultBuilder<T> successfulBuilder;

  const QueryListenableBuilder({
    Key? key,
    this.pendingBuilder,
    this.busyBuilder,
    this.failedBuilder,
    required this.successfulBuilder,
    required this.valueListenable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<AsyncQueryResult<T>>(
        valueListenable: valueListenable,
        builder: (context, result, _) => QueryResultBuilder<T>(
          result: result,
          pendingBuilder: pendingBuilder,
          busyBuilder: busyBuilder,
          failedBuilder: failedBuilder,
          successfulBuilder: successfulBuilder,
        ),
      );
}
