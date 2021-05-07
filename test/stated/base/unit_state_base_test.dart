import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/src/stated/stated.dart';
import 'package:stated_result/src/stated/base/unit_state_base.dart';

class StateA extends UnitStateBase<StateA> {
  const StateA();
}

mixin UnionX {}

class UnionXStateA extends StateA with UnionX {
  UnionXStateA();
}

mixin UnionY {}

class UnionBState extends StateA with UnionY {
  const UnionBState();
}

void main() {
  group('UnitStateBase', () {
    final stateA1 = UnionXStateA();
    final stateA2 = UnionXStateA();
    final stataB = const UnionBState();

    test("instances of same UnionState should equal to each other", () {
      expect(stateA1, isNot(same(stateA2)));

      expect(stateA1, stateA2);
      expect(stateA1.hashCode, stateA2.hashCode);
    });

    test(
        "instance of the same state should equal to each other even if they are from different union",
        () {
      expect(stateA1, stataB);
      expect(stateA1.hashCode, stataB.hashCode);
    });

    test("union state type can have const constructor", () {
      expect(stataB, same(const UnionBState()));
    });

    test("instance should be Stated", () {
      expect(stateA1, isInstanceOf<Stated>());
      expect(stataB, isInstanceOf<Stated>());
    });

    test("toString() should get State name", () {
      expect(stateA1.toString(), "TestState");
      expect(stataB.toString(), "TestState");
    });
  });
}
