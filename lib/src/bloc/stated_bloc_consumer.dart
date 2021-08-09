import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stated_result/stated_builder.dart';
import 'package:stated_result/stated_result_builder.dart';

class StatedBlocConsumer<B extends BlocBase<TS>, TS extends Stated>
    extends BlocConsumer<B, TS> {
  StatedBlocConsumer.patterns({
    Key? key,
    B? bloc,
    Widget? child,
    required Map<OnState, ValueWidgetBuilder<Stated>> patterns,
    BlocBuilderCondition<TS>? buildWhen,
    required BlocWidgetListener<TS> listener,
    BlocListenerCondition<TS>? listenWhen,
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, stated) => StatedBuilder.patterns(
            stated: stated,
            patterns: patterns,
          ),
          buildWhen: buildWhen,
          listener: listener,
          listenWhen: listenWhen,
        );

  StatedBlocConsumer({
    Key? key,
    B? bloc,
    Widget? child,
    required CallBuilder<StatedBuilderPatternBuilder<TS>> buildPatternDefs,
    BlocBuilderCondition<TS>? buildWhen,
    required CallBuilder<StatedConsumerPatternBuilder<TS>> listenPatternDefs,
    BlocListenerCondition<TS>? listenWhen,
  }) : super(
          key: key,
          bloc: bloc,
          builder: (context, stated) => StatedBuilder(
            stated: stated,
            patternDefs: buildPatternDefs,
          ),
          buildWhen: buildWhen,
          listener: StatedConsumer(listenPatternDefs),
          listenWhen: listenWhen,
        );
}
