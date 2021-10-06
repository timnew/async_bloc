import 'package:stated_result/stated_custom.dart';

abstract class TestStated implements Stated {
  const factory TestStated.unit() = TestUnitState;
  const factory TestStated.value(String value) = TestValueState;
  const factory TestStated.error(Object error) = TestErrorState;
  const factory TestStated.succeeded() = TestSucceededState;
}

class TestUnitState extends UnitStateBase<TestUnitState> with TestStated {
  const TestUnitState();
}

class TestValueState extends ValueStateBase<String, TestValueState>
    with TestStated {
  const TestValueState(String value) : super(value);
}

class TestErrorState extends ErrorStateBase<TestErrorState> with TestStated {
  const TestErrorState(Object error) : super(error);
}

class TestSucceededState extends SucceededState with TestStated {
  const TestSucceededState();
}
