import 'package:stated_result/stated.dart';

typedef bool StatedPredict(Stated stated);

class OnState<TS extends Stated> {
  final StatedPredict? condition;

  const OnState([this.condition]);

  bool matches(Stated stated) =>
      stated is TS && (condition?.call(stated) ?? true);

  factory OnState.isIdle() => OnState((s) => s.isIdle);
  factory OnState.isWorking() => OnState((s) => s.isWorking);
  factory OnState.isFailed() => OnState((s) => s.isFailed);
  factory OnState.isSuceeded() => OnState((s) => s.isSucceeded);
  factory OnState.isFinished() => OnState((s) => s.isFinished);

  factory OnState.hasValue() => OnState((s) => s is HasValue);
  factory OnState.hasError() => OnState((s) => s is HasError);
  factory OnState.hasValueAndError() => OnState((s) => s is HasValueAndError);

  factory OnState.always() => const _Always();
}

class _Always<TS extends Stated> implements OnState<TS> {
  @override
  StatedPredict? get condition => null;

  @override
  bool matches(Stated stated) => true;

  const _Always();
}

extension StatedMatchExtension on Stated {
  TR matchPattern<TR>(Map<OnState, TR> patterns) {
    try {
      return patterns.entries.firstWhere((p) => p.key.matches(this)).value;
    } on StateError {
      throw StateError("Unexpected state $this");
    }
  }
}
