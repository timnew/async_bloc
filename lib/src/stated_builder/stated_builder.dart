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

  @override
  Widget build(BuildContext context) => stated
      .matchPattern<ValueWidgetBuilder<TS>>(patterns)
      .call(context, stated, child);

  static ValueWidgetBuilder<Stated> buildAsUnit(TransitionBuilder builder) =>
      (c, _, child) => builder(c, child);

  static ValueWidgetBuilder<Stated> buildAsValue<T>(
    ValueWidgetBuilder<T> valueBuilder,
  ) =>
      (c, stated, child) => valueBuilder(c, stated.extractValue(), child);

  static ValueWidgetBuilder<Stated> buildAsError(
          ValueWidgetBuilder<Object> errorBuilder) =>
      (c, stated, child) => errorBuilder(c, stated.extractError(), child);
}
