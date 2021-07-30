import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stated_result/stated_result_builder.dart';

class ActionBlocConsumer<B extends BlocBase<AsyncActionResult>>
    extends BlocConsumer<B, AsyncActionResult> {
  ActionBlocConsumer({
    Key? key,
    B? bloc,
    Widget? child,
    required TransitionBuilder? idelBuilder,
    required TransitionBuilder workingBuilder,
    required ValueWidgetBuilder<Object> failedBuilder,
    required TransitionBuilder completedBuilder,
    BlocBuilderCondition<AsyncActionResult>? buildWhen,
    required BlocWidgetListener<AsyncActionResult> listener,
    BlocBuilderCondition<AsyncActionResult>? listenWhen,
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, result) => ActionResultBuilder(
            result: result,
            child: child,
            idleBuilder: idelBuilder ?? workingBuilder,
            workingBuilder: workingBuilder,
            failedBuilder: failedBuilder,
            completedBuilder: completedBuilder,
          ),
          buildWhen: buildWhen,
          listener: listener,
          listenWhen: listenWhen,
        );
}
