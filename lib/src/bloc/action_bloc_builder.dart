import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stated_result/stated_result_builder.dart';

class ActionBlocBuilder<B extends BlocBase<AsyncActionResult>>
    extends BlocBuilder<B, AsyncActionResult> {
  ActionBlocBuilder({
    Key? key,
    B? bloc,
    Widget? child,
    required TransitionBuilder? idleBuilder,
    required TransitionBuilder workingBuilder,
    required ValueWidgetBuilder<HasError> failedBuilder,
    required TransitionBuilder completedBuilder,
    BlocBuilderCondition<AsyncActionResult>? buildWhen,
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, result) => ActionResultBuilder(
            result: result,
            child: child,
            idleBuilder: idleBuilder ?? workingBuilder,
            workingBuilder: workingBuilder,
            failedBuilder: failedBuilder,
            completedBuilder: completedBuilder,
          ),
          buildWhen: buildWhen,
        );
}
