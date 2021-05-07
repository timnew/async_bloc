import 'package:flutter/widgets.dart';
import 'package:stated_result/stated.dart';

class StatedBuilder<T> extends StatelessWidget {
  final Stated stated;
  final Widget? child;
  final ValueWidgetBuilder<T>? valueBuilder;
  final ValueWidgetBuilder<T>? idleValueBuilder;
  final TransitionBuilder? idleBuilder;
  final ValueWidgetBuilder<T>? workingValueBuilder;
  final TransitionBuilder? workingBuilder;
  final ValueWidgetBuilder<T>? doneValueBuilder;
  final TransitionBuilder? doneBuilder;
  final ValueWidgetBuilder<HasValueAndError<T>>? errorValueBuilder;
  final ValueWidgetBuilder<ErrorInfo>? errorBuilder;

  const StatedBuilder({
    Key? key,
    required this.stated,
    this.child,
    this.valueBuilder,
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
    final prebuiltChild = _prebuild(context);

    if (stated is IdleValueState && idleValueBuilder != null) {
      return idleValueBuilder!(context, stated.asValue(), prebuiltChild);
    }
    if (stated.isIdle) {
      return ensureBuilder(idleBuilder)(context, prebuiltChild);
    }
    if (stated is WorkingValueState && workingValueBuilder != null) {
      return workingValueBuilder!(context, stated.asValue(), prebuiltChild);
    }
    if (stated.isWorking) {
      return ensureBuilder(workingBuilder)(context, prebuiltChild);
    }
    if (stated is DoneValueState && doneValueBuilder != null) {
      return doneValueBuilder!(context, stated.asValue(), prebuiltChild);
    }
    if (stated.isSucceeded) {
      return ensureBuilder(doneBuilder)(context, prebuiltChild);
    }
    if (stated is ErrorValueState && errorValueBuilder != null) {
      return errorValueBuilder!(
        context,
        stated as ErrorValueState<T>,
        prebuiltChild,
      );
    }
    if (stated.isFailed) {
      return ensureBuilder(errorBuilder)(
        context,
        stated.asError(),
        prebuiltChild,
      );
    }

    return onBuilderNotFound(context, stated, prebuiltChild);
  }

  Widget? _prebuild(BuildContext context) => stated.hasValue
      ? valueBuilder?.call(context, stated.asValue(), child) ?? child
      : child;

  @protected
  TB ensureBuilder<TB>(TB? builder) => builder ?? cannotBuild();

  @protected
  Never cannotBuild() => throw StateError("No builder for $stated");

  @protected
  Widget onBuilderNotFound(
    BuildContext context,
    Stated stated,
    Widget? prebuiltChild,
  ) =>
      cannotBuild();
}
