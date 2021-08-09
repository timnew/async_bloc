import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stated_result/stated_builder.dart';
import 'package:stated_result/stated_custom.dart';

import 'call_builder.dart';

class StatedBuilder<TS extends Stated> extends StatelessWidget {
  final TS stated;
  final Widget? child;
  final Map<OnState, ValueWidgetBuilder<Stated>> patterns;

  const StatedBuilder.patterns({
    Key? key,
    required this.stated,
    this.child,
    required this.patterns,
  }) : super(key: key);

  StatedBuilder({
    Key? key,
    required TS stated,
    Widget? child,
    required CallBuilder<StatedBuilderPatternBuilder<TS>> patternDefs,
  }) : this.patterns(
          key: key,
          stated: stated,
          child: child,
          patterns: StatedBuilderPatternBuilder<TS>(patternDefs).build(),
        );

  @override
  Widget build(BuildContext context) => stated
      .matchPattern<ValueWidgetBuilder<TS>>(patterns)
      .call(context, stated, child);
}

class StatedBuilderPatternBuilder<TS extends Stated> {
  final CallBuilder<StatedBuilderPatternBuilder<TS>> buildAction;

  bool _hasRan = false;
  late Map<OnState<TS>, ValueWidgetBuilder<Stated>> _patterns;

  StatedBuilderPatternBuilder(this.buildAction);

  Map<OnState<TS>, ValueWidgetBuilder<Stated>> build() {
    if (!_hasRan) {
      _patterns = {};
      buildAction(this);
      _hasRan = true;
    }

    return _patterns;
  }

  void _add(OnState<TS> onState, ValueWidgetBuilder<Stated> pattern) {
    _patterns[onState] = pattern;
  }

  void unit(OnState<TS> onState, TransitionBuilder builder) {
    _add(
      onState,
      (c, _, child) => builder(c, child),
    );
  }

  void value<T>(OnState<TS> onState, ValueWidgetBuilder<T> builder) {
    _add(
      onState,
      (c, stated, child) => builder(c, stated.extractValue(), child),
    );
  }

  void error(OnState<TS> onState, ValueWidgetBuilder<Object> builder) {
    _add(onState,
        (c, stated, child) => builder(c, stated.extractError(), child));
  }
}
