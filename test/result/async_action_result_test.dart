import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

import '../custom_matchers.dart';
import '../states.dart';

void main() {
  group("AsyncActionResult", () {
    group("factories", () {
      group("default constructor", () {
        final result = AsyncActionResult();

        test('should be an IdleState', () {
          expect(result, isInstanceOf<IdleState>());
        });

        test('should be constant', () {
          expect(AsyncActionResult(), same(result));
        });

        test("should have correct states", () {
          expect(result.isIdle, isTrue);
          expect(result.isWorking, isFalse);
          expect(result.isFinished, isFalse);
          expect(result.isSucceeded, isFalse);
          expect(result.isFailed, isFalse);
          expect(result.hasValue, isFalse);
          expect(result.hasError, isFalse);
        });
      });

      group(".working", () {
        final result = AsyncActionResult.working();

        test('should be a WorkingState', () {
          expect(result, isInstanceOf<WorkingState>());
        });

        test('should be constant', () {
          expect(AsyncActionResult.working(), same(result));
        });

        test("should have correct states", () {
          expect(result.isIdle, isFalse);
          expect(result.isWorking, isTrue);
          expect(result.isFinished, isFalse);
          expect(result.isSucceeded, isFalse);
          expect(result.isFailed, isFalse);
          expect(result.hasValue, isFalse);
          expect(result.hasError, isFalse);
        });
      });

      group(".completed", () {
        final result = AsyncActionResult.completed();

        test('should be a CompletedResult', () {
          expect(result, isInstanceOf<DoneState>());
        });

        test('should be constant', () {
          expect(AsyncActionResult.completed(), same(result));
        });

        test("should have correct states", () {
          expect(result.isIdle, isFalse);
          expect(result.isWorking, isFalse);
          expect(result.isFinished, isTrue);
          expect(result.isSucceeded, isTrue);
          expect(result.isFailed, isFalse);
          expect(result.hasValue, isFalse);
          expect(result.hasError, isFalse);
        });
      });

      group(".failed", () {
        final result = AsyncActionResult.failed(exception, stackTrace);

        test('should be a FailedResult', () {
          expect(result, isInstanceOf<ErrorState>());
        });

        test('should contain error and stack trace', () {
          expect(result, HasError(exception));
          expect(result, HasStackTrace(stackTrace));
        });

        test('can create result without stacktrace', () {
          final result = AsyncActionResult.failed(exception);

          expect(result, HasError(exception));
          expect(result, HasStackTrace(isNull));
        });

        test("should have correct states", () {
          expect(result.isIdle, isFalse);
          expect(result.isWorking, isFalse);
          expect(result.isFinished, isTrue);
          expect(result.isSucceeded, isFalse);
          expect(result.isFailed, isTrue);
          expect(result.hasValue, isFalse);
          expect(result.hasError, isTrue);
          expect(result.asError(), HasError(exception));
          expect(result.asError(), HasStackTrace(stackTrace));
        });
      });

      group(".from", () {
        test("idle", () {
          final result = AsyncActionResult.from(idle);
          expect(result, isInstanceOf<AsyncActionResult>());
          expect(result, isInstanceOf<IdleState>());
        });

        test("idleValue", () {
          final result = AsyncActionResult.from(idleValue);
          expect(result, isInstanceOf<AsyncActionResult>());
          expect(result, isInstanceOf<IdleState>());
        });

        test("working", () {
          final result = AsyncActionResult.from(working);
          expect(result, isInstanceOf<AsyncActionResult>());
          expect(result, isInstanceOf<WorkingState>());
        });

        test("working", () {
          final result = AsyncActionResult.from(workingValue);
          expect(result, isInstanceOf<AsyncActionResult>());
          expect(result, isInstanceOf<WorkingState>());
        });

        test("error", () {
          final result = AsyncActionResult.from(error);
          expect(result, isInstanceOf<AsyncActionResult>());
          expect(result, isInstanceOf<ErrorState>());
          expect(result, AsyncActionResult.failed(exception, stackTrace));
        });

        test("errorValue", () {
          final result = AsyncActionResult.from(errorValue);
          expect(result, isInstanceOf<AsyncActionResult>());
          expect(result, isInstanceOf<ErrorState>());
          expect(result, AsyncActionResult.failed(exception, stackTrace));
        });

        test("done", () {
          final result = AsyncActionResult.from(done);
          expect(result, isInstanceOf<AsyncActionResult>());
          expect(result, isInstanceOf<DoneState>());
        });
        test("doneValue", () {
          final result = AsyncActionResult.from(doneValue);
          expect(result, isInstanceOf<AsyncActionResult>());
          expect(result, isInstanceOf<DoneState>());
        });
      });
    });

    group(".updateWith", () {
      test("should update value with completed", () async {
        final initial = AsyncActionResult.idle();

        final future = Future<void>.value();
        final states = initial.updateWith(future);

        await expectLater(
          states,
          emitsInOrder([
            AsyncActionResult.working(),
            AsyncActionResult.completed(),
          ]),
        );
      });

      test("should update value with failed", () async {
        final initial = AsyncActionResult.idle();

        final future = Future<void>.error(exception);
        final states = initial.updateWith(future);

        await expectLater(
          states,
          emitsInOrder([
            AsyncActionResult.working(),
            predicate<AsyncActionResult>(
              (s) => s.isFailed && s.asError().error == exception,
              "is error",
            ),
          ]),
        );
      }, skip: "can't make it work");

      test("should update value with DoneState", () async {
        final initial = AsyncActionResult.idle();

        final future = Future.value(DoneState());
        final states = initial.updateWith(future);

        await expectLater(
          states,
          emitsInOrder([
            AsyncActionResult.working(),
            AsyncActionResult.completed(),
          ]),
        );
      });

      test("should update value with DoneValueState", () async {
        final initial = AsyncActionResult.idle();

        final future = Future.value(DoneValueState("value"));
        final states = initial.updateWith(future);

        await expectLater(
          states,
          emitsInOrder([
            AsyncActionResult.working(),
            AsyncActionResult.completed(),
          ]),
        );
      });

      test("should update value with ErrorState", () async {
        final initial = AsyncActionResult.idle();

        final future = Future.value(ErrorState(exception));
        final states = initial.updateWith(future);

        await expectLater(
          states,
          emitsInOrder([
            AsyncActionResult.working(),
            AsyncActionResult.failed(exception),
          ]),
        );
      });

      test("should update value with ErrroValueState", () async {
        final initial = AsyncActionResult.idle();

        final future = Future.value(ErrorValueState("value", exception, null));
        final states = initial.updateWith(future);

        await expectLater(
          states,
          emitsInOrder([
            AsyncActionResult.working(),
            AsyncActionResult.failed(exception),
          ]),
        );
      });

      test("should complains when call on waiting", () async {
        final initial = AsyncActionResult.working();

        final future = Future.value(ActionResult.completed());

        final states = initial.updateWith(future);

        await expectLater(states, emitsError(isInstanceOf<StateError>()));
      });
    });
  });
}
