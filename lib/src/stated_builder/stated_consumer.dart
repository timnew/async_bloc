import 'package:flutter/widgets.dart';
import 'package:stated_result/stated.dart';

import 'call_builder.dart';

typedef void ContextConsumer(BuildContext context);
typedef void ValueConsumer<T>(BuildContext context, T value);

class StatedConsumer<TS extends Stated> {
  final Map<OnState<TS>, ValueConsumer<TS>> patterns;

  const StatedConsumer.patterns(this.patterns);

  StatedConsumer(CallBuilder<StatedConsumerPatternBuilder<TS>> patternDefs)
      : this.patterns(
          StatedConsumerPatternBuilder<TS>(patternDefs).build(),
        );

  void call(BuildContext context, TS stated) =>
      stated.matchPattern<ValueConsumer<TS>?>(patterns)?.call(context, stated);
}

class StatedConsumerPatternBuilder<TS extends Stated> {
  final CallBuilder<StatedConsumerPatternBuilder<TS>> buildAction;

  bool _hasRan = false;
  late Map<OnState<TS>, ValueConsumer<TS>> _patterns;

  StatedConsumerPatternBuilder(this.buildAction);

  Map<OnState<TS>, ValueConsumer<TS>> build() {
    if (!_hasRan) {
      _patterns = {};
      buildAction(this);
      _hasRan = true;
    }

    return _patterns;
  }

  void _add(OnState<TS> onState, ValueConsumer<TS> pattern) {
    _patterns[onState] = pattern;
  }

  void unit(OnState<TS> onState, ContextConsumer? builder) {
    if (builder != null) {
      _add(
        onState,
        (c, _) => builder(c),
      );
    }
  }

  void value<T>(OnState<TS> onState, ValueConsumer<T>? builder) {
    if (builder != null) {
      _add(
        onState,
        (c, s) => builder(c, s.extractValue()),
      );
    }
  }

  void error(OnState<TS> onState, ValueConsumer<Object>? builder) {
    if (builder != null) {
      _add(
        onState,
        (c, s) => builder(c, s.extractError()),
      );
    }
  }
}
