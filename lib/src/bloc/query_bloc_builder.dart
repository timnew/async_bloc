import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stated_result/stated_result_builder.dart';

class QueryBlocBuilder<B extends BlocBase<AsyncQueryResult<T>>, T>
    extends BlocBuilder<B, AsyncQueryResult<T>> {
  QueryBlocBuilder({
    Key? key,
    B? bloc,
    Widget? child,
    required TransitionBuilder? idleBuilder,
    ValueWidgetBuilder<T>? presetBuilder,
    required TransitionBuilder workingBuilder,
    required ValueWidgetBuilder<Object> failedBuilder,
    required ValueWidgetBuilder<T> succeededBuilder,
    BlocBuilderCondition<AsyncQueryResult<T>>? buildWhen,
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, result) => QueryResultBuilder<T>(
            result: result,
            child: child,
            idleBuilder: idleBuilder,
            presetBuilder: presetBuilder,
            workingBuilder: workingBuilder,
            failedBuilder: failedBuilder,
            succeededBuilder: succeededBuilder,
          ),
          buildWhen: buildWhen,
        );
}
