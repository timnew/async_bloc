import 'package:flutter/widgets.dart';
import 'package:stated_result/stated.dart';

import 'stated_builder.dart';

class StatedValueBuilder<T> extends StatelessWidget {
  final Stated stated;

  final Widget? child;
  final ValueWidgetBuilder valueBuilder;

  final TransitionBuilder? idelBuilder;
  final TransitionBuilder? workingBuilder;
  final TransitionBuilder? doneBuilder;
  final ValueWidgetBuilder<HasError>? errorBuilder;

  const StatedValueBuilder({
    Key? key,
    required this.stated,
    required this.valueBuilder,
    this.child,
    this.idelBuilder,
    this.workingBuilder,
    this.doneBuilder,
    this.errorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StatedBuilder(
        stated: stated,
        child: stated.hasValue
            ? valueBuilder(context, stated.asValue(), child)
            : child,
        idleBuilder: idelBuilder,
        workingBuilder: workingBuilder,
        doneBuilder: doneBuilder,
        errorBuilder: errorBuilder,
      );
}
