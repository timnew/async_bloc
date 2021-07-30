import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stated_result/stated_builder.dart';
import 'package:stated_result/stated_custom.dart';

class StatedBuilder<TS extends Stated> extends StatelessWidget {
  final TS stated;
  final Widget? child;
  final Map<OnState<TS>, ValueWidgetBuilder<TS>> patterns;

  const StatedBuilder({
    Key? key,
    required this.stated,
    this.child,
    required this.patterns,
  }) : super(key: key);

  StatedBuilder.patternBuilder({
    Key? key,
    required TS stated,
    Widget? child,
    required void patterns(StatedeBuilderPatternsBuilder<TS> b),
  }) : this(
          key: key,
          stated: stated,
          child: child,
          patterns: StatedeBuilderPatternsBuilder(patterns).build(),
        );

  @override
  Widget build(BuildContext context) => stated
      .matchPattern<ValueWidgetBuilder<TS>>(patterns)
      .call(context, stated, child);
}

class StatedeBuilderPatternsBuilder<TS extends Stated> {
  final Map<OnState<TS>, ValueWidgetBuilder<TS>> patterns = {};

  StatedeBuilderPatternsBuilder(
    void action(StatedeBuilderPatternsBuilder<TS> b),
  ) {
    action(this);
  }

  void unit(OnState<TS> onState, TransitionBuilder builder) {
    patterns[onState] = (c, _, child) => builder(c, child);
  }

  void value<T>(OnState<TS> onState, ValueWidgetBuilder<T> builder) {
    patterns[onState] =
        (c, stated, child) => builder(c, stated.extractValue(), child);
  }

  void error(OnState<TS> onState, ValueWidgetBuilder<Object> builder) {
    patterns[onState] =
        (c, stated, child) => builder(c, stated.extractError(), child);
  }

  Map<OnState<TS>, ValueWidgetBuilder<TS>> build() => patterns;
}
