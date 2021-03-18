import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../result.dart';
import '../result_builder.dart';

class QueryBlocConsumer<T, B extends Bloc<Object?, AsyncQueryResult<T>>>
    extends BlocConsumer<B, AsyncQueryResult<T>> {
  QueryBlocConsumer({
    Key? key,
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? busyBuilder,
    FailedResultBuilder? failedBuilder,
    required final ValueResultBuilder<T> successfulBuilder,
    required BlocWidgetListener<AsyncQueryResult<T>> listener,
    B? bloc,
    BlocBuilderCondition<AsyncQueryResult<T>>? buildWhen,
    BlocBuilderCondition<AsyncQueryResult<T>>? listenWhen,
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, result) => QueryResultBuilder(
            result: result,
            pendingBuilder: pendingBuilder,
            busyBuilder: busyBuilder,
            failedBuilder: failedBuilder,
            successfulBuilder: successfulBuilder,
          ),
          buildWhen: buildWhen,
          listener: listener,
          listenWhen: listenWhen,
        );
}
