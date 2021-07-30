import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated.dart';
import 'package:stated_result/src/stated/base/error_state_base.dart';

import '../../custom_matchers.dart';

class StateA extends ErrorStateBase<StateA> {
  const StateA(Object error) : super(error);
}

class StateB extends ErrorStateBase<StateB> {
  const StateB(Object error) : super(error);
}

mixin UnionX {}

class UnionXStateA extends StateA with UnionX {
  const UnionXStateA(Object error) : super(error);
}

class UnionXStateB extends StateB with UnionX {
  const UnionXStateB(Object error) : super(error);
}

mixin UnionY {}

class UnionYStateA extends StateA with UnionY {
  const UnionYStateA(Object error) : super(error);
}

void main() {
  group("ErrorStateBase", () {
    const error1 = "error1";
    final error2 = "error2";

    final stateXA1 = UnionXStateA(error1);
    final stateXA2 = UnionXStateA(error2);
    final stateXB1 = UnionXStateB(error1);
    final stateYA1 = UnionYStateA(error1);

    test(
        "instances of same UnionState with same error and stackTrace should equal to each other",
        () {
      final stateXA1_ = UnionXStateA(error1);

      expect(stateXA1, isNot(same(stateXA1_)));

      expect(stateXA1, stateXA1_);
      expect(stateXA1.hashCode, stateXA1_.hashCode);
    });

    test(
        "instances of same UnionState with different error should not equal to each other",
        () {
      expect(stateXA1, isNot(stateXA2));
      expect(stateXA1.hashCode, isNot(stateXA2.hashCode));
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
      expect(
        const UnionXStateA(error1),
        same(const UnionXStateA(error1)),
      );
    });

    test("instances should be instance of Stated", () {
      expect(
        [stateXA1, stateXA2, stateXB1, stateYA1],
        everyElement(isInstanceOf<Stated>()),
      );

      expect(
        [stateXA1, stateXA2, stateXB1, stateYA1],
        everyElement(predicate<Stated>((s) => s.hasError)),
      );

      expect(
        [stateXA1, stateXB1, stateYA1],
        everyElement(WithError(error1)),
      );
      expect(stateXA2, WithError(error2));
    });

    test("instances should be instance of ValueResult", () {
      expect(stateXA1.error, error1);

      expect(stateXA2.error, error2);
    });

    test("toString() should contains State name and value", () {
      expect(stateXA1.toString(), "StateA(error1)");
      expect(stateXA2.toString(), "StateA(error2)");
      expect(stateXB1.toString(), "StateB(error1)");
      expect(stateYA1.toString(), "StateA(error1)");
    });
  });
}
