import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stated_result/stated_result_builder.dart';

class QueryBlocConsumer<B extends BlocBase<AsyncQueryResult<T>>, T>
    extends BlocConsumer<B, AsyncQueryResult<T>> {
  QueryBlocConsumer({
    Key? key,
    B? bloc,
    Widget? child,
    required TransitionBuilder? idleBuilder,
    ValueWidgetBuilder<T>? presetBuilder,
    required TransitionBuilder workingBuilder,
    required ValueWidgetBuilder<Object> failedBuilder,
    required ValueWidgetBuilder<T> completedBuilder,
    BlocBuilderCondition<AsyncQueryResult<T>>? buildWhen,
    required BlocWidgetListener<AsyncQueryResult<T>> listener,
    BlocBuilderCondition<AsyncQueryResult<T>>? listenWhen,
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, result) => QueryResultBuilder<T>(
            result: result,
            child: child,
            idleBuilder: idleBuilder ?? workingBuilder,
            presetBuilder: presetBuilder ?? completedBuilder,
            workingBuilder: workingBuilder,
            failedBuilder: failedBuilder,
            completedBuilder: completedBuilder,
          ),
          buildWhen: buildWhen,
          listener: listener,
          listenWhen: listenWhen,
        );
}
