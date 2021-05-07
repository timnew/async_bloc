import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/stated/stated.dart';
import 'package:stated_result/src/stated/base/unit_state_base.dart';

class StateA extends UnitStateBase<StateA> {
  const StateA();
}

class StateB extends UnitStateBase<StateB> {}

mixin UnionX {}

class UnionXStateA extends StateA with UnionX {
  UnionXStateA();
}

class UnionXStateB extends StateB with UnionX {
  UnionXStateB();
}

mixin UnionY {}

class UnionYStateA extends StateA with UnionY {
  const UnionYStateA();
}

void main() {
  group('UnitStateBase', () {
    final stateXA = UnionXStateA();
    final stateYA = const UnionYStateA();
    final stateXB = UnionXStateB();

    test("instances of same UnionState should equal to each other", () {
      final stateA_ = UnionXStateA();

      expect(stateXA, isNot(same(stateA_)));

      expect(stateXA, stateA_);
      expect(stateXA.hashCode, stateA_.hashCode);
    });

    test(
        "instance of the same state should equal to each other even if they are from different union",
        () {
      expect(stateXA, stateYA);
      expect(stateXA.hashCode, stateYA.hashCode);
    });

    test("instance of the different state should not equal", () {
      expect(stateXA, isNot(stateXB));
      expect(stateXA.hashCode, isNot(stateXB.hashCode));
    });

    test("union state type can have const constructor", () {
      expect(stateYA, same(const UnionYStateA()));
    });

    test("instance should be Stated", () {
      expect(stateXA, isInstanceOf<Stated>());
      expect(stateYA, isInstanceOf<Stated>());
    });

    test("toString() should get State name", () {
      expect(stateXA.toString(), "StateA");
      expect(stateYA.toString(), "StateA");
      expect(stateXB.toString(), "StateB");
    });
  });
}
