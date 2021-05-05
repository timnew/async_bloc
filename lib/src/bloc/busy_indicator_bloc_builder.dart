import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stated_result/stated_result.dart';
import 'package:stated_result/stated_result_builder.dart';

class BusyIndicatorBlocBuilder<B extends BlocBase<Stated>>
    extends BlocBuilder<B, Stated> {
  BusyIndicatorBlocBuilder({
    Key? key,
    B? bloc,
    required ValueWidgetBuilder<bool> builder,
    Widget? child,
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, result) => BusyIndicatorBuilder(
            builder: builder,
            result: result,
            child: child,
          ),
        );

  BusyIndicatorBlocBuilder.circular({
    Key? key,
    B? bloc,
    Duration duration = const Duration(microseconds: 100),
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, result) => BusyIndicatorBuilder.circular(
            result: result,
            duration: duration,
          ),
        );

  BusyIndicatorBlocBuilder.linear({
    Key? key,
    B? bloc,
    Duration duration = const Duration(microseconds: 100),
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, result) => BusyIndicatorBuilder.linear(
            result: result,
            duration: duration,
          ),
        );
}
