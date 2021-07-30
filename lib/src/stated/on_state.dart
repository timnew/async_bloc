import 'package:stated_result/stated.dart';

/// Determine whether [stated] matches or not
typedef bool StatedPredict(Stated stated);

/// Describe a pattern to test against [Stated] when whether it is a [TS] with extra [criteria]
/// [OnState.matches] returns `true` if pattern matches.
class OnState<TS extends Stated> {
  /// Optional extra criteria other than the type check
  final StatedPredict? criteria;

  /// Create a new pattern to check wether a [Stated] is a [TS]
  /// Optional [criteria] can be provided
  const OnState([this.criteria]);

  /// Check wether [stated] matches or not
  bool matches(Stated stated) =>
      stated is TS && (criteria?.call(stated) ?? true);

  /// Stated is a idle state
  factory OnState.isIdle() => OnState((s) => s.isIdle);

  /// Stated is a working state
  factory OnState.isWorking() => OnState((s) => s.isWorking);

  /// Stated is a failed state
  factory OnState.isFailed() => OnState((s) => s.isFailed);

  /// Stated is a succeeded state
  factory OnState.isSuceeded() => OnState((s) => s.isSucceeded);

  /// Stated is either succeeded or failed
  factory OnState.isFinished() => OnState((s) => s.isFinished);

  /// Stated has value
  factory OnState.hasValue() => OnState((s) => s is HasValue);

  /// Stated has error
  factory OnState.hasError() => OnState((s) => s is HasError);

  /// Stated has both value and error
  factory OnState.hasValueAndError() => OnState((s) => s is HasValueAndError);

  /// Unconditionally true
  factory OnState.always() => const _Always();
}

class _Always<TS extends Stated> implements OnState<TS> {
  @override
  StatedPredict? get criteria => null;

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
