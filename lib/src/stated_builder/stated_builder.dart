import 'package:flutter/widgets.dart';
import 'package:stated_result/stated.dart';

class StatedBuilder<T> extends StatelessWidget {
  final Stated stated;
  final Widget? child;
  final ValueWidgetBuilder<T>? idleValueBuilder;
  final TransitionBuilder? idleBuilder;
  final ValueWidgetBuilder<T>? workingValueBuilder;
  final TransitionBuilder? workingBuilder;
  final ValueWidgetBuilder<T>? doneValueBuilder;
  final TransitionBuilder? doneBuilder;
  final ValueWidgetBuilder<HasValueAndError<T>>? errorValueBuilder;
  final ValueWidgetBuilder<HasError>? errorBuilder;

  const StatedBuilder({
    Key? key,
    required this.stated,
    this.child,
    this.idleValueBuilder,
    this.idleBuilder,
    this.workingValueBuilder,
    this.workingBuilder,
    this.doneValueBuilder,
    this.doneBuilder,
    this.errorValueBuilder,
    this.errorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stated is IdleValueState && idleValueBuilder != null) {
      return idleValueBuilder!(context, stated.asValue(), child);
    }
    if (stated.isIdle) {
      return _ensure(idleBuilder)(context, child);
    }
    if (stated is WorkingValueState && workingValueBuilder != null) {
      return workingValueBuilder!(context, stated.asValue(), child);
    }
    if (stated.isWorking) {
      return _ensure(workingBuilder)(context, child);
    }
    if (stated is DoneValueState && doneValueBuilder != null) {
      return doneValueBuilder!(context, stated.asValue(), child);
    }
    if (stated.isSucceeded) {
      return _ensure(doneBuilder)(context, child);
    }
    if (stated is ErrorValueState && errorValueBuilder != null) {
      return errorValueBuilder!(context, stated as ErrorValueState<T>, child);
    }
    if (stated.isFailed) {
      return _ensure(errorBuilder)(context, stated.asError(), child);
    }
    throwNoBuilderError();
  }

  TB _ensure<TB>(TB? builder) => builder ?? throwNoBuilderError();

  Never throwNoBuilderError() => throw StateError("No builder for $stated");
}
