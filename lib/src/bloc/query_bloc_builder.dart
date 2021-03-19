import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../result.dart';
import '../result_builder.dart';

class QueryBlocBuilder<T, B extends Bloc<Object?, AsyncQueryResult<T>>>
    extends BlocBuilder<B, AsyncQueryResult<T>> {
  QueryBlocBuilder({
    Key? key,
    B? bloc,
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? busyBuilder,
    FailedResultBuilder? failedBuilder,
    required final ValueResultBuilder<T> successfulBuilder,
    BlocBuilderCondition<AsyncQueryResult<T>>? buildWhen,
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
        );
}
