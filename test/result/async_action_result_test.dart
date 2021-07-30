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
        final result = AsyncActionResult.succeeded();

        test('should be a CompletedResult', () {
          expect(result, isInstanceOf<SucceededState>());
        });

        test('should be constant', () {
          expect(AsyncActionResult.succeeded(), same(result));
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
        final result = AsyncActionResult.failed(exception);

        test('should be a FailedResult', () {
          expect(result, isInstanceOf<FailedState>());
        });

        test('should contain error and stack trace', () {
          expect(result, WithError(exception));
        });

        test("should have correct states", () {
          expect(result.isIdle, isFalse);
          expect(result.isWorking, isFalse);
          expect(result.isFinished, isTrue);
          expect(result.isSucceeded, isFalse);
          expect(result.isFailed, isTrue);
          expect(result.hasValue, isFalse);
          expect(result.hasError, isTrue);
          expect(result.extractError(), exception);
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
          expect(result, isInstanceOf<FailedState>());
          expect(result, AsyncActionResult.failed(exception));
        });

        test("errorValue", () {
          final result = AsyncActionResult.from(errorValue);
          expect(result, isInstanceOf<AsyncActionResult>());
          expect(result, isInstanceOf<FailedState>());
          expect(result, AsyncActionResult.failed(exception));
        });

        test("done", () {
          final result = AsyncActionResult.from(done);
          expect(result, isInstanceOf<AsyncActionResult>());
          expect(result, isInstanceOf<SucceededState>());
        });
        test("doneValue", () {
          final result = AsyncActionResult.from(doneValue);
          expect(result, isInstanceOf<AsyncActionResult>());
          expect(result, isInstanceOf<SucceededState>());
        });
      });
    });

    group(".updateWith", () {
      late List<AsyncActionResult> captured;

      setUp(() {
        captured = <AsyncActionResult>[];
      });

      test("should update value with completed", () async {
        final initial = AsyncActionResult.idle();
        final future = Future<void>.value();

        await initial.updateWith(future, captured.add);

        expect(
          captured,
          containsAllInOrder([
            AsyncActionResult.working(),
            AsyncActionResult.succeeded(),
          ]),
        );
      });

      test("should update value with failed", () async {
        final initial = AsyncActionResult.idle();
        final future = Future<void>.error(exception);

        await initial.updateWith(future, captured.add);

        expect(
          captured,
          containsAllInOrder([
            AsyncActionResult.working(),
            predicate<AsyncActionResult>(
              (s) => s.isFailed && s.extractError() == exception,
              "is error",
            ),
          ]),
        );
      });

      test("should update value with DoneState", () async {
        final initial = AsyncActionResult.idle();
        final future = Future.value(SucceededState());

        await initial.updateWith(future, captured.add);

        expect(
          captured,
          containsAllInOrder([
            AsyncActionResult.working(),
            AsyncActionResult.succeeded(),
          ]),
        );
      });

      test("should update value with DoneValueState", () async {
        final initial = AsyncActionResult.idle();
        final future = Future.value(SucceededValueState("value"));

        await initial.updateWith(future, captured.add);

        expect(
          captured,
          containsAllInOrder([
            AsyncActionResult.working(),
            AsyncActionResult.succeeded(),
          ]),
        );
      });

      test("should update value with ErrorState", () async {
        final initial = AsyncActionResult.idle();
        final future = Future.value(FailedState(exception));

        await initial.updateWith(future, captured.add);

        expect(
          captured,
          containsAllInOrder([
            AsyncActionResult.working(),
            AsyncActionResult.failed(exception),
          ]),
        );
      });

      test("should update value with ErrroValueState", () async {
        final initial = AsyncActionResult.idle();
        final future = Future.value(FailedValueState("value", exception));

        await initial.updateWith(future, captured.add);

        expect(
          captured,
          containsAllInOrder([
            AsyncActionResult.working(),
            AsyncActionResult.failed(exception),
          ]),
        );
      });

      test("should complains when call on waiting", () async {
        final initial = AsyncActionResult.working();
        final future = Future.value(ActionResult.succeeded());

        await expectLater(
          initial.updateWith(future, captured.add),
          throwsStateError,
        );
      });
    });
  });
}
