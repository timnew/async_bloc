import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stated_result/stated_builder.dart';
import 'package:stated_result/stated_result_builder.dart';

class StatedBlocBuilder<B extends BlocBase<TS>, TS extends Stated>
    extends BlocBuilder<B, TS> {
  StatedBlocBuilder.patterns({
    Key? key,
    B? bloc,
    Widget? child,
    required Map<OnState<TS>, ValueWidgetBuilder<Stated>> patterns,
    BlocBuilderCondition<TS>? buildWhen,
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, stated) => StatedBuilder.patterns(
            stated: stated,
            patterns: patterns,
          ),
          buildWhen: buildWhen,
        );

  StatedBlocBuilder({
    Key? key,
    B? bloc,
    Widget? child,
    required CallBuilder<StatedBuilderPatternBuilder<TS>> patternDefs,
    BlocBuilderCondition<TS>? buildWhen,
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, stated) => StatedBuilder(
            stated: stated,
            patternDefs: patternDefs,
          ),
          buildWhen: buildWhen,
        );
}
