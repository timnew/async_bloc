import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/stated/stated.dart';
import 'package:stated_result/src/stated/base/value_state_base.dart';
import 'package:stated_result/stated_result.dart';

import '../../custom_matchers.dart';

class StateA<T> extends ValueStateBase<T, StateA<T>> {
  const StateA(T value) : super(value);
}

class StateB<T> extends ValueStateBase<T, StateB<T>> {
  const StateB(T value) : super(value);
}

mixin UnionX {}

class UnionXStateA<T> extends StateA<T> with UnionX {
  const UnionXStateA(T value) : super(value);
}

class UnionXStateB<T> extends StateB<T> with UnionX {
  const UnionXStateB(T value) : super(value);
}

mixin UnionY {}

class UnionYStateA<T> extends StateA<T> with UnionY {
  const UnionYStateA(T value) : super(value);
}

void main() {
  group('ValueStateBase', () {
    const value1 = "value1";
    const value2 = "value2";
    const valueInt = 1;

    final stateXA1 = UnionXStateA(value1);
    final stateXA2 = UnionXStateA(value2);
    final stateXB1 = UnionXStateB(value1);
    final stateYA1 = UnionYStateA(value1);
    final stateXAInt = UnionXStateA(valueInt);

    test(
        "instances of same UnionState with same value should equal to each other",
        () {
      final stateXA1_ = UnionXStateA(value1);

      expect(stateXA1, isNot(same(stateXA1_)));

      expect(stateXA1, stateXA1_);
      expect(stateXA1.hashCode, stateXA1_.hashCode);
    });

    test(
        "instances of same UnionState with different value should not equal to each other",
        () {
      expect(stateXA1, isNot(stateXA2));
      expect(stateXA1.hashCode, isNot(stateXA2.hashCode));
    });
    test(
        "instances of same UnionState with different value type should not equal to each other",
        () {
      expect(stateXA1, isNot(stateXAInt));
      expect(stateXA1.hashCode, isNot(stateXAInt.hashCode));
    });

    test(
        "instances with the same value but with different state should not equal to each other",
        () {
      expect(stateXA1, isNot(stateXB1));
      expect(stateXA1.hashCode, isNot(stateXB1.hashCode));
    });

    test(
        "instances of ths state with the same value but from different union should be equal to each other",
        () {
      expect(stateXA1, stateYA1);
      expect(stateXA1.hashCode, stateYA1.hashCode);
    });

    test("union state type can have const constructor", () {
      expect(const UnionXStateA(value1), same(const UnionXStateA(value1)));
    });

    test("instances should be instance of Stated", () {
      expect(
        [stateXA1, stateXA2, stateXB1, stateYA1],
        everyElement(isInstanceOf<Stated>()),
      );

      expect(
        [stateXA1, stateXA2, stateXB1, stateYA1],
        everyElement(predicate<Stated>((s) => s.hasValue)),
      );

      expect(
        [stateXA1, stateXB1, stateYA1],
        everyElement(WithValue(value1)),
      );

      expect(stateXA2, WithValue(value2));
    });

    test("instances should be instance of ValueResult", () {
      expect(stateXA1.value, value1);
      expect(stateXA2.value, value2);
    });

    test("toString() should contains State name and value", () {
      expect(stateXA1.toString(), "StateA(value1)");
      expect(stateXA2.toString(), "StateA(value2)");
      expect(stateXB1.toString(), "StateB(value1)");
      expect(stateYA1.toString(), "StateA(value1)");
    });
  });
}
