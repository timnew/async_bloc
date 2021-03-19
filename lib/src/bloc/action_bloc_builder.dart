import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../stated_result.dart';
import '../../stated_result_flutter.dart';

class ActionBlocBuilder<B extends Bloc<Object?, AsyncActionResult>>
    extends BlocBuilder<B, AsyncActionResult> {
  ActionBlocBuilder({
    Key? key,
    B? bloc,
    WidgetBuilder? pendingBuilder,
    WidgetBuilder? busyBuilder,
    FailedResultBuilder? failedBuilder,
    required WidgetBuilder completedBuilder,
    BlocBuilderCondition<AsyncActionResult>? buildWhen,
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
        );
}
