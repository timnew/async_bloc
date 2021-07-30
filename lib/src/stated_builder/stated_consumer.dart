import 'package:flutter/material.dart';

import '../../stated.dart';

typedef void ContextConsumer(BuildContext context);
typedef void ValueConsumer<T>(BuildContext context, T value);

class StatedConsumer<TS extends Stated> {
  final Map<OnState<TS>, ValueConsumer<TS>> patterns = {};

  StatedConsumer(void build(StatedConsumerPatternBuilder b)) {
    final builder = StatedConsumerPatternBuilder(patterns);
    build(builder);
  }

  void call(BuildContext context, TS stated) =>
      stated.matchPattern<ValueConsumer<TS>?>(patterns)?.call(context, stated);
}

class StatedConsumerPatternBuilder<TS extends Stated> {
  final Map<OnState<TS>, ValueConsumer<TS>> patterns;

  StatedConsumerPatternBuilder(this.patterns);

  void unit(OnState<TS> onState, ContextConsumer? builder) {
    if (builder != null) patterns[onState] = (c, _) => builder(c);
  }

  void value<T>(
    OnState<TS> onState,
    ValueConsumer<T>? builder,
  ) {
    if (builder != null) {
      patterns[onState] = (c, stated) => builder(c, stated.extractValue());
    }
  }

  void error(
    OnState<TS> onState,
    ValueConsumer<Object>? builder,
  ) {
    if (builder != null) {
      patterns[onState] = (c, stated) => builder(c, stated.extractError());
    }
  }
}
