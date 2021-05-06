import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../stated_result.dart';
import '../../stated_result_builder.dart';

class ActionBlocConsumer<B extends BlocBase<AsyncActionResult>>
    extends BlocConsumer<B, AsyncActionResult> {
  ActionBlocConsumer({
    Key? key,
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? waitingBuilder,
    FailedResultBuilder? failedBuilder,
    required WidgetBuilder builder,
    required BlocWidgetListener<AsyncActionResult> listener,
    B? bloc,
    BlocBuilderCondition<AsyncActionResult>? buildWhen,
    BlocBuilderCondition<AsyncActionResult>? listenWhen,
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, result) => ActionResultBuilder(
            result: result,
            idleBuilder: pendingBuilder,
            workingBuilder: waitingBuilder,
            failedBuilder: failedBuilder,
            builder: builder,
          ),
          buildWhen: buildWhen,
          listener: listener,
          listenWhen: listenWhen,
        );
}
