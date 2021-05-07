import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/stated/stated.dart';
import 'package:stated_result/src/stated/base/value_state_base.dart';
import 'package:stated_result/stated_result.dart';

class StateA extends ValueStateBase<String, StateA> {
  const StateA(String value) : super(value);
}

class StateB extends ValueStateBase<String, StateB> {
  const StateB(String value) : super(value);
}

mixin UnionX {}

class UnionXStateA extends StateA with UnionX {
  const UnionXStateA(String value) : super(value);
}

class UnionXStateB extends StateB with UnionX {
  const UnionXStateB(String value) : super(value);
}

mixin UnionY {}

class UnionYStateA extends StateA with UnionY {
  const UnionYStateA(String value) : super(value);
}

void main() {
  group('ValueStateBase', () {
    const value1 = "value1";
    const value2 = "value2";

    final stateXA11 = UnionXStateA(value1);
    final stateXA12 = UnionXStateA(value1);
    final stateXA21 = UnionXStateA(value2);
    final stateXB11 = UnionXStateB(value1);
    final stateYA11 = UnionYStateA(value1);

    test(
        "instances of same UnionState with same value should equal to each other",
        () {
      expect(stateXA11, isNot(same(stateXA12)));

      expect(stateXA11, stateXA12);
      expect(stateXA11.hashCode, stateXA12.hashCode);
    });

    test(
        "instances of same UnionState with different value should not equal to each other",
        () {
      expect(stateXA11, isNot(equals(stateXA21)));
      expect(stateXA11.hashCode, isNot(equals(stateXA21.hashCode)));
    });

    test(
        "instances of ths state with the same value but from different union should be equal to each other",
        () {
      expect(stateXA11, stateYA11);
      expect(stateXA11.hashCode, stateYA11.hashCode);
    });

    test(
        "instances with the same value but with different state should not equal to each other",
        () {
      expect(stateXA11, isNot(equals(stateXB11)));
      expect(stateXA11.hashCode, isNot(equals(stateXB11.hashCode)));
    });

    test("union state type can have const constructor", () {
      expect(const UnionXStateA(value1), same(const UnionXStateA(value1)));
    });

    test("instances should be instance of Stated", () {
      expect(
        [stateXA11, stateXA12, stateXA21, stateXB11, stateYA11],
        everyElement(isInstanceOf<Stated>()),
      );
    });

    test("instances should be instance of ValueResult", () {
      expect(stateXA11.value, value1);
      expect(stateXA21.value, value2);
    });

    test("toString() should contains State name and value", () {
      expect(stateXA11.toString(), "StateA(value1)");
      expect(stateXA21.toString(), "StateA(value2)");
      expect(stateXB11.toString(), "StateB(value1)");
      expect(stateYA11.toString(), "StateA(value1)");
    });
  });
}
