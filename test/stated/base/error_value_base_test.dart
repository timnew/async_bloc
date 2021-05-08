import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/stated/base/value_error_state_base.dart';
import 'package:stated_result/src/stated/stated.dart';
import 'package:stated_result/stated_result.dart';

import '../../custom_matchers.dart';

class StateA<T> extends ValueErrorStateBase<T, StateA<T>> {
  const StateA(T value, Object error, [StackTrace? stackTrace])
      : super(value, error, stackTrace);
}

class StateB<T> extends ValueErrorStateBase<T, StateB<T>> {
  const StateB(T value, Object error, [StackTrace? stackTrace])
      : super(value, error, stackTrace);
}

mixin UnionX {}

class UnionXStateA<T> extends StateA<T> with UnionX {
  const UnionXStateA(T value, Object error, [StackTrace? stackTrace])
      : super(value, error, stackTrace);
}

class UnionXStateB<T> extends StateB<T> with UnionX {
  const UnionXStateB(T value, Object error, [StackTrace? stackTrace])
      : super(value, error, stackTrace);
}

mixin UnionY {}

class UnionYStateA<T> extends StateA<T> with UnionY {
  const UnionYStateA(T value, Object error, [StackTrace? stackTrace])
      : super(value, error, stackTrace);
}

void main() {
  group('ValueStateBase', () {
    const value1 = "value1";
    const value2 = "value2";
    const valueInt = 1;
    const error1 = "error1";
    const error2 = "error2";
    const stackTrace = StackTrace.empty;
    final stackTrace2 = StackTrace.fromString("another");

    final stateXA11 = UnionXStateA(value1, error1, stackTrace);
    final stateXA12 = UnionXStateA(value1, error2, stackTrace);
    final stateXA11s = UnionXStateA(value1, error1, stackTrace2);
    final stateXA21 = UnionXStateA(value2, error1, stackTrace);
    final stateXB11 = UnionXStateB(value1, error1, stackTrace);
    final stateYA11 = UnionYStateA(value1, error1, stackTrace);
    final stateXAInt1 = UnionXStateA(valueInt, error1, stackTrace);

    test(
        "instances of same UnionState with same value, error and stackTrace should equal to each other",
        () {
      final stateXA11_ = UnionXStateA(value1, error1, stackTrace);

      expect(stateXA11, isNot(same(stateXA11_)));

      expect(stateXA11, stateXA11_);
      expect(stateXA11.hashCode, stateXA11_.hashCode);
    });

    test(
        "instances of same UnionState with different value should not equal to each other",
        () {
      expect(stateXA11, isNot(stateXA21));
      expect(stateXA11.hashCode, isNot(stateXA21.hashCode));
    });

    test(
        "instances of same UnionState with different error should not equal to each other",
        () {
      expect(stateXA11, isNot(stateXA12));
      expect(stateXA11.hashCode, isNot(stateXA12.hashCode));
    });

    test(
        "instances of same UnionState with different stackTrace should not equal to each other",
        () {
      expect(stateXA11, isNot(stateXA11s));
      expect(stateXA11.hashCode, isNot(stateXA11s.hashCode));
    });

    test(
        "instances of same UnionState with different value type should not equal to each other",
        () {
      expect(stateXA11, isNot(stateXAInt1));
      expect(stateXA11.hashCode, isNot(stateXAInt1.hashCode));
    });

    test(
        "instances with the same value but with different state should not equal to each other",
        () {
      expect(stateXA11, isNot(stateXB11));
      expect(stateXA11.hashCode, isNot(stateXB11.hashCode));
    });

    test(
        "instances of ths state with the same value but from different union should be equal to each other",
        () {
      expect(stateXA11, stateYA11);
      expect(stateXA11.hashCode, stateYA11.hashCode);
    });

    test("union state type can have const constructor", () {
      expect(
        const UnionXStateA(value1, error1, stackTrace),
        same(const UnionXStateA(value1, error1, stackTrace)),
      );
    });

    test("instances should be instance of Stated", () {
      expect(
        [
          stateXA11,
          stateXA12,
          stateXA11s,
          stateXA21,
          stateXB11,
          stateYA11,
          stateXAInt1,
        ],
        everyElement(isInstanceOf<Stated>()),
      );

      expect(
        [
          stateXA11,
          stateXA12,
          stateXA11s,
          stateXA21,
          stateXB11,
          stateYA11,
          stateXAInt1,
        ],
        everyElement(predicate<Stated>((s) => s.hasValue)),
      );

      expect(
        [
          stateXA11,
          stateXA12,
          stateXA11s,
          stateXB11,
          stateYA11,
        ],
        everyElement(WithValue(value1)),
      );
      expect(stateXAInt1, WithValue(valueInt));
      expect(stateXA21, WithValue(value2));

      expect(
        [
          stateXA11,
          stateXA12,
          stateXA11s,
          stateXA21,
          stateXB11,
          stateYA11,
          stateXAInt1,
        ],
        everyElement(predicate<Stated>((s) => s.hasError)),
      );

      expect(
        [
          stateXA11,
          stateXA11s,
          stateXA21,
          stateXB11,
          stateYA11,
          stateXAInt1,
        ],
        everyElement(WithError(error1)),
      );
      expect(stateXA12, WithError(error2));

      expect(
        [
          stateXA11,
          stateXA12,
          stateXA21,
          stateXB11,
          stateYA11,
          stateXAInt1,
        ],
        everyElement(WithStackTrace(stackTrace)),
      );
    });

    test("instances should has proper value", () {
      expect(stateXA11.value, value1);
      expect(stateXA21.value, value2);
      expect(stateXAInt1.value, valueInt);
    });

    test("instances should has proper error", () {
      expect(stateXA11.error, error1);
      expect(stateXA11.stackTrace, stackTrace);

      expect(stateXA12.error, error2);
      expect(stateXA11.stackTrace, stackTrace);
    });

    test("toString() should contains State name and value", () {
      expect(stateXA11.toString(), "StateA<String>(value1, error1)");
      expect(stateXA21.toString(), "StateA<String>(value2, error1)");
      expect(stateXB11.toString(), "StateB<String>(value1, error1)");
      expect(stateYA11.toString(), "StateA<String>(value1, error1)");
      expect(stateXAInt1.toString(), "StateA<int>(1, error1)");
    });
  });
}
