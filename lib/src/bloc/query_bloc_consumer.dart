import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stated_result/stated_builder.dart';
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
    required ValueWidgetBuilder<T> succeededBuilder,
    BlocBuilderCondition<AsyncQueryResult<T>>? buildWhen,
    ContextConsumer? idleConsumer,
    ValueConsumer<T>? presetConsumer,
    ContextConsumer? workingConsumer,
    ValueConsumer<Object>? failedConsumer,
    ValueConsumer<T>? succeededConsumer,
    BlocBuilderCondition<AsyncQueryResult<T>>? listenWhen,
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, result) => QueryResultBuilder<T>(
            result: result,
            child: child,
            idleBuilder: idleBuilder ?? workingBuilder,
            presetBuilder: presetBuilder ?? succeededBuilder,
            workingBuilder: workingBuilder,
            failedBuilder: failedBuilder,
            succeededBuilder: succeededBuilder,
          ),
          buildWhen: buildWhen,
          listener: StatedConsumer((b) => b
            ..unit(OnState<IdleState>(), idleConsumer)
            ..value(OnState<IdleValueState>(), presetConsumer)
            ..unit(OnState.isWorking(), workingConsumer)
            ..error(OnState.isFailed(), failedConsumer)
            ..value(OnState.isSuceeded(), succeededConsumer)),
          listenWhen: listenWhen,
        );
}
