import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../stated_result.dart';
import '../../stated_result_builder.dart';

class QueryBlocConsumer<T, B extends Bloc<Object?, AsyncQueryResult<T>>>
    extends BlocConsumer<B, AsyncQueryResult<T>> {
  QueryBlocConsumer({
    Key? key,
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? waitingBuilder,
    FailedResultBuilder? failedBuilder,
    required final ValueResultBuilder<T> builder,
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
            waitingBuilder: waitingBuilder,
            failedBuilder: failedBuilder,
            builder: builder,
          ),
          buildWhen: buildWhen,
          listener: listener,
          listenWhen: listenWhen,
        );
}
