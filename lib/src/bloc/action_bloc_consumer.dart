import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stated_result/stated_result_builder.dart';

class ActionBlocConsumer<B extends BlocBase<AsyncActionResult>>
    extends BlocConsumer<B, AsyncActionResult> {
  ActionBlocConsumer({
    Key? key,
    B? bloc,
    Widget? child,
    required TransitionBuilder? idleBuilder,
    required TransitionBuilder workingBuilder,
    required ValueWidgetBuilder<Object> failedBuilder,
    required TransitionBuilder suceededBuilder,
    BlocBuilderCondition<AsyncActionResult>? buildWhen,
    required BlocWidgetListener<AsyncActionResult> listener,
    BlocBuilderCondition<AsyncActionResult>? listenWhen,
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, result) => ActionResultBuilder(
            result: result,
            child: child,
            idleBuilder: idleBuilder ?? workingBuilder,
            workingBuilder: workingBuilder,
            failedBuilder: failedBuilder,
            succeededBuilder: suceededBuilder,
          ),
          buildWhen: buildWhen,
          listener: listener,
          listenWhen: listenWhen,
        );
}
