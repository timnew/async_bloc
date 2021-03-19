import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../stated_result.dart';
import '../stated_result_flutter.dart';

class ActionBlocConsumer<B extends Bloc<Object?, AsyncActionResult>>
    extends BlocConsumer<B, AsyncActionResult> {
  ActionBlocConsumer({
    Key? key,
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? busyBuilder,
    FailedResultBuilder? failedBuilder,
    required WidgetBuilder completedBuilder,
    required BlocWidgetListener<AsyncActionResult> listener,
    B? bloc,
    BlocBuilderCondition<AsyncActionResult>? buildWhen,
    BlocBuilderCondition<AsyncActionResult>? listenWhen,
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, result) => ActionResultBuilder(
            result: result,
            pendingBuilder: pendingBuilder,
            busyBuilder: busyBuilder,
            failedBuilder: failedBuilder,
            completedBuilder: completedBuilder,
          ),
          buildWhen: buildWhen,
          listener: listener,
          listenWhen: listenWhen,
        );
}
